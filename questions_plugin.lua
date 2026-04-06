-- Plugin Lua pour afficher des questions depuis un fichier TXT ou CSV dans OBS
-- Version 1.6.0 - Customizable Source Name

obs = obslua

questions = {}
file_path = ""
source_name = "" -- Nueva variable global para el nombre de la fuente

----------------------------------------------------------
function script_description()
    return "Plugin pour afficher les questions à partir d'un fichier .txt ou .csv.\n1. Renseignez le nom de votre source texte.\n2. Sélectionnez votre fichier.\n(Si les questions ne s'affichent pas, fermez et rouvrez la fenêtre du script)."
end

----------------------------------------------------------
function script_properties()
    local props = obs.obs_properties_create()

    -- Nuevo campo para que el usuario escriba el nombre de su fuente de texto
    obs.obs_properties_add_text(props, "source_name", "Nom de la source Texte (GDI+)", obs.OBS_TEXT_DEFAULT)

    obs.obs_properties_add_path(props, "file_path", "Fichier de questions", obs.OBS_PATH_FILE, "*.txt;*.csv", nil)

    local list = obs.obs_properties_add_list(props, "question_list", "Sélectionner la question à afficher",
        obs.OBS_COMBO_TYPE_LIST, obs.OBS_COMBO_FORMAT_STRING)

    for i, q in ipairs(questions) do
        obs.obs_property_list_add_string(list, q, q)
    end

    obs.obs_properties_add_button(props, "reload_btn", "Recharger les questions", reload_questions)
    obs.obs_properties_add_button(props, "clear_btn", "Effacer de l'écran", clear_text)

    return props
end

----------------------------------------------------------
function script_update(settings)
    -- Guardar el nombre de la fuente que el usuario escribió
    source_name = obs.obs_data_get_string(settings, "source_name")

    local new_path = obs.obs_data_get_string(settings, "file_path")

    if new_path ~= file_path and new_path ~= "" then
        file_path = new_path
        load_questions(file_path)
        print("Questions chargées. Fermez et rouvrez la fenêtre du script pour voir la liste.")
    end

    local selected = obs.obs_data_get_string(settings, "question_list")
    if selected ~= nil and selected ~= "" then
        show_question(selected)
    end
end

----------------------------------------------------------
function reload_questions(props, prop)
    if file_path ~= nil and file_path ~= "" then
        load_questions(file_path)
        local list = obs.obs_properties_get(props, "question_list")
        if list then
            obs.obs_property_list_clear(list)
            for i, q in ipairs(questions) do
                obs.obs_property_list_add_string(list, q, q)
            end
        end
        return true
    else
        print("Aucun fichier sélectionné.")
        return false
    end
end

----------------------------------------------------------
function load_questions(path)
    questions = {}
    local ext = string.lower(string.match(path, "%.([^.]+)$") or "")
    local file = io.open(path, "r")

    if not file then
        print("Impossible d'ouvrir le fichier " .. path)
        return
    end

    local first_line = true
    for line in file:lines() do
        line = trim(line)
        if line ~= "" then
            if ext == "csv" then
                if not first_line then
                    local q = string.match(line, "([^,;]+)")
                    if q then table.insert(questions, q) end
                else
                    first_line = false
                end
            else
                table.insert(questions, line)
            end
        end
    end
    file:close()

    print(#questions .. " questions chargées depuis " .. path)
end

----------------------------------------------------------
function show_question(question)
    -- Verificamos que el usuario haya escrito un nombre de fuente
    if source_name == nil or source_name == "" then
        print("Erreur : Veuillez entrer le nom de la source texte dans les paramètres.")
        return
    end

    -- Usamos la variable global en lugar del texto fijo
    local source = obs.obs_get_source_by_name(source_name)

    if source ~= nil then
        local settings = obs.obs_data_create()
        obs.obs_data_set_string(settings, "text", question)
        obs.obs_source_update(source, settings)
        obs.obs_data_release(settings)
        obs.obs_source_release(source)
    else
        print("Source '" .. source_name .. "' non trouvée. Vérifiez l'orthographe.")
    end
end

----------------------------------------------------------
function clear_text(props, prop)
    show_question("")
end

----------------------------------------------------------
function trim(s)
    return (s:gsub("^%s*(.-)%s*$", "%1"))
end
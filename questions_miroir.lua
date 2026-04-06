-- Plugin Lua pour faire un miroir des questions depuis Question Bij
-- Version 1.3 - Stable

obs = obslua

source_original_name = ""
source_mirror_name = ""

----------------------------------------------------------
function script_properties()
    local props = obs.obs_properties_create()
    obs.obs_properties_add_text(props, "source_original_name", "Source original (Question Bij)", obs.OBS_TEXT_DEFAULT)
    obs.obs_properties_add_text(props, "source_mirror_name", "Source miroir (Miroir question)", obs.OBS_TEXT_DEFAULT)
    return props
end

----------------------------------------------------------
function script_update(settings)
    source_original_name = obs.obs_data_get_string(settings, "source_original_name")
    source_mirror_name   = obs.obs_data_get_string(settings, "source_mirror_name")
end

----------------------------------------------------------
function script_tick(seconds)
    if source_original_name == "" or source_mirror_name == "" then return end

    local src_original = obs.obs_get_source_by_name(source_original_name)
    local src_mirror   = obs.obs_get_source_by_name(source_mirror_name)

    if src_original == nil or src_mirror == nil then
        if src_original then obs.obs_source_release(src_original) end
        if src_mirror then obs.obs_source_release(src_mirror) end
        return
    end
    
    -- Copier le texte
    local settings_original = obs.obs_source_get_settings(src_original)
    local text_value = obs.obs_data_get_string(settings_original, "text")

    local settings_mirror = obs.obs_source_get_settings(src_mirror)
    obs.obs_data_set_string(settings_mirror, "text", text_value)
    obs.obs_source_update(src_mirror, settings_mirror)

    obs.obs_data_release(settings_original)
    obs.obs_data_release(settings_mirror)

    -- Copier la visibilité
    local scene = obs.obs_frontend_get_current_scene()
    if scene ~= nil then
        local scene_ptr = obs.obs_scene_from_source(scene)
        local item_original = obs.obs_scene_find_source_recursive(scene_ptr, source_original_name)
        local item_mirror   = obs.obs_scene_find_source_recursive(scene_ptr, source_mirror_name)

        if item_original ~= nil and item_mirror ~= nil then
            local visible = obs.obs_sceneitem_visible(item_original)
            obs.obs_sceneitem_set_visible(item_mirror, visible)
        end

        obs.obs_source_release(scene)
    end

    obs.obs_source_release(src_original)
    obs.obs_source_release(src_mirror)
end
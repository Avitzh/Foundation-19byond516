/datum/tgui/hair_picker
    var/datum/preferences/prefs

/datum/tgui/hair_picker/New(datum/preferences/prefs)
    src.prefs = prefs

/datum/tgui/hair_picker/tgui_state(mob/user)
    return GLOB.always_tgui_state

/datum/tgui/hair_picker/tgui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        // Второй аргумент – заголовок окна, можно задать любой
        ui = new(user, src, "HairPicker", "Hair Picker")
        ui.open()

/datum/tgui/hair_picker/tgui_static_data(mob/user)
    var/list/hairstyles = list()
    if(!prefs)
        return list("hairstyles" = hairstyles)

    var/datum/species/mob_species = all_species[prefs.species]
    if(!mob_species)
        return list("hairstyles" = hairstyles)

    var/list/valid_hairstyles = mob_species.get_hair_styles()
    if(!islist(valid_hairstyles) || !length(valid_hairstyles))
        return list("hairstyles" = hairstyles)

    // Считываем все состояния нужных DMI
    var/list/dmi_states = list()
    for(var/style_name in valid_hairstyles)
        var/datum/sprite_accessory/hair/HS = GLOB.hair_styles_list[style_name]
        if(!HS) continue
        if(!dmi_states[HS.icon])
            dmi_states[HS.icon] = icon_states(HS.icon, 1)

    for(var/style_name in valid_hairstyles)
        var/datum/sprite_accessory/hair/HS = GLOB.hair_styles_list[style_name]
        if(!HS) continue

        var/list/states = dmi_states[HS.icon]
        var/final_state = null
        for(var/state in states)
            if(state == "[HS.icon_state]_s" || state == "[HS.icon_state]_l" || state == "[HS.icon_state]")
                final_state = state
                break
        if(!final_state)
            for(var/state in states)
                if(findtext(state, HS.icon_state) == 1)
                    final_state = state
                    break
        if(!final_state)
            final_state = "bald"

        var/icon/hair_icon = icon(HS.icon, final_state, SOUTH)
        if(!hair_icon)
            hair_icon = icon(HS.icon, "bald", SOUTH)

        // Отправляем иконку как ресурс браузера
        // BYOND resource keys are best kept simple (no spaces)
        var/safe_style_name = replacetext("[style_name]", " ", "_")
        var/rsc_key = "hairstyle_[safe_style_name].png"
        send_rsc(user, hair_icon, rsc_key)

        hairstyles += list(list(
            "name" = HS.name,
            "rsc_key" = rsc_key
        ))

    return list("hairstyles" = hairstyles)

/datum/tgui/hair_picker/tgui_data(mob/user)
    return list("selected" = prefs.h_style)

/datum/tgui/hair_picker/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
    . = ..()
    if(action == "select")
        prefs.h_style = params["style"]
        // Update the character preview in the preferences browser.
        prefs.update_preview_icon()
        var/mob/M = ui?.user || usr
        if(M)
            prefs.update_setup_window(M)
        return TRUE

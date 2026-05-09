/datum/tgui/hair_picker
    var/datum/preferences/prefs

/datum/tgui/hair_picker/New(datum/preferences/prefs)
    src.prefs = prefs

/datum/tgui/hair_picker/tgui_interact(mob/user, datum/tgui/ui)
    ui = SStgui.try_update_ui(user, src, ui)
    if(!ui)
        ui = new(user, src, "HairPicker", "HairPicker")
        ui.open()

/datum/tgui/hair_picker/tgui_static_data(mob/user)
    var/list/hairstyles = list()
    for(var/style_name in GLOB.hair_styles_list)
        var/datum/sprite_accessory/hair/HS = GLOB.hair_styles_list[style_name]
        hairstyles += list(list(
            "name" = HS.name,
            "icon" = "[HS.icons/mob/human_races/species/human/hair.dmi]",
            "icon_state" = HS.icon_state
        ))
    return list("hairstyles" = hairstyles)

/datum/tgui/hair_picker/tgui_data(mob/user)
    return list("selected" = prefs.h_style)

/datum/tgui/hair_picker/tgui_act(action, list/params, datum/tgui/ui)
    if(action == "select")
        prefs.h_style = params["style"]
        prefs.update_preview_icon()  // обновляем статичное превью
        SStgui.update_uis(prefs)    // если открыто окно превью персонажа (если будете делать):
        return TRUE

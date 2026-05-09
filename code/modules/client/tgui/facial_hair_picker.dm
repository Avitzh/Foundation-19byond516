/datum/tgui/facial_hair_picker
	var/datum/preferences/prefs

/datum/tgui/facial_hair_picker/New(datum/preferences/prefs)
	src.prefs = prefs

/datum/tgui/facial_hair_picker/tgui_state(mob/user)
	return GLOB.always_tgui_state

/datum/tgui/facial_hair_picker/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FacialHairPicker", "Facial Hair Picker")
		ui.open()

/datum/tgui/facial_hair_picker/tgui_static_data(mob/user)
	var/list/styles = list()
	if(!prefs)
		return list("styles" = styles)

	var/datum/species/mob_species = all_species[prefs.species]
	if(!mob_species)
		return list("styles" = styles)

	var/list/valid_styles = mob_species.get_facial_hair_styles(prefs.gender)
	if(!islist(valid_styles) || !length(valid_styles))
		return list("styles" = styles)

	// Pre-cache icon states for the facial hair DMI.
	var/icon/facial_icon_file = 'icons/mob/human_races/species/human/facial.dmi'
	var/list/states = icon_states(facial_icon_file, 1)

	for(var/style_name in valid_styles)
		var/datum/sprite_accessory/facial_hair/FH = GLOB.facial_hair_styles_list[style_name]
		if(!FH)
			continue

		var/final_state = null
		// Prefer exact matches and common suffixes.
		for(var/state in states)
			if(state == "[FH.icon_state]_s" || state == "[FH.icon_state]_l" || state == "[FH.icon_state]")
				final_state = state
				break
		if(!final_state)
			for(var/state in states)
				if(findtext(state, FH.icon_state) == 1)
					final_state = state
					break
		if(!final_state)
			final_state = "shaved"

		var/icon/facial_icon = icon(facial_icon_file, final_state, SOUTH)
		if(!facial_icon)
			facial_icon = icon(facial_icon_file, "shaved", SOUTH)

		var/safe_style_name = replacetext("[style_name]", " ", "_")
		var/rsc_key = "facial_[safe_style_name].png"
		send_rsc(user, facial_icon, rsc_key)

		styles += list(list(
			"name" = FH.name,
			"rsc_key" = rsc_key
		))

	return list("styles" = styles)

/datum/tgui/facial_hair_picker/tgui_data(mob/user)
	return list("selected" = prefs.f_style)

/datum/tgui/facial_hair_picker/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(action == "select")
		prefs.f_style = params["style"]
		prefs.update_preview_icon()
		var/mob/M = ui?.user || usr
		if(M)
			prefs.update_setup_window(M)
		return TRUE


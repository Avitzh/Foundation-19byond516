var/global/list/valid_bloodtypes = list("A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-")

/datum/preferences
	var/species = SPECIES_HUMAN
	var/b_type = "O-"					//blood type (not-chooseable)
	var/h_style = "Bald"				//Hair type
	var/r_hair = 0						//Hair color
	var/g_hair = 0						//Hair color
	var/b_hair = 0						//Hair color
	var/f_style = "Shaved"				//Face hair type
	var/r_facial = 0					//Face hair color
	var/g_facial = 0					//Face hair color
	var/b_facial = 0					//Face hair color
	var/s_tone = 0						//Skin tone
	var/r_skin = 0						//Skin color
	var/g_skin = 0						//Skin color
	var/b_skin = 0						//Skin color
	var/r_eyes = 0						//Eye color
	var/g_eyes = 0						//Eye color
	var/b_eyes = 0						//Eye color
	var/s_base = ""						//Base skin colour
	var/list/body_markings = list()
	var/list/body_descriptors = list()

	// maps each organ to either null(intact), "cyborg" or "amputated"
	// will probably not be able to do this for head and torso ;)
	var/list/organ_data
	var/list/rlimb_data
	var/char_nearsighted = 0

	var/equip_preview_mob = EQUIP_PREVIEW_ALL

	var/icon/bgstate = "000"
	var/list/bgstate_options = list("000", "FFF", MATERIAL_STEEL, "white")

/datum/category_item/player_setup_item/physical/body
	name = "Тело"
	sort_order = 2
	var/hide_species = TRUE

/datum/category_item/player_setup_item/physical/body/load_character(datum/pref_record_reader/R)
	pref.species = R.read("species")
	if(R.get_version() < 2 && pref.species == "booster")
		pref.species = "human"
	pref.r_hair = R.read("hair_red")
	pref.g_hair = R.read("hair_green")
	pref.b_hair = R.read("hair_blue")
	pref.r_facial = R.read("facial_red")
	pref.g_facial = R.read("facial_green")
	pref.b_facial = R.read("facial_blue")
	pref.s_tone = R.read("skin_tone")
	pref.r_skin = R.read("skin_red")
	pref.g_skin = R.read("skin_green")
	pref.b_skin = R.read("skin_blue")
	pref.s_base = R.read("skin_base")
	pref.h_style = R.read("hair_style_name")
	pref.f_style = R.read("facial_style_name")
	pref.r_eyes = R.read("eyes_red")
	pref.g_eyes = R.read("eyes_green")
	pref.b_eyes = R.read("eyes_blue")
	pref.b_type = R.read("b_type")
	pref.char_nearsighted = R.read("char_nearsighted")
	pref.organ_data = R.read("organ_data")
	pref.rlimb_data = R.read("rlimb_data")
	pref.body_markings = R.read("body_markings")
	pref.body_descriptors = R.read("body_descriptors")
	pref.preview_icon = null
	pref.bgstate = R.read("bgstate")

/datum/category_item/player_setup_item/physical/body/save_character(datum/pref_record_writer/W)
	W.write("species", pref.species)
	W.write("hair_red", pref.r_hair)
	W.write("hair_green", pref.g_hair)
	W.write("hair_blue", pref.b_hair)
	W.write("facial_red", pref.r_facial)
	W.write("facial_green", pref.g_facial)
	W.write("facial_blue", pref.b_facial)
	W.write("skin_tone", pref.s_tone)
	W.write("skin_red", pref.r_skin)
	W.write("skin_green", pref.g_skin)
	W.write("skin_base", pref.s_base)
	W.write("skin_blue", pref.b_skin)
	W.write("hair_style_name", pref.h_style)
	W.write("facial_style_name", pref.f_style)
	W.write("eyes_red", pref.r_eyes)
	W.write("eyes_green", pref.g_eyes)
	W.write("eyes_blue", pref.b_eyes)
	W.write("b_type", pref.b_type)
	W.write("char_nearsighted", pref.char_nearsighted)
	W.write("organ_data", pref.organ_data)
	W.write("rlimb_data", pref.rlimb_data)
	W.write("body_markings", pref.body_markings)
	W.write("body_descriptors", pref.body_descriptors)
	W.write("bgstate", pref.bgstate)

/datum/category_item/player_setup_item/physical/body/sanitize_character(savefile/S)
	pref.r_hair			= sanitize_integer(pref.r_hair, 0, 255, initial(pref.r_hair))
	pref.g_hair			= sanitize_integer(pref.g_hair, 0, 255, initial(pref.g_hair))
	pref.b_hair			= sanitize_integer(pref.b_hair, 0, 255, initial(pref.b_hair))
	pref.r_facial		= sanitize_integer(pref.r_facial, 0, 255, initial(pref.r_facial))
	pref.g_facial		= sanitize_integer(pref.g_facial, 0, 255, initial(pref.g_facial))
	pref.b_facial		= sanitize_integer(pref.b_facial, 0, 255, initial(pref.b_facial))
	pref.r_skin			= sanitize_integer(pref.r_skin, 0, 255, initial(pref.r_skin))
	pref.g_skin			= sanitize_integer(pref.g_skin, 0, 255, initial(pref.g_skin))
	pref.b_skin			= sanitize_integer(pref.b_skin, 0, 255, initial(pref.b_skin))
	pref.h_style		= sanitize_inlist(pref.h_style, GLOB.hair_styles_list, initial(pref.h_style))
	pref.f_style		= sanitize_inlist(pref.f_style, GLOB.facial_hair_styles_list, initial(pref.f_style))
	pref.r_eyes			= sanitize_integer(pref.r_eyes, 0, 255, initial(pref.r_eyes))
	pref.g_eyes			= sanitize_integer(pref.g_eyes, 0, 255, initial(pref.g_eyes))
	pref.b_eyes			= sanitize_integer(pref.b_eyes, 0, 255, initial(pref.b_eyes))
	pref.b_type			= sanitize_text(pref.b_type, initial(pref.b_type))

	if(!pref.species || !(pref.species in playable_species))
		pref.species = SPECIES_HUMAN

	var/datum/species/mob_species = all_species[pref.species]

	var/low_skin_tone = mob_species ? (35 - mob_species.max_skin_tone()) : -185
	sanitize_integer(pref.s_tone, low_skin_tone, 34, initial(pref.s_tone))

	if(!mob_species.base_skin_colours || isnull(mob_species.base_skin_colours[pref.s_base]))
		pref.s_base = ""

	if(!istype(pref.organ_data)) pref.organ_data = list()
	if(!istype(pref.rlimb_data)) pref.rlimb_data = list()
	if(!istype(pref.body_markings))
		pref.body_markings = list()
	else
		pref.body_markings &= GLOB.body_marking_styles_list

	sanitize_organs()

	var/list/last_descriptors = list()
	if(islist(pref.body_descriptors))
		last_descriptors = pref.body_descriptors.Copy()
	pref.body_descriptors = list()

	if(LAZYLEN(mob_species.descriptors))
		for(var/entry in mob_species.descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if(istype(descriptor))
				if(isnull(last_descriptors[entry]))
					pref.body_descriptors[entry] = descriptor.default_value // Species datums have initial default value.
				else
					pref.body_descriptors[entry] = Clamp(last_descriptors[entry], 1, LAZYLEN(descriptor.standalone_value_descriptors))

	if(!pref.bgstate || !(pref.bgstate in pref.bgstate_options))
		pref.bgstate = "000"

/datum/category_item/player_setup_item/physical/body/content(mob/user)
	. = list()
	if(!pref.preview_icon)
		pref.update_preview_icon()
	var/preview_rsc_key = "previewicon_[pref.preview_icon_rsc_id].png"
	send_rsc(user, pref.preview_icon, preview_rsc_key)

	var/datum/species/mob_species = all_species[pref.species]
	var/title = "<b>Раса<a href='byond://?src=\ref[src];show_species=1'><small>?</small></a>:</b> <a href='byond://?src=\ref[src];set_species=1'>[mob_species.name]</a>"
	var/append_text = "<a href='byond://?src=\ref[src];toggle_species_verbose=1'>[hide_species ? "Развернуть" : "Свернуть"]</a>"
	. += "<hr>"
	. += mob_species.get_description(title, append_text, verbose = !hide_species, skip_detail = TRUE, skip_photo = TRUE)
	. += "<table><tr style='vertical-align:top'><td><b>Тело</b> "
	. += "(<a href='byond://?src=\ref[src];random=1'>&reg;</A>)"
	. += "<br>"

	. += "Группа крови: <a href='byond://?src=\ref[src];blood_type=1'>[pref.b_type]</a><br>"

	if(has_flag(mob_species, HAS_BASE_SKIN_COLOURS))
		. += "Базовый цвет: <a href='byond://?src=\ref[src];base_skin=1'>[pref.s_base]</a><br>"

	if(has_flag(mob_species, HAS_A_SKIN_TONE))
		. += "Тон кожи: <a href='byond://?src=\ref[src];skin_tone=1'>[-pref.s_tone + 35]/[mob_species.max_skin_tone()]</a><br>"

	. += "Нужны очки: <a href='byond://?src=\ref[src];char_nearsighted=1'><b>[pref.char_nearsighted ? "Да" : "Нет"]</b></a><br>"
	. += "Конечности: <a href='byond://?src=\ref[src];limbs=1'>Изменить</a> <a href='byond://?src=\ref[src];reset_limbs=1'>Сброс</a><br>"
	. += "Внутренние органы: <a href='byond://?src=\ref[src];organs=1'>Изменить</a><br>"

	//display limbs below
	var/ind = 0
	for(var/name in pref.organ_data)
		var/status = pref.organ_data[name]
		var/organ_name = null
		switch(name)
			if(BP_L_ARM)
				organ_name = "левая рука"
			if(BP_R_ARM)
				organ_name = "правая рука"
			if(BP_L_LEG)
				organ_name = "левая нога"
			if(BP_R_LEG)
				organ_name = "правая нога"
			if(BP_L_FOOT)
				organ_name = "левая ступня"
			if(BP_R_FOOT)
				organ_name = "правая ступня"
			if(BP_L_HAND)
				organ_name = "левая кисть"
			if(BP_R_HAND)
				organ_name = "правая кисть"
			if(BP_HEART)
				organ_name = "сердце"
			if(BP_EYES)
				organ_name = "глаза"
			if(BP_BRAIN)
				organ_name = "мозг"
			if(BP_LUNGS)
				organ_name = "лёгкие"
			if(BP_LIVER)
				organ_name = "печень"
			if(BP_KIDNEYS)
				organ_name = "почки"
			if(BP_STOMACH)
				organ_name = "желудок"
			if(BP_CHEST)
				organ_name = "верхняя часть тела"
			if(BP_GROIN)
				organ_name = "нижняя часть тела"
			if(BP_HEAD)
				organ_name = "голова"

		if(status == "cyborg")
			++ind
			if(ind > 1)
				. += ", "
			var/datum/robolimb/R
			if(pref.rlimb_data[name] && all_robolimbs[pref.rlimb_data[name]])
				R = all_robolimbs[pref.rlimb_data[name]]
			else
				R = basic_robolimb
			. += "\tПротез [organ_name] от [R.company]"
		else if(status == "amputated")
			++ind
			if(ind > 1)
				. += ", "
			. += "\tАмпутирована: [organ_name]"
		else if(status == "mechanical")
			++ind
			if(ind > 1)
				. += ", "
			if(organ_name == "мозг")
				. += "\tПозитронный [organ_name]"
			else
				. += "\tСинтетический [organ_name]"
		else if(status == "assisted")
			++ind
			if(ind > 1)
				. += ", "
			switch(organ_name)
				if("сердце")
					. += "\t[organ_name] с кардиостимулятором"
				if("voicebox") //on adding voiceboxes for speaking skrell/similar replacements
					. += "\tХирургически изменённый [organ_name]"
				if("глаза")
					. += "\t[organ_name] с ретинальным оверлеем"
				if("мозг")
					. += "\t[organ_name] с машинным интерфейсом"
				else
					. += "\tМеханически усиленный [organ_name]"
	if(!ind)
		. += "\[...\]<br><br>"
	else
		. += "<br><br>"

	if(LAZYLEN(pref.body_descriptors))
		. += "<table>"
		for(var/entry in pref.body_descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			. += "<tr><td><b>[capitalize(descriptor.chargen_label)]:</b></td><td>[descriptor.get_standalone_value_descriptor(pref.body_descriptors[entry])]</td><td><a href='byond://?src=\ref[src];change_descriptor=[entry]'>Изменить</a><br/></td></tr>"
		. += "</table><br>"

	. += "</td><td><b>Превью</b><br>"
	. += "<div class='statusDisplay'><center><img src=[preview_rsc_key] width=[pref.preview_icon.Width()] height=[pref.preview_icon.Height()]></center></div>"
	. += "<br><a href='byond://?src=\ref[src];cycle_bg=1'>Сменить фон</a>"
	. += "<br><a href='byond://?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_LOADOUT]'>[pref.equip_preview_mob & EQUIP_PREVIEW_LOADOUT ? "Скрыть снаряжение" : "Показать снаряжение"]</a>"
	. += "<br><a href='byond://?src=\ref[src];toggle_preview_value=[EQUIP_PREVIEW_JOB]'>[pref.equip_preview_mob & EQUIP_PREVIEW_JOB ? "Скрыть экипировку" : "Показать экипировку"]</a>"
	. += "</td></tr></table>"

	. += "<b>Волосы</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='byond://?src=\ref[src];hair_color=1'>Изменить цвет</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_hair & 0xFF)][num2hex(pref.g_hair & 0xFF)][num2hex(pref.b_hair & 0xFF)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_hair & 0xFF)][num2hex(pref.g_hair & 0xFF)][num2hex(pref.b_hair & 0xFF)]'><tr><td>__</td></tr></table></font> "
	. += " Стиль: [UIBUTTON("hair_style=1;decrement", "<", null)][UIBUTTON("hair_style=1;increment", ">", null)]<a href='byond://?src=\ref[src];hair_style=1;open_picker=1'>[pref.h_style]</a><br>"

	. += "<br><b>Борода и усы</b><br>"
	if(has_flag(mob_species, HAS_HAIR_COLOR))
		. += "<a href='byond://?src=\ref[src];facial_color=1'>Изменить цвет</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_facial & 0xFF)][num2hex(pref.g_facial & 0xFF)][num2hex(pref.b_facial & 0xFF)]'><table  style='display:inline;' bgcolor='#[num2hex(pref.r_facial & 0xFF)][num2hex(pref.g_facial & 0xFF)][num2hex(pref.b_facial & 0xFF)]'><tr><td>__</td></tr></table></font> "
	. += " Стиль: [UIBUTTON("facial_style=1;decrement", "<", null)][UIBUTTON("facial_style=1;increment", ">", null)]<a href='byond://?src=\ref[src];facial_style=1;open_picker=1'>[pref.f_style]</a><br>"

	if(has_flag(mob_species, HAS_EYE_COLOR))
		. += "<br><b>Глаза</b><br>"
		. += "<a href='byond://?src=\ref[src];eye_color=1'>Изменить цвет</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_eyes & 0xFF)][num2hex(pref.g_eyes & 0xFF)][num2hex(pref.b_eyes & 0xFF)]'><table  style='display:inline;' bgcolor='#[num2hex(pref.r_eyes & 0xFF)][num2hex(pref.g_eyes & 0xFF)][num2hex(pref.b_eyes & 0xFF)]'><tr><td>__</td></tr></table></font><br>"

	if(has_flag(mob_species, HAS_SKIN_COLOR))
		. += "<br><b>Цвет кожи</b><br>"
		. += "<a href='byond://?src=\ref[src];skin_color=1'>Изменить цвет</a> <font face='fixedsys' size='3' color='#[num2hex(pref.r_skin & 0xFF)][num2hex(pref.g_skin & 0xFF)][num2hex(pref.b_skin & 0xFF)]'><table style='display:inline;' bgcolor='#[num2hex(pref.r_skin & 0xFF)][num2hex(pref.g_skin & 0xFF)][num2hex(pref.b_skin & 0xFF)]'><tr><td>__</td></tr></table></font><br>"

	. += "<br><a href='byond://?src=\ref[src];marking_style=1'>Телесные метки +</a><br>"
	for(var/M in pref.body_markings)
		. += "[M] <a href='byond://?src=\ref[src];marking_remove=[M]'>-</a> <a href='byond://?src=\ref[src];marking_color=[M]'>Цвет</a>"
		. += "<font face='fixedsys' size='3' color='[pref.body_markings[M]]'><table style='display:inline;' bgcolor='[pref.body_markings[M]]'><tr><td>__</td></tr></table></font>"
		. += "<br>"

	. = jointext(.,null)

/datum/category_item/player_setup_item/physical/body/proc/has_flag(datum/species/mob_species, flag)
	return mob_species && (mob_species.appearance_flags & flag)

/datum/category_item/player_setup_item/physical/body/OnTopic(href,list/href_list, mob/user)

	var/datum/species/mob_species = all_species[pref.species]
	if(href_list["toggle_species_verbose"])
		hide_species = !hide_species
		return TOPIC_REFRESH

	else if(href_list["random"])
		pref.randomize_appearance_and_body_for()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["change_descriptor"])
		if(mob_species.descriptors)
			var/desc_id = href_list["change_descriptor"]
			if(pref.body_descriptors[desc_id])
				var/datum/mob_descriptor/descriptor = mob_species.descriptors[desc_id]
				var/choice = tgui_input_list(user, "Выберите характеристику.", "Характеристика", descriptor.chargen_value_descriptors)
				if(choice && mob_species.descriptors[desc_id]) // Check in case they sneakily changed species.
					pref.body_descriptors[desc_id] = descriptor.chargen_value_descriptors[choice]
					return TOPIC_REFRESH

	else if(href_list["blood_type"])
		var/new_b_type = tgui_input_list(user, "Выберите группу крови персонажа:", CHARACTER_PREFERENCE_INPUT_TITLE, valid_bloodtypes)
		if(new_b_type && CanUseTopic(user))
			pref.b_type = new_b_type
			return TOPIC_REFRESH

	else if(href_list["show_species"])
		var/choice = tgui_input_list(user, "О какой расе вы хотите узнать?", "Выбор расы", playable_species)
		if(choice)
			var/datum/species/current_species = all_species[choice]
			show_browser(user, current_species.get_description(), "window=species;size=700x400")
			return TOPIC_HANDLED

	else if(href_list["set_species"])

		var/list/species_to_pick = list()
		for(var/species in playable_species)
			if(!check_rights(R_ADMIN, 0) && config.usealienwhitelist)
				var/datum/species/current_species = all_species[species]
				if(!(current_species.spawn_flags & SPECIES_CAN_JOIN))
					continue
				else if((current_species.spawn_flags & SPECIES_IS_WHITELISTED) && !is_alien_whitelisted(preference_mob(),current_species))
					continue
			species_to_pick += species

		var/choice = tgui_input_list(user, "Выберите расу для игры.", "Выбор расы", species_to_pick)
		if(!choice || !(choice in all_species))
			return

		var/prev_species = pref.species
		pref.species = choice
		if(prev_species != pref.species)
			mob_species = all_species[pref.species]
			if(!(pref.gender in mob_species.genders))
				pref.gender = mob_species.genders[1]

			ResetAllHair()

			//reset hair colour and skin colour
			pref.r_hair = 0//hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = 0//hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = 0//hex2num(copytext(new_hair, 6, 8))
			pref.s_tone = 0
			pref.age = max(min(pref.age, mob_species.max_age), mob_species.min_age)

			reset_limbs() // Safety for species with incompatible manufacturers; easier than trying to do it case by case.
			pref.body_markings.Cut() // Basically same as above.

			prune_occupation_prefs()
			pref.skills_allocated = pref.sanitize_skills(pref.skills_allocated)

			pref.cultural_info = mob_species.default_cultural_info.Copy()

			sanitize_organs()

			if(!has_flag(all_species[pref.species], HAS_UNDERWEAR))
				pref.all_underwear.Cut()

			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_hair = input(user, "Выберите цвет волос персонажа:", CHARACTER_PREFERENCE_INPUT_TITLE, rgb(pref.r_hair, pref.g_hair, pref.b_hair)) as color|null
		if(new_hair && has_flag(all_species[pref.species], HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_hair = hex2num(copytext(new_hair, 2, 4))
			pref.g_hair = hex2num(copytext(new_hair, 4, 6))
			pref.b_hair = hex2num(copytext(new_hair, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["hair_style"])
		var/list/valid_hairstyles = mob_species.get_hair_styles()
		if (href_list["increment"])
			var/hair_index = list_find(valid_hairstyles, pref.h_style)
			if (hair_index < valid_hairstyles.len && valid_hairstyles[hair_index + 1])
				pref.h_style = valid_hairstyles[hair_index + 1]
				return TOPIC_REFRESH_UPDATE_PREVIEW
		else if (href_list["decrement"])
			var/hair_index = list_find(valid_hairstyles, pref.h_style)
			if (hair_index > 1 && valid_hairstyles[hair_index - 1])
				pref.h_style = valid_hairstyles[hair_index - 1]
				return TOPIC_REFRESH_UPDATE_PREVIEW
		else if(href_list["open_picker"])
			var/datum/tgui/hair_picker/picker = new(pref)
			picker.tgui_interact(user)
			return TOPIC_HANDLED

	else if(href_list["facial_color"])
		if(!has_flag(mob_species, HAS_HAIR_COLOR))
			return TOPIC_NOACTION
		var/new_facial = input(user, "Выберите цвет бороды персонажа:", CHARACTER_PREFERENCE_INPUT_TITLE, rgb(pref.r_facial, pref.g_facial, pref.b_facial)) as color|null
		if(new_facial && has_flag(all_species[pref.species], HAS_HAIR_COLOR) && CanUseTopic(user))
			pref.r_facial = hex2num(copytext(new_facial, 2, 4))
			pref.g_facial = hex2num(copytext(new_facial, 4, 6))
			pref.b_facial = hex2num(copytext(new_facial, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["eye_color"])
		if(!has_flag(mob_species, HAS_EYE_COLOR))
			return TOPIC_NOACTION
		var/new_eyes = input(user, "Выберите цвет глаз:", CHARACTER_PREFERENCE_INPUT_TITLE, rgb(pref.r_eyes, pref.g_eyes, pref.b_eyes)) as color|null
		if(new_eyes && has_flag(all_species[pref.species], HAS_EYE_COLOR) && CanUseTopic(user))
			pref.r_eyes = hex2num(copytext(new_eyes, 2, 4))
			pref.g_eyes = hex2num(copytext(new_eyes, 4, 6))
			pref.b_eyes = hex2num(copytext(new_eyes, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["base_skin"])
		if(!has_flag(mob_species, HAS_BASE_SKIN_COLOURS))
			return TOPIC_NOACTION
		var/new_s_base = tgui_input_list(user, "Выберите базовый цвет персонажа:", CHARACTER_PREFERENCE_INPUT_TITLE, mob_species.base_skin_colours)
		if(new_s_base && CanUseTopic(user))
			pref.s_base = new_s_base
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_tone"])
		if(!has_flag(mob_species, HAS_A_SKIN_TONE))
			return TOPIC_NOACTION
		var/new_s_tone = tgui_input_number(user, "Выберите тон кожи персонажа (1 – светлый, [mob_species.max_skin_tone()] – тёмный):", CHARACTER_PREFERENCE_INPUT_TITLE, (-pref.s_tone) + 35, mob_species.max_skin_tone(), 1)
		mob_species = all_species[pref.species]
		if(new_s_tone && has_flag(mob_species, HAS_A_SKIN_TONE) && CanUseTopic(user))
			pref.s_tone = 35 - max(min(round(new_s_tone), mob_species.max_skin_tone()), 1)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["skin_color"])
		if(!has_flag(mob_species, HAS_SKIN_COLOR))
			return TOPIC_NOACTION
		var/new_skin = input(user, "Выберите цвет кожи персонажа:", CHARACTER_PREFERENCE_INPUT_TITLE, rgb(pref.r_skin, pref.g_skin, pref.b_skin)) as color|null
		if(new_skin && has_flag(all_species[pref.species], HAS_SKIN_COLOR) && CanUseTopic(user))
			pref.r_skin = hex2num(copytext(new_skin, 2, 4))
			pref.g_skin = hex2num(copytext(new_skin, 4, 6))
			pref.b_skin = hex2num(copytext(new_skin, 6, 8))
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["facial_style"])
		var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(pref.gender)
		var/new_f_style
		var/hair_index = list_find(valid_facialhairstyles, pref.f_style)

		if (href_list["increment"])
			if (hair_index < valid_facialhairstyles.len && valid_facialhairstyles[hair_index + 1])
				new_f_style = valid_facialhairstyles[hair_index + 1]
		else if (href_list["decrement"])
			if (hair_index > 1 && valid_facialhairstyles[hair_index - 1])
				new_f_style = valid_facialhairstyles[hair_index - 1]
		else if(href_list["open_picker"])
			var/datum/tgui/facial_hair_picker/picker = new(pref)
			picker.tgui_interact(user)
			return TOPIC_HANDLED
		else
			new_f_style = tgui_input_list(user, "Выберите стиль растительности на лице:", CHARACTER_PREFERENCE_INPUT_TITLE, valid_facialhairstyles, pref.f_style)

		mob_species = all_species[pref.species]
		if(new_f_style && CanUseTopic(user) && (new_f_style in mob_species.get_facial_hair_styles(pref.gender)))
			pref.f_style = new_f_style
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_style"])
		var/list/disallowed_markings = list()
		for (var/M in pref.body_markings)
			var/datum/sprite_accessory/marking/mark_style = GLOB.body_marking_styles_list[M]
			disallowed_markings |= mark_style.disallows
		var/list/usable_markings = pref.body_markings.Copy() ^ GLOB.body_marking_styles_list.Copy()
		for(var/M in usable_markings)
			var/datum/sprite_accessory/S = usable_markings[M]
			if(is_type_in_list(S, disallowed_markings) || (S.species_allowed && !(mob_species.get_bodytype() in S.species_allowed)) || (S.subspecies_allowed && !(mob_species.name in S.subspecies_allowed)))
				usable_markings -= M

		var/new_marking = tgui_input_list(user, "Выберите телесную метку:", CHARACTER_PREFERENCE_INPUT_TITLE, usable_markings)
		if(new_marking && CanUseTopic(user))
			pref.body_markings[new_marking] = "#000000" //New markings start black
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_remove"])
		var/M = href_list["marking_remove"]
		pref.body_markings -= M
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["marking_color"])
		var/M = href_list["marking_color"]
		var/mark_color = input(user, "Выберите цвет для [M]:", CHARACTER_PREFERENCE_INPUT_TITLE, pref.body_markings[M]) as color|null
		if(mark_color && CanUseTopic(user))
			pref.body_markings[M] = "[mark_color]"
			return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["reset_limbs"])
		reset_limbs()
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["limbs"])

		var/list/limb_selection_list = list("Левая нога","Правая нога","Левая рука","Правая рука","Левая ступня","Правая ступня","Левая кисть","Правая кисть", "Всё тело")

		// Full prosthetic bodies without a brain are borderline unkillable so make sure they have a brain to remove/destroy.
		var/datum/species/current_species = all_species[pref.species]
		if(current_species.spawn_flags & SPECIES_NO_FBP_CHARGEN)
			limb_selection_list -= "Всё тело"
		else if(pref.organ_data[BP_CHEST] == "cyborg")
			limb_selection_list |= "Голова"

		var/organ_tag = tgui_input_list(user, "Какую часть тела вы хотите изменить?", "Выбор части тела", limb_selection_list)

		if(!organ_tag || !CanUseTopic(user)) return TOPIC_NOACTION

		var/limb = null
		var/second_limb = null // if you try to change the arm, the hand should also change
		var/third_limb = null  // if you try to unchange the hand, the arm should also change

		// Do not let them amputate their entire body, ty.
		var/list/choice_options = list("Нормальная","Ампутирована","Протез")

		//Dare ye who decides to one day make fbps be able to have fleshy bits. Heed my warning, recursion is a bitch. - Snapshot
		if(pref.organ_data[BP_CHEST] == "cyborg")
			choice_options = list("Ампутирована", "Протез")

		switch(organ_tag)
			if("Левая нога")
				limb = BP_L_LEG
				second_limb = BP_L_FOOT
			if("Правая нога")
				limb = BP_R_LEG
				second_limb = BP_R_FOOT
			if("Левая рука")
				limb = BP_L_ARM
				second_limb = BP_L_HAND
			if("Правая рука")
				limb = BP_R_ARM
				second_limb = BP_R_HAND
			if("Левая ступня")
				limb = BP_L_FOOT
				third_limb = BP_L_LEG
			if("Правая ступня")
				limb = BP_R_FOOT
				third_limb = BP_R_LEG
			if("Левая кисть")
				limb = BP_L_HAND
				third_limb = BP_L_ARM
			if("Правая кисть")
				limb = BP_R_HAND
				third_limb = BP_R_ARM
			if("Голова")
				limb =        BP_HEAD
				choice_options = list("Протез")
			if("Всё тело")
				limb =        BP_CHEST
				third_limb =  BP_GROIN
				choice_options = list("Нормальная","Протез")

		var/new_state = tgui_input_list(user, "Выберите состояние конечности:", "Состояние конечности", choice_options)
		if(!new_state || !CanUseTopic(user)) return TOPIC_NOACTION

		switch(new_state)
			if("Нормальная")
				if(limb == BP_CHEST)
					for(var/other_limb in (BP_ALL_LIMBS - BP_CHEST))
						pref.organ_data[other_limb] = null
						pref.rlimb_data[other_limb] = null
						for(var/internal_organ in list(BP_HEART,BP_EYES,BP_LUNGS,BP_LIVER,BP_KIDNEYS,BP_STOMACH,BP_BRAIN))
							pref.organ_data[internal_organ] = null
				pref.organ_data[limb] = null
				pref.rlimb_data[limb] = null
				if(third_limb)
					pref.organ_data[third_limb] = null
					pref.rlimb_data[third_limb] = null
			if("Ампутирована")
				if(limb == BP_CHEST)
					return
				pref.organ_data[limb] = "amputated"
				pref.rlimb_data[limb] = null
				if(second_limb)
					pref.organ_data[second_limb] = "amputated"
					pref.rlimb_data[second_limb] = null

			if("Протез")
				var/datum/species/temp_species = pref.species ? all_species[pref.species] : all_species[SPECIES_HUMAN]
				var/tmp_species = temp_species.get_bodytype(user)
				var/list/usable_manufacturers = list()
				for(var/company in chargen_robolimbs)
					var/datum/robolimb/M = chargen_robolimbs[company]
					if(tmp_species in M.species_cannot_use)
						continue
					if(M.restricted_to.len && !(tmp_species in M.restricted_to))
						continue
					if(M.applies_to_part.len && !(limb in M.applies_to_part))
						continue
					if(M.allowed_bodytypes && !(tmp_species in M.allowed_bodytypes))
						continue
					usable_manufacturers[company] = M
				if(!usable_manufacturers.len)
					return
				var/choice = tgui_input_list(user, "Выберите производителя протеза:", "Производитель протеза", usable_manufacturers)
				if(!choice)
					return
				pref.rlimb_data[limb] = choice
				pref.organ_data[limb] = "cyborg"
				if(second_limb)
					pref.rlimb_data[second_limb] = choice
					pref.organ_data[second_limb] = "cyborg"
				if(third_limb && pref.organ_data[third_limb] == "amputated")
					pref.organ_data[third_limb] = null

				if(limb == BP_CHEST)
					for(var/other_limb in BP_ALL_LIMBS - BP_CHEST)
						pref.organ_data[other_limb] = "cyborg"
						pref.rlimb_data[other_limb] = choice
					if(!pref.organ_data[BP_BRAIN])
						pref.organ_data[BP_BRAIN] = "assisted"
					for(var/internal_organ in list(BP_HEART,BP_EYES,BP_LUNGS,BP_LIVER,BP_KIDNEYS))
						pref.organ_data[internal_organ] = "mechanical"

		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["organs"])
		var/organ_name = tgui_input_list(user, "Какой внутренний орган вы хотите изменить?", "Выбор органа", list("Сердце", "Глаза", "Лёгкие", "Печень", "Почки", "Желудок"))
		if(!organ_name) return

		var/organ = null
		switch(organ_name)
			if("Сердце")
				organ = BP_HEART
			if("Глаза")
				organ = BP_EYES
			if("Лёгкие")
				organ = BP_LUNGS
			if("Печень")
				organ = BP_LIVER
			if("Почки")
				organ = BP_KIDNEYS
			if("Желудок")
				organ = BP_STOMACH

		var/list/organ_choices = list("Нормальный","Усиленный","Синтетический")

		if(mob_species && mob_species.spawn_flags & SPECIES_NO_ROBOTIC_INTERNAL_ORGANS)
			organ_choices -= "Усиленный"
			organ_choices -= "Синтетический"

		if(pref.organ_data[BP_CHEST] == "cyborg")
			organ_choices -= "Нормальный"
			organ_choices += "Синтетический"

		var/new_state = tgui_input_list(user, "Выберите состояние органа:", "Состояние органа", organ_choices)
		if(!new_state) return

		switch(new_state)
			if("Нормальный")
				pref.organ_data[organ] = null
			if("Усиленный")
				pref.organ_data[organ] = "assisted"
			if("Синтетический")
				pref.organ_data[organ] = "mechanical"

		sanitize_organs()
		return TOPIC_REFRESH

	else if(href_list["char_nearsighted"])
		pref.char_nearsighted = pref.char_nearsighted ? FALSE : TRUE
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["toggle_preview_value"])
		pref.equip_preview_mob ^= text2num(href_list["toggle_preview_value"])
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["cycle_bg"])
		pref.bgstate = next_in_list(pref.bgstate, pref.bgstate_options)
		return TOPIC_REFRESH_UPDATE_PREVIEW

	else if(href_list["select_hairstyle"])
		var/style = href_list["select_hairstyle"]
		if(style in mob_species.get_hair_styles())   // используем уже существующую mob_species
			pref.h_style = style
			close_browser(user, "window=hairstylepicker")
			return TOPIC_REFRESH_UPDATE_PREVIEW

	return ..()

/datum/category_item/player_setup_item/physical/body/proc/reset_limbs()
	pref.organ_data.Cut()
	pref.rlimb_data.Cut()

/datum/category_item/player_setup_item/proc/ResetAllHair()
	ResetHair()
	ResetFacialHair()

/datum/category_item/player_setup_item/proc/ResetHair()
	var/datum/species/mob_species = all_species[pref.species]
	var/list/valid_hairstyles = mob_species.get_hair_styles()

	if(valid_hairstyles.len)
		pref.h_style = pick(valid_hairstyles)
	else
		//this shouldn't happen
		pref.h_style = GLOB.hair_styles_list["Bald"]

/datum/category_item/player_setup_item/proc/ResetFacialHair()
	var/datum/species/mob_species = all_species[pref.species]
	var/list/valid_facialhairstyles = mob_species.get_facial_hair_styles(pref.gender)

	if(valid_facialhairstyles.len)
		pref.f_style = pick(valid_facialhairstyles)
	else
		//this shouldn't happen
		pref.f_style = GLOB.facial_hair_styles_list["Shaved"]

/datum/category_item/player_setup_item/physical/body/proc/sanitize_organs()
	var/datum/species/mob_species = all_species[pref.species]
	if(mob_species && mob_species.spawn_flags & SPECIES_NO_ROBOTIC_INTERNAL_ORGANS)
		for(var/name in pref.organ_data)
			var/status = pref.organ_data[name]
			if(status in list("assisted","mechanical"))
				pref.organ_data[name] = null

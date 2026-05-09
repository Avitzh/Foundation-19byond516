GLOBAL_DATUM_INIT(traitors, /datum/antagonist/traitor, new)

// Inherits most of its vars from the base datum.
/datum/antagonist/traitor
	id = MODE_TRAITOR
	antaghud_indicator = "hud_traitor"
	blacklisted_jobs = list(/datum/job/ai, /datum/job/classd, /datum/job/captain, /datum/job/hos, /datum/job/chief_engineer, /datum/job/cmo, /datum/job/rd, /datum/job/qm, /datum/job/ethicsliaison, /datum/job/tribunal, /datum/job/commsofficer, /datum/job/enlistedofficerez, /datum/job/enlistedofficerlcz, /datum/job/enlistedofficerhcz, /datum/job/ncoofficerez, /datum/job/ncoofficerlcz, /datum/job/ncoofficerhcz, /datum/job/ltofficerez, /datum/job/ltofficerlcz, /datum/job/ltofficerhcz, /datum/job/guardlcz, /datum/job/guardhcz, /datum/job/guardez, /datum/job/goirep, /datum/job/raisa)
	flags = ANTAG_RANDSPAWN | ANTAG_VOTABLE
	skill_setter = /datum/antag_skill_setter/station

	// Фракции (русские названия)
	var/static/list/available_factions = list(
		"Глобальная Оккультная Коалиция" = "goc",
		"Повстанцы Хаоса" = "chaos",
		"Длань Змея" = "serpent"
	)
	var/traitor_faction = null

	// Кастомные цели
	var/list/pending_custom_objectives = list()
	var/objectives_confirmed = FALSE
	var/objectives_denied = FALSE
	var/objectives_timeout = 0          // таймер для рассмотрения админом
	var/objectives_input_timeout = 0    // таймер для ввода целей игроком
	var/static/custom_objectives_enabled = TRUE

/datum/antagonist/traitor/create_antagonist(datum/mind/target, move, gag_announcement, preserve_appearance)
	if(!target)
		return

	update_antag_mob(target, preserve_appearance)
	if(!target.current)
		remove_antagonist(target)
		return 0
	if(flags & ANTAG_CHOOSE_NAME)
		spawn(1)
			set_antag_name(target.current)
	if(move)
		place_mob(target.current)
	update_leader()

	// 1. Приветствие и стандартное объявление
	greet(target)
	if(!gag_announcement)
		announce_antagonist_spawn()
	update_icons_added(target)

	// 2. Выбор фракции и ОБЯЗАТЕЛЬНЫЙ ввод целей (отложенно)
	spawn(0)
		if(!traitor_faction)
			var/chosen_name = input(target.current, "Выберите организацию, на которую вы работаете:", "Выбор фракции") as null|anything in available_factions
			if(!chosen_name)
				traitor_faction = "goc"
			else
				traitor_faction = available_factions[chosen_name]
			to_chat(target.current, "Вы – агент организации «[chosen_name]» под глубоким прикрытием.")

		// Обязательный ввод целей
		propose_custom_objectives(target.current)

/datum/antagonist/traitor/get_extra_panel_options(datum/mind/player)
	return "<a href='byond://?src=\ref[player];common=crystals'>\[set crystals\]</a><a href='byond://?src=\ref[src];spawn_uplink=\ref[player.current]'>\[spawn uplink\]</a>"

/datum/antagonist/traitor/Topic(href, href_list)
	if(..())
		return 1

	var/client/target = usr.client
	if(!check_rights(R_ADMIN|R_MOD, TRUE, target))
		return 1

	if(href_list["action"] == "approve_custom_obj")
		var/datum/mind/pl = locate(href_list["target"])
		if(!pl || !(pl in current_antagonists))
			return
		approve_custom_objectives(pl)
		return 1
	else if(href_list["action"] == "deny_custom_obj")
		var/datum/mind/pl = locate(href_list["target"])
		if(!pl || !(pl in current_antagonists))
			return
		deny_custom_objectives(pl)
		return 1
	else if(href_list["action"] == "edit_custom_obj")
		var/datum/mind/pl = locate(href_list["target"])
		if(!pl || !(pl in current_antagonists))
			return
		edit_custom_objectives(pl)
		return 1

	if(href_list["spawn_uplink"])
		spawn_uplink(locate(href_list["spawn_uplink"]))
		return 1

/datum/antagonist/traitor/create_objectives(datum/mind/traitor)
	if(!..())
		return

	switch(traitor_faction)
		if("goc")
			create_goc_objectives(traitor)
		if("chaos")
			create_chaos_objectives(traitor)
		if("serpent")
			create_serpent_objectives(traitor)
		else
			create_default_faction_objectives(traitor)

/datum/antagonist/traitor/proc/create_default_faction_objectives(datum/mind/traitor)
	// Стандартный набор целей (старая логика)
	if(istype(traitor.current, /mob/living/silicon))
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = traitor
		kill_objective.find_target()
		traitor.objectives += kill_objective

		var/datum/objective/survive/survive_objective = new
		survive_objective.owner = traitor
		traitor.objectives += survive_objective
	else
		switch(rand(1,100))
			if(1 to 33)
				var/datum/objective/assassinate/kill_objective = new
				kill_objective.owner = traitor
				kill_objective.find_target()
				traitor.objectives += kill_objective
			if(34 to 50)
				var/datum/objective/brig/brig_objective = new
				brig_objective.owner = traitor
				brig_objective.find_target()
				traitor.objectives += brig_objective
			if(51 to 66)
				var/datum/objective/harm/harm_objective = new
				harm_objective.owner = traitor
				harm_objective.find_target()
				traitor.objectives += harm_objective
			else
				var/datum/objective/steal/steal_objective = new
				steal_objective.owner = traitor
				steal_objective.find_target()
				traitor.objectives += steal_objective
		switch(rand(1,100))
			if(1 to 100)
				if (!(locate(/datum/objective/escape) in traitor.objectives))
					var/datum/objective/escape/escape_objective = new
					escape_objective.owner = traitor
					traitor.objectives += escape_objective
			else
				if (!(locate(/datum/objective/hijack) in traitor.objectives))
					var/datum/objective/hijack/hijack_objective = new
					hijack_objective.owner = traitor
					traitor.objectives += hijack_objective

/datum/antagonist/traitor/proc/create_goc_objectives(datum/mind/traitor)
	create_default_faction_objectives(traitor) // временно

/datum/antagonist/traitor/proc/create_chaos_objectives(datum/mind/traitor)
	create_default_faction_objectives(traitor)

/datum/antagonist/traitor/proc/create_serpent_objectives(datum/mind/traitor)
	create_default_faction_objectives(traitor)

/datum/antagonist/traitor/equip(mob/living/carbon/human/traitor_mob)
	if(istype(traitor_mob, /mob/living/silicon))
		add_law_zero(traitor_mob)
		give_intel(traitor_mob)
		if(istype(traitor_mob, /mob/living/silicon/robot))
			var/mob/living/silicon/robot/R = traitor_mob
			R.SetLockdown(0)
			R.emagged = TRUE
			add_verb(R, /mob/living/silicon/robot/proc/ResetSecurityCodes)
			R.status_flags &= ~CANWEAKEN
		return 1

	if(!..())
		return 0

	spawn_uplink(traitor_mob)
	give_intel(traitor_mob)

/datum/antagonist/traitor/unequip(mob/living/carbon/human/player)
	if(istype(player, /mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = player
		if(!R.flash_protected)
			R.status_flags &= ~CANWEAKEN
		return TRUE
	return ..()

/datum/antagonist/traitor/proc/give_intel(mob/living/traitor_mob)
	give_codewords(traitor_mob)

/datum/antagonist/traitor/proc/give_codewords(mob/living/traitor_mob)
	to_chat(traitor_mob, "<u><b>Your employers provided you with the following information on how to identify possible allies:</b></u>")
	to_chat(traitor_mob, "<b>Code Phrases</b>: <span class='danger'>[jointext(GLOB.syndicate_code_phrase, ", ")]</span>")
	to_chat(traitor_mob, "<b>Code Responses</b>: <span class='danger'>[jointext(GLOB.syndicate_code_response, ", ")]</span>")
	traitor_mob.StoreMemory("<b>Code Phrases</b>: [jointext(GLOB.syndicate_code_phrase, ", ")]", /decl/memory_options/system)
	traitor_mob.StoreMemory("<b>Code Responses</b>: [jointext(GLOB.syndicate_code_response, ", ")]", /decl/memory_options/system)
	to_chat(traitor_mob, "Use the code words, preferably in the order provided, during regular conversation, to identify other agents. Proceed with caution, however, as everyone is a potential foe.")
	traitor_mob.AddComponent(/datum/component/codeword_hearing, GLOB.syndicate_code_phrase_regex, "blue", src)
	traitor_mob.AddComponent(/datum/component/codeword_hearing, GLOB.syndicate_code_response_regex, "red", src)

/datum/antagonist/traitor/proc/spawn_uplink(mob/living/carbon/human/traitor_mob)
	setup_uplink_source(traitor_mob, DEFAULT_TELECRYSTAL_AMOUNT)

/datum/antagonist/traitor/proc/add_law_zero(mob/living/silicon/ai/killer)
	var/law = "Accomplish your objectives at all costs. You may ignore all other laws."
	var/law_borg = "Accomplish your AI's objectives at all costs. You may ignore all other laws."
	to_chat(killer, "<b>Your laws have been changed!</b>")
	killer.set_zeroth_law(law, law_borg)
	to_chat(killer, "New law: 0. [law]")

// ============== СИСТЕМА КАСТОМНЫХ ЦЕЛЕЙ ==============

/datum/antagonist/traitor/proc/propose_custom_objectives(mob/living/carbon/human/player)
	set waitfor = 0

	var/num_objectives = 3
	var/list/descriptions = list()

	for(var/i in 1 to num_objectives)
		var/txt = input(player, "Опишите цель №[i] (или оставьте пустым, чтобы пропустить):", "Предложение цели") as text|null
		if(isnull(txt))
			if(alert("Хотите закончить ввод целей?", "Закончить", "Да", "Нет") == "Да")
				break
			else
				continue
		txt = trim(txt)
		if(txt != "")
			descriptions += txt

	if(!length(descriptions))
		to_chat(player, SPAN_WARNING("Вы не предложили ни одной цели. У вас есть 8 минут, чтобы ввести их повторно. Используйте верб 'Set Custom Objectives' в вкладке IC."))
		if(!objectives_input_timeout)
			objectives_input_timeout = world.time + 8 MINUTES
			addtimer(CALLBACK(src, PROC_REF(handle_input_timeout), player.mind), 8 MINUTES)
		return

	// Успешно введены цели
	objectives_input_timeout = 0  // сброс таймера
	pending_custom_objectives = descriptions
	objectives_timeout = world.time + 5 MINUTES

	// --- сбор читаемого названия фракции ---
	var/faction_display = "Неизвестно"
	for(var/name in available_factions)
		if(available_factions[name] == traitor_faction)
			faction_display = name
			break

	var/admin_msg = "<span class='notice'><b>Пользователь [key_name(player)] предложил цели для трейтора.</b></span><br>"
	admin_msg += "<b>Фракция:</b> [faction_display]<br>"
	for(var/i=1 to length(descriptions))
		admin_msg += "<b>[i]:</b> [sanitize(descriptions[i])]<br>"
	admin_msg += "<br><a href='byond://?src=\ref[src];action=approve_custom_obj;target=\ref[player.mind]'><b>Одобрить</b></a> | "
	admin_msg += "<a href='byond://?src=\ref[src];action=deny_custom_obj;target=\ref[player.mind]'><b>Отклонить</b></a> | "
	admin_msg += "<a href='byond://?src=\ref[src];action=edit_custom_obj;target=\ref[player.mind]'><b>Редактировать</b></a>"
	message_staff(admin_msg)

	to_chat(player, SPAN_NOTICE("Ваши цели отправлены на рассмотрение администрации. Ожидайте подтверждения. <br>До момента одобрения или отклонения вы можете изменить цели с помощью верба <b>Set Custom Objectives</b> (вкладка IC)."))
	addtimer(CALLBACK(src, PROC_REF(handle_objectives_timeout), player.mind), 5 MINUTES)

/datum/antagonist/traitor/proc/approve_custom_objectives(datum/mind/player)
	if(!pending_custom_objectives.len) return
	objectives_confirmed = TRUE
	objectives_denied = FALSE

	for(var/text in pending_custom_objectives)
		var/datum/objective/custom/C = new
		C.owner = player
		C.explanation_text = text
		player.objectives += C

	pending_custom_objectives.Cut()
	to_chat(player.current, SPAN_GOOD("Ваши цели были одобрены администрацией!"))
	message_staff("[key_name_admin(usr)] одобрил цели трейтора [key_name(player.current)].")

/datum/antagonist/traitor/proc/deny_custom_objectives(datum/mind/player)
	objectives_denied = TRUE
	pending_custom_objectives.Cut()
	to_chat(player.current, SPAN_WARNING("Ваши цели были отклонены администрацией. Вам выдан стандартный набор."))
	create_objectives(player)
	message_staff("[key_name_admin(usr)] отклонил цели трейтора [key_name(player.current)].")

/datum/antagonist/traitor/proc/edit_custom_objectives(datum/mind/player)
	if(!check_rights(R_ADMIN|R_MOD))
		return
	if(!pending_custom_objectives.len)
		to_chat(usr, SPAN_WARNING("Нет предложенных целей для редактирования."))
		return

	// Показываем текущие цели с возможностью изменить (многострочное поле)
	var/current = jointext(pending_custom_objectives, "\n")
	var/new_text = input(usr, "Отредактируйте цели (каждая с новой строки):", "Редактирование целей [key_name(player.current)]", current) as message|null
	if(isnull(new_text))
		return

	// Разбиваем на строки
	var/list/edited = list()
	for(var/line in splittext(new_text, "\n"))
		line = trim(line)
		if(line != "")
			edited += line

	if(!length(edited))
		to_chat(usr, SPAN_WARNING("Нельзя сохранить пустой список целей."))
		return

	// Заменяем pending на отредактированное и сразу одобряем
	pending_custom_objectives = edited
	objectives_confirmed = TRUE
	objectives_denied = FALSE

	// Создаём кастомные цели
	for(var/text in pending_custom_objectives)
		var/datum/objective/custom/C = new
		C.owner = player
		C.explanation_text = text
		player.objectives += C

	pending_custom_objectives.Cut()
	to_chat(player.current, SPAN_GOOD("Администратор обновил ваши цели. Проверьте их!"))
	message_staff("[key_name_admin(usr)] отредактировал и одобрил цели трейтора [key_name(player.current)].")

/datum/antagonist/traitor/proc/handle_objectives_timeout(datum/mind/player)
	if(objectives_confirmed || objectives_denied)
		return
	to_chat(player.current, SPAN_WARNING("Время на рассмотрение ваших целей истекло. Они были автоматически одобрены."))
	approve_custom_objectives(player)

/datum/antagonist/traitor/proc/handle_input_timeout(datum/mind/player)
	if(length(pending_custom_objectives)) return   // уже ввёл
	message_staff("[key_name_admin(player.current)] не ввёл обязательные цели для трейтора. Выданы стандартные цели.")
	to_chat(player.current, SPAN_WARNING("Вы не ввели цели вовремя. Вам выдан стандартный набор."))
	create_objectives(player)

// Верб для повторного открытия ввода целей (доступен трейторам)
/client/verb/set_custom_objectives()
	set name = "Set Custom Objectives"
	set category = "IC"
	set desc = "Повторно открыть окно ввода кастомных целей."

	var/datum/antagonist/traitor/T = GLOB.traitors
	if(!T || !(usr.mind in T.current_antagonists))
		to_chat(usr, SPAN_WARNING("Вы не являетесь трейтором."))
		return
	if(T.objectives_input_timeout > 0 && T.objectives_input_timeout < world.time)
		to_chat(usr, SPAN_WARNING("Время на ввод целей истекло."))
		return
	if(T.objectives_confirmed || T.objectives_denied)
		to_chat(usr, SPAN_WARNING("Ваши цели уже обработаны."))
		return
	T.propose_custom_objectives(usr)

// ----------- Тип кастомной цели -----------

/datum/objective/custom
	explanation_text = ""

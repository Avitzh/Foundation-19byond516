// Файл GOC_team.dm
// Админские кнопки и механика вызова ГОК

/client/proc/goc_team()
	set name = "Dispatch GOC Squad"
	set category = "Special Verbs"
	set desc = "Send a GOC team to the station"

	if(!holder)
		to_chat(usr, SPAN_DANGER("Only administrators may use this command."))
		return
	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(usr, SPAN_DANGER("The game hasn't started yet!"))
		return
	if(send_emergency_team_goc)
		to_chat(usr, SPAN_DANGER("A GOC team is already being dispatched!"))
		return
	if(alert("Do you want to dispatch a GOC team?",,"Yes","No") != "Yes")
		return

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	if(security_state.current_security_level_is_lower_than(security_state.severe_security_level))
		switch(alert("Current security level lower than [security_state.severe_security_level.name]. Do you still want to dispatch this team?",,"Yes","No"))
			if("No")
				return

	var/reason = input("What is the reason for dispatching the GOC?", "Dispatching GOC") as text|null
	if(!reason && alert("You did not input a reason. Continue anyway?",,"Yes", "No") != "Yes")
		return

	if(send_emergency_team_goc)
		to_chat(usr, SPAN_DANGER("Looks like someone beat you to it!"))
		return

	// Спрашиваем, нужно ли оповещать станцию
	var/announce = (alert("Do you want to announce the GOC dispatch to the station?", "Announce", "Yes", "No") == "Yes")

	if(reason)
		message_staff("[key_name_admin(usr)] is dispatching the GOC for the reason: [reason] ([announce ? "announced" : "silent"])", 1)
	else
		message_staff("[key_name_admin(usr)] is dispatching the GOC. ([announce ? "announced" : "silent"])", 1)

	log_admin("[key_name(usr)] used Dispatch GOC.")
	trigger_goc_response_team(reason, announce)

/proc/trigger_goc_response_team(reason = "", announce = TRUE)
	if(send_emergency_team_goc)
		return

	var/datum/antagonist/goc/team = GLOB.goc
	if(!team)
		return
	if(!team.starting_locations || !team.starting_locations.len)
		team.get_starting_locations()

	if(announce)
		command_announcement.Announce(
			"A Global Occult Coalition strike team has been dispatched to [station_name()].",
			"UNGOC High Command",
			'sounds/scp/broadcast.ogg'   // замените на свой звук при желании
		)

	team.reason = reason
	active_goc = team

	send_emergency_team_goc = 1
	sleep(600 * 5)   // 5 минут на сбор
	send_emergency_team_goc = 0
	active_goc = null

/client/verb/JoinGOCSquad()
	set name = "Join GOC Squad"
	set category = "OOC"

	if(!MayRespawn(1))
		to_chat(usr, SPAN_WARNING("You cannot join the GOC at this time."))
		return

	if(isghost(usr) || isnewplayer(usr))
		if(!send_emergency_team_goc || !active_goc)
			to_chat(usr, "No GOC team is currently being sent.")
			return
		if(jobban_isbanned(usr, "goc") || jobban_isbanned(usr, "Security Officer"))
			to_chat(usr, SPAN_DANGER("You are jobbanned from the GOC!"))
			return
		if(active_goc.current_antagonists.len >= active_goc.hard_cap)
			to_chat(usr, "The GOC team is already full!")
			return
		if(!active_goc.starting_locations || !active_goc.starting_locations.len)
			active_goc.get_starting_locations()
		active_goc.create_default(usr)
	else
		to_chat(usr, "You need to be an observer or new player to use this.")

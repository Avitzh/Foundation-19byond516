var/global/send_emergency_team = 0

// Базовый тип для всех МОГ
/datum/antagonist/mtf
	id = MODE_ERT
	role_text = "MTF Operative"
	role_text_plural = "MTF Operatives"
	welcome_text = "You are part of a Mobile Task Force. Follow your leader and complete the mission."
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the site and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to the MTF.</b>"
	leader_welcome_text = "You shouldn't see this"
	landmark_id = "Response Team"
	id_type = /obj/item/card/id/mtf

	flags = ANTAG_OVERRIDE_JOB | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7
	show_objectives_on_creation = 0
	var/reason = ""

	var/agent_outfit = null
	var/leader_outfit = null

/datum/antagonist/mtf/create_default(mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/mtf/New()
	..()
	if(leader_welcome_text == initial(leader_welcome_text))
		leader_welcome_text = "As leader of [role_text], you answer only to the O5 Council, and have authority to override the Site staff where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the site staff where possible, however."

/datum/antagonist/mtf/greet(datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "The Mobile Task Force works for the O5 Council; your job is to contain loose SCPs and eliminate infiltrators. There is a code red alert at [station_name()], you are tasked to go and fix the problem.")
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

/datum/antagonist/mtf/equip(mob/living/carbon/human/player)
	player.add_language(LANGUAGE_ENGLISH)

	var/outfit_to_use = agent_outfit
	if(leader && player.mind == leader && leader_outfit)
		outfit_to_use = leader_outfit

	if(outfit_to_use)
		dressup_human(player, outfits_decls_by_type_[outfit_to_use], TRUE)
	else
		dressup_human(player, outfits_decls_by_type_[/decl/hierarchy/outfit/mtf/epsilon_11/agent], TRUE)

	// Добавляем тактические голосовые команды
	add_verb(player, /mob/proc/mtf_classd_spotted_emote)
	add_verb(player, /mob/proc/mtf_you_stop_emote)
	add_verb(player, /mob/proc/mtf_come_out_bastard_emote)
	add_verb(player, /mob/proc/mtf_target_terminated_emote)
	add_verb(player, /mob/proc/mtf_classd_terminated_emote)
	add_verb(player, /mob/proc/mtf_statue_spotted_emote)
	add_verb(player, /mob/proc/mtf_plague_doctor_spotted_emote)
	add_verb(player, /mob/proc/mtf_hey_halt_emote)
	add_verb(player, /mob/proc/mtf_come_out_die_emote)

	// Регистрируем эмоуты в системе, чтобы работали через *ключ
	for(var/emote_type in typesof(/datum/emote/mtf))
		if(emote_type == /datum/emote/mtf)
			continue
		var/datum/emote/E = GLOB.all_emotes[emote_type]
		if(E)
			player.set_emote(E.key, E)

	// Регистрируем сигнал речи для звука рации
	RegisterSignal(player, COMSIG_LIVING_TREAT_MESSAGE, PROC_REF(play_mtf_radio_beep))

	return 1

/datum/antagonist/mtf/proc/play_mtf_radio_beep(mob/living/speaker, list/message_args)
	// Проверяем, что на персонаже надета гарнитура ERT (в левом или правом ухе)
	var/mob/living/carbon/human/H = speaker
	if(!istype(H))
		return
	if(istype(H.l_ear, /obj/item/device/radio/headset/ert) || istype(H.r_ear, /obj/item/device/radio/headset/ert))
		playsound(speaker, 'sounds/effects/BeepMTF.ogg', 25, 0, falloff = 3, frequency = rand(80, 120) / 100)

/datum/antagonist/mtf/remove_antagonist(datum/mind/player, show_message, implanted)
	. = ..()
	if(. && player.current)
		UnregisterSignal(player.current, COMSIG_LIVING_TREAT_MESSAGE)

// ------------------------------------------------------------------
// Конкретные отряды
// ------------------------------------------------------------------

GLOBAL_DATUM_INIT(mtf_epsilon_11, /datum/antagonist/mtf/epsilon_11, new)
/datum/antagonist/mtf/epsilon_11
	role_text = "MTF Nine-Tailed Fox - Epsilon-11 Agent"
	role_text_plural = "MTF Nine-Tailed Fox - Epsilon-11 Agents"
	welcome_text = "As Agent of the Epsilon-11 taskforce, you only answer to your leader, nobody else."
	agent_outfit = /decl/hierarchy/outfit/mtf/epsilon_11/agent
	leader_outfit = /decl/hierarchy/outfit/mtf/epsilon_11/leader

	/// Доступные классы для обычных агентов (не лидера)
	var/list/class_outfits = list(
		"Agent"    = /decl/hierarchy/outfit/mtf/epsilon_11/agent,
		"Breacher" = /decl/hierarchy/outfit/mtf/epsilon_11/breacher,
		"Medic"    = /decl/hierarchy/outfit/mtf/epsilon_11/medic,
		"Pointman" = /decl/hierarchy/outfit/mtf/epsilon_11/pointman
	)

/datum/antagonist/mtf/epsilon_11/equip(mob/living/carbon/human/player)
	player.add_language(LANGUAGE_ENGLISH)

	var/outfit_to_use
	if(leader && player.mind == leader && leader_outfit)
		// Лидер – сразу выдаём его уникальный аутфит
		outfit_to_use = leader_outfit
	else
		// Предлагаем обычному агенту выбрать класс
		var/chosen_class = input(player, "Choose your specialization:", "MTF Class Selection") as null|anything in class_outfits
		if(chosen_class)
			outfit_to_use = class_outfits[chosen_class]
		else
			// Если игрок закрыл окно или не выбрал – даём стандартного агента
			outfit_to_use = agent_outfit

	// Применяем выбранный или запасной аутфит
	if(outfit_to_use)
		dressup_human(player, outfits_decls_by_type_[outfit_to_use], TRUE)
	else
		dressup_human(player, outfits_decls_by_type_[/decl/hierarchy/outfit/mtf/epsilon_11/agent], TRUE)

	// Тактические голосовые команды (общие для всех МОГ)
	add_verb(player, /mob/proc/mtf_classd_spotted_emote)
	add_verb(player, /mob/proc/mtf_you_stop_emote)
	add_verb(player, /mob/proc/mtf_come_out_bastard_emote)
	add_verb(player, /mob/proc/mtf_target_terminated_emote)
	add_verb(player, /mob/proc/mtf_classd_terminated_emote)
	add_verb(player, /mob/proc/mtf_statue_spotted_emote)
	add_verb(player, /mob/proc/mtf_plague_doctor_spotted_emote)
	add_verb(player, /mob/proc/mtf_hey_halt_emote)
	add_verb(player, /mob/proc/mtf_come_out_die_emote)

	// Регистрируем эмоуты в системе для использования через *
	for(var/emote_type in typesof(/datum/emote/mtf))
		if(emote_type == /datum/emote/mtf)
			continue
		var/datum/emote/E = GLOB.all_emotes[emote_type]
		if(E)
			player.set_emote(E.key, E)

	// Звук рации при разговоре
	RegisterSignal(player, COMSIG_LIVING_TREAT_MESSAGE, PROC_REF(play_mtf_radio_beep))

	return 1

GLOBAL_DATUM_INIT(mtf_nu_7, /datum/antagonist/mtf/nu_7, new)
/datum/antagonist/mtf/nu_7
	role_text = "MTF Nu-7 Operative"
	role_text_plural = "MTF Nu-7 Operatives"
	welcome_text = "You are a Hammer Down operative. Lightning and thunder!"
	agent_outfit = /decl/hierarchy/outfit/mtf/nu_7

GLOBAL_DATUM_INIT(mtf_beta_7, /datum/antagonist/mtf/beta_7, new)
/datum/antagonist/mtf/beta_7
	role_text = "MTF Beta-7 Operative"
	role_text_plural = "MTF Beta-7 Operatives"
	welcome_text = "You are a Maz Hatter specialist. Handle chemical and biological hazards."
	agent_outfit = /decl/hierarchy/outfit/mtf/beta_7

GLOBAL_DATUM_INIT(mtf_eta_10, /datum/antagonist/mtf/eta_10, new)
/datum/antagonist/mtf/eta_10
	role_text = "MTF Eta-10 Operative"
	role_text_plural = "MTF Eta-10 Operatives"
	welcome_text = "You are a See No Evil operative. Memetic and visual hazards are your specialty."
	agent_outfit = /decl/hierarchy/outfit/mtf/eta_10

GLOBAL_DATUM_INIT(mtf_alpha_1, /datum/antagonist/mtf/alpha_1, new)
/datum/antagonist/mtf/alpha_1
	role_text = "MTF Alpha-1 Operative"
	role_text_plural = "MTF Alpha-1 Operatives"
	welcome_text = "You are the Red Right Hand. Only the O5 Council can command you."
	agent_outfit = /decl/hierarchy/outfit/mtf/alpha_1

GLOBAL_DATUM_INIT(mtf_omega_1, /datum/antagonist/mtf/omega_1, new)
/datum/antagonist/mtf/omega_1
	role_text = "MTF Omega-1 Enforcement"
	role_text_plural = "MTF Omega-1 Enforcements"
	welcome_text = "You are the Law's Left Hand. Enforce internal directives and discipline."
	agent_outfit = /decl/hierarchy/outfit/mtf/omega1

GLOBAL_DATUM_INIT(mtf_epsilon_9, /datum/antagonist/mtf/epsilon_9, new)
/datum/antagonist/mtf/epsilon_9
	role_text = "MTF Epsilon-9 Operative"
	role_text_plural = "MTF Epsilon-9 Operatives"
	welcome_text = "You are a Fire Eater. Incendiary tactics and heavy firepower are your tools."
	agent_outfit = /decl/hierarchy/outfit/mtf/epsilon_9

GLOBAL_DATUM_INIT(mtf_isd, /datum/antagonist/mtf/isd, new)
/datum/antagonist/mtf/isd
	role_text = "Internal Security Department Operative"
	role_text_plural = "ISD Operatives"
	welcome_text = "You are part of the Internal Security Department. Maintain order and investigate irregularities."
	agent_outfit = /decl/hierarchy/outfit/mtf/isd

GLOBAL_DATUM_INIT(mtf_o5rep, /datum/antagonist/mtf/o5rep, new)
/datum/antagonist/mtf/o5rep
	role_text = "O5 Representative"
	role_text_plural = "O5 Representatives"
	welcome_text = "You represent the O5 Council. Your word is law."
	agent_outfit = /decl/hierarchy/outfit/mtf/o5rep
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	hard_cap = 1
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

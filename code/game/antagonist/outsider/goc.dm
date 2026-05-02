// Глобальная переменная для ГОК
var/global/datum/antagonist/goc/active_goc = null
// Блокировка отправки
var/global/send_emergency_team_goc = 0

GLOBAL_DATUM_INIT(goc, /datum/antagonist/goc, new)

/datum/antagonist/goc
	id = "goc"
	role_text = "GOC Operative"
	role_text_plural = "GOC Operatives"
	welcome_text = "You are a member of the Global Occult Coalition. Follow your leader and complete the mission."
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the site and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to the GOC.</b>"
	leader_welcome_text = "You shouldn't see this"
	landmark_id = "GOC_Spawn"
	id_type = /obj/item/card/id/physics

	flags = ANTAG_OVERRIDE_JOB | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7
	show_objectives_on_creation = 0
	var/reason = ""

	var/agent_outfit = /decl/hierarchy/outfit/goc/trooper
	var/leader_outfit = /decl/hierarchy/outfit/goc/leader

	var/list/class_outfits = list(
		"Trooper"       = /decl/hierarchy/outfit/goc/trooper,
		"Machinegunner" = /decl/hierarchy/outfit/goc/machinegunner,
		"Grenadier"     = /decl/hierarchy/outfit/goc/grenadier,
		"Pointman"      = /decl/hierarchy/outfit/goc/pointman
	)

/datum/antagonist/goc/create_default(mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/goc/New()
	..()
	if(leader_welcome_text == initial(leader_welcome_text))
		leader_welcome_text = "As leader of [role_text], you answer only to the Coalition High Command. You have authority to override the Site staff where necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the site staff where possible, however."

/datum/antagonist/goc/greet(datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "The Global Occult Coalition has been dispatched to [station_name()] to respond to the current crisis.")
	to_chat(player.current, "Gear up and discuss a plan with your team. More members may be incoming, do not move out before you're ready.")

/datum/antagonist/goc/equip(mob/living/carbon/human/player)
	player.add_language(LANGUAGE_ENGLISH)

	var/outfit_to_use
	if(leader && player.mind == leader && leader_outfit)
		outfit_to_use = leader_outfit
	else
		var/chosen_class = input(player, "Choose your specialization:", "GOC Class Selection") as null|anything in class_outfits
		if(chosen_class)
			outfit_to_use = class_outfits[chosen_class]
		else
			outfit_to_use = agent_outfit

	if(outfit_to_use)
		dressup_human(player, outfits_decls_by_type_[outfit_to_use], TRUE)
	else
		dressup_human(player, outfits_decls_by_type_[/decl/hierarchy/outfit/goc/trooper], TRUE)

	return 1

/datum/antagonist/goc/remove_antagonist(datum/mind/player, show_message, implanted)
	. = ..()

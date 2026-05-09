// ==================================================================
// SCP-1678-A - моб
// ==================================================================

/mob/living/carbon/human/scp1678
	name = "tall masked figure"
	desc = "A tall, unnerving figure with fabric scraps covering its face."
	icon = 'icons/SCP/scp-1678.dmi'
	icon_state = null

	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7
	status_flags = CANPUSH
	maxHealth = 250
	health = 250

	roundstart_traits = list(TRAIT_ADVANCED_TOOL_USER)

	var/emote_cooldown = 5 SECONDS
	var/emote_cooldown_track = 0
	var/area/spawn_area
	var/turf/start_turf

/mob/living/carbon/human/scp1678/Initialize(mapload, new_species = "SCP-1678-A")
	. = ..(mapload, "SCP-1678-A")
	SCP = new /datum/scp(src, "tall masked figure", SCP_EUCLID, "1678-A", SCP_PLAYABLE|SCP_ROLEPLAY)

	add_verb(src, list(/client/proc/scpooc, /mob/living/carbon/human/scp1678/verb/SayPhrase))

	add_language(LANGUAGE_ENGLISH)
	add_language(LANGUAGE_EAL)
	add_language(LANGUAGE_GUTTER)

	SCP.min_time = 15 MINUTES
	SCP.min_playercount = 10

	spawn_area = get_area(src)
	start_turf = get_turf(src)

	// Рентгеновское зрение
	if(!(MUTATION_XRAY in mutations))
		mutations.Add(MUTATION_XRAY)
		update_mutations()
		update_sight()

	queue_icon_update()

// ==================================================================
// Отрисовка иконки (минимальная, как у 106)
// ==================================================================

/mob/living/carbon/human/scp1678/update_icons()
	return

/mob/living/carbon/human/scp1678/on_update_icon()
	if(lying || resting)
		var/matrix/M = matrix()
		transform = M.Turn(90)
	else
		transform = null
	return

// ==================================================================
// Защита от падений и оглушений
// ==================================================================

/mob/living/carbon/human/scp1678/handle_stunned()
	if(stunned)
		stunned = 0
	return 0

/mob/living/carbon/human/scp1678/handle_weakened()
	if(weakened)
		weakened = 0
	return 0

/mob/living/carbon/human/scp1678/succumb()
	to_chat(src, SPAN_WARNING("You cannot succumb!"))
	return

/mob/living/carbon/human/scp1678/Life()
	. = ..()
	if(lying) lying = 0
	if(resting) resting = 0
	if(weakened) weakened = 0
	if(stunned) stunned = 0
	if(stat == UNCONSCIOUS) stat = CONSCIOUS

/mob/living/carbon/human/scp1678/get_pressure_weakness()
	return 0

/mob/living/carbon/human/scp1678/handle_breath()
	return 1

// ==================================================================
// Скорость (медленнее обычного человека)
// ==================================================================

/mob/living/carbon/human/scp1678/movement_delay(decl/move_intent/using_intent = move_intent)
	return 4.0

// ==================================================================
// Звуки шагов (опционально)
// ==================================================================

/mob/living/carbon/human/scp1678/play_special_footstep_sound(turf/T, volume = 30, range = 1)
	playsound(T, 'sounds/effects/footstep/gravel1.ogg', max(20, volume), TRUE, range)
	return TRUE

// ==================================================================
// Ограничение речи (только через SayPhrase)
// ==================================================================

/mob/living/carbon/human/scp1678/say(message, datum/language/speaking = null, whispering)
	to_chat(src, SPAN_NOTICE("You cannot speak normally. Use 'Say Phrase'."))
	return 0

/mob/living/carbon/human/scp1678/verb/SayPhrase()
	set name = "Say Phrase"
	set category = "SCP-1678"
	set desc = "Speak one of your pre-defined phrases"

	if(stat == DEAD)
		return
	if(world.time < emote_cooldown_track)
		to_chat(src, SPAN_WARNING("You cannot speak yet. Wait [round((emote_cooldown_track - world.time) / 10)] seconds."))
		return

	var/list/phrases = list(
		"By order of the Watch, you are to be detained.",
		"Remain calm. Resistance will be met with force.",
		"Halt, citizen. Your papers are out of order.",
		"Step out of the shadows. Compliance is mandatory.",
		"You are in violation of the Public Decency Act."
	)
	var/selected_phrase = input(src, "Choose a phrase:", "SCP-1678 Phrases") as null|anything in phrases
	if(!selected_phrase)
		return

	playsound(src, 'sounds/scp/1678/whistle.ogg', 40, 1)
	visible_message(SPAN_DANGER("[src] utters in a metallic drone: '[selected_phrase]'"))
	emote_cooldown_track = world.time + emote_cooldown

// ==================================================================
// Смерть (исчезает)
// ==================================================================

/mob/living/carbon/human/scp1678/death(gibbed)
	visible_message(SPAN_DANGER("[src] collapses and crumbles into dust!"))
	playsound(get_turf(src), 'sounds/scp/1678/whistle.ogg', 30, 1)
	qdel(src)

// ==================================================================
// AI для автоматического передвижения (когда не под игроком)
// ==================================================================

/datum/ai_holder/simple_animal/melee/scp1678
	mauling = TRUE
	vision_range = 10

/mob/living/carbon/human/scp1678/ai_holder_type = /datum/ai_holder/simple_animal/melee/scp1678

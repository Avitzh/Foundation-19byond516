// ============================================================================
// SCP-993 - Bobble the Clown
// ============================================================================

// ========== GLOBAL LIST FOR TV SPAWNS ==========
GLOBAL_LIST_EMPTY(scp993_tv_spawns)

// ============================================================================
// SCP-993 MOB
// ============================================================================

/mob/living/simple_animal/scp993
	name = "Bobble the Clown"
	desc = "A tall figure in a colorful clown costume. Its smile is unnaturally wide, and its eyes are glassy like an old television screen. It smells faintly of burnt sugar and static."
	icon = 'icons/SCP/scp-993.dmi'
	icon_state = "bobble"
	icon_living = "bobble"
	icon_dead = "bobble_dead"

	see_invisible = SEE_INVISIBLE_NOLIGHTING
	see_in_dark = 7

	// ========== ACTION COOLDOWNS ==========
	var/action_cooldown_time = 4 SECONDS
	var/action_cooldown = 0

	// ========== ABILITY COOLDOWNS ==========
	var/quiet_time_cooldown_time = 90 SECONDS
	var/lesson_cooldown_time = 120 SECONDS
	var/cooking_cooldown_time = 180 SECONDS

	// ========== COOLDOWN TRACKERS ==========
	var/quiet_time_cooldown = 0
	var/lesson_cooldown = 0
	var/cooking_cooldown = 0

	// ========== LESSON STATE ==========
	var/lesson_active = FALSE
	var/mob/living/carbon/human/lesson_target = null

	// ========== GLITCH EFFECT ==========
	var/glitch_active = TRUE

	// ========== TV REFERENCE ==========
	var/obj/structure/scp993_tv/my_tv = null

	maxHealth = 150
	health = 150

	movement_cooldown = 3.5
	speak_emote = list("says cheerfully", "giggles")

	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "hits"

	universal_speak = TRUE

/mob/living/simple_animal/scp993/Initialize(mapload)
	. = ..()
	SCP = new /datum/scp(
		src,
		"clown",
		SCP_EUCLID,
		"993",
		SCP_PLAYABLE | SCP_ROLEPLAY
	)
	add_verb(src, /client/proc/scpooc)

	SCP.min_time = 0
	SCP.min_playercount = 0

	add_language(LANGUAGE_ENGLISH, TRUE)
	create_digital_aura()

/mob/living/simple_animal/scp993/Destroy()
	lesson_target = null
	remove_digital_aura()
	if(my_tv)
		my_tv.bobble = null
		my_tv = null
	return ..()

// ========== DOOR HANDLING ==========

/mob/living/simple_animal/scp993/UnarmedAttack(atom/A)
	if(world.time < action_cooldown)
		return

	// Open only unrestricted doors
	if(istype(A, /obj/machinery/door/airlock))
		var/obj/machinery/door/airlock/D = A
		if(D.density && !(D.req_access && LAZYLEN(D.req_access)))
			D.open()
			action_cooldown = world.time + action_cooldown_time
		return

	// Boop humans
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		if(H.stat == DEAD)
			return
		playsound(src.loc, 'sounds/items/bikehorn.ogg', 40)
		visible_message(SPAN_WARNING("[src] playfully boops [H] on the nose with a squeaky horn!"))
		H.Weaken(1)
		action_cooldown = world.time + action_cooldown_time
		return
	return ..()

// ========== PHASE THROUGH ALL DOORS ==========

/mob/living/simple_animal/scp993/Bump(atom/A)
	if(istype(A, /obj/machinery/door))
		var/obj/machinery/door/D = A
		if(!D.density)
			return
		var/turf/next_turf = get_step(src, dir)
		if(next_turf && !next_turf.density)
			forceMove(next_turf)
		return
	..()

// ========== PASS THROUGH DOORS ==========

/mob/living/simple_animal/scp993/Bump(atom/A)
	if(istype(A, /obj/machinery/door))
		var/turf/next_turf = get_step(src, dir)
		if(next_turf && !next_turf.density)
			forceMove(next_turf)
		return
	..()

// ========== GLITCH EFFECT ==========

/mob/living/simple_animal/scp993/proc/create_digital_aura()
	if(!glitch_active)
		return
	glitch_active = TRUE
	alpha = 210
	set_light(2, 0.5, l_color = "#FF69B4")
	addtimer(CALLBACK(src, PROC_REF(glitch_flicker)), rand(5, 15))

/mob/living/simple_animal/scp993/proc/glitch_flicker()
	if(!glitch_active || stat == DEAD)
		return
	var/current_alpha = alpha
	alpha = rand(150, 180)
	addtimer(CALLBACK(src, PROC_REF(reset_alpha), current_alpha), 1)
	addtimer(CALLBACK(src, PROC_REF(glitch_flicker)), rand(3, 10))

/mob/living/simple_animal/scp993/proc/reset_alpha(new_alpha)
	if(!glitch_active || stat == DEAD)
		return
	alpha = new_alpha

/mob/living/simple_animal/scp993/proc/remove_digital_aura()
	glitch_active = FALSE
	alpha = 255
	set_light(0)

// ========== MOVEMENT WITH CLOWN STEPS ==========

/mob/living/simple_animal/scp993/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0)
	. = ..()
	if(.)
		playsound(src.loc, 'sounds/effects/clownstep1.ogg', 20)

// ========== DAMAGE - RETURN TO TV ==========

/mob/living/simple_animal/scp993/death(gibbed)
	if(my_tv && !QDELETED(my_tv) && my_tv.active)
		visible_message(SPAN_DANGER("[src] flickers with static and vanishes in a puff of confetti!"))
		playsound(src.loc, 'sounds/scp/993/static.ogg', 50)
		new /obj/effect/decal/cleanable/confetti(get_turf(src))
		forceMove(get_turf(my_tv))
		revive()
		health = maxHealth
		visible_message(SPAN_WARNING("[src] rematerializes from the television in a burst of static!"))
		playsound(my_tv.loc, 'sounds/scp/993/static.ogg', 50)
		glitch_active = TRUE
		create_digital_aura()
		return

	visible_message(SPAN_DANGER("[src] dissolves into static!"))
	playsound(src.loc, 'sounds/scp/993/static.ogg', 50)
	new /obj/effect/decal/cleanable/confetti(get_turf(src))

	var/list/turfs = list()
	for(var/turf/simulated/floor/F in world)
		if(F.z == z && !F.density)
			turfs += F
	if(LAZYLEN(turfs))
		forceMove(pick(turfs))
		revive()
		health = maxHealth
		visible_message(SPAN_WARNING("[src] reappears elsewhere in a flash of static!"))
		glitch_active = TRUE
		create_digital_aura()

	. = ..()

// ========== ABILITY 1: SHUSH ==========

/mob/living/simple_animal/scp993/verb/Shush()
	set name = "Shush Someone"
	set category = "SCP-993"
	set desc = "Silence a noisy person for 60 seconds."

	if(world.time < quiet_time_cooldown)
		to_chat(src, SPAN_WARNING("Not ready yet. Wait [round((quiet_time_cooldown - world.time) / 10)] seconds."))
		return

	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H == src || H.stat == DEAD)
			continue
		targets += H

	if(!LAZYLEN(targets))
		to_chat(src, SPAN_WARNING("No one to shush nearby."))
		return

	var/mob/living/carbon/human/target = input(src, "Who should be quiet?", "Shush Someone") as null|anything in targets
	if(!target || target.stat == DEAD)
		return

	quiet_time_cooldown = world.time + quiet_time_cooldown_time

	playsound(src.loc, 'sounds/scp/993/shush.ogg', 50)
	visible_message(SPAN_DANGER("[src] presses a finger to its grinning lips, pointing at [target]!"))
	target.silent = max(target.silent, 60)
	to_chat(target, SPAN_DANGER("<b>Bobble shushes you! You cannot speak for 60 seconds!</b>"))

// ========== ABILITY 2: LESSON ==========

/mob/living/simple_animal/scp993/verb/StartLesson()
	set name = "Start Lesson"
	set category = "SCP-993"
	set desc = "Teach someone a lesson. Ask a question and decide if they pass or fail."

	if(world.time < lesson_cooldown)
		to_chat(src, SPAN_WARNING("Not ready yet. Wait [round((lesson_cooldown - world.time) / 10)] seconds."))
		return

	if(lesson_active)
		to_chat(src, SPAN_WARNING("A lesson is already in progress!"))
		return

	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(7, src))
		if(H == src || H.stat != CONSCIOUS)
			continue
		targets += H

	if(!LAZYLEN(targets))
		to_chat(src, SPAN_WARNING("No students nearby."))
		return

	var/mob/living/carbon/human/target = input(src, "Who will be the student?", "Start Lesson") as null|anything in targets
	if(!target || target.stat != CONSCIOUS)
		return

	var/question = input(src, "What question will you ask?", "Lesson Question") as text|null
	if(!question)
		return

	lesson_target = target
	lesson_active = TRUE
	lesson_cooldown = world.time + lesson_cooldown_time

	playsound(src.loc, 'sounds/effects/bells.ogg', 60)
	visible_message(SPAN_DANGER("[src] excitedly points at [lesson_target]!"))

	say("[question]")

/mob/living/simple_animal/scp993/verb/EvaluateAnswer()
	set name = "Evaluate Answer"
	set category = "SCP-993"
	set desc = "Decide if the student's answer was right or wrong."

	if(!lesson_active || !lesson_target)
		to_chat(src, SPAN_WARNING("No active lesson!"))
		return

	var/choice = alert(src, "How did the student answer?", "Evaluate", "Right!", "Wrong!")
	if(!lesson_active || !lesson_target)
		return

	lesson_active = FALSE

	if(choice == "Right!")
		playsound(src.loc, 'sounds/scp/993/yay.ogg', 50)
		visible_message(SPAN_NOTICE("[src] claps with glee! \"Good job, [lesson_target]!\""))
		to_chat(lesson_target, SPAN_NOTICE("<b>Correct! Bobble rewards you with a treat!</b>"))

		var/turf/T = get_turf(lesson_target)
		var/obj/item/reagent_containers/food/snacks/bobble_treat/treat = new(T)
		treat.name = "Bobble's Treat"
		treat.desc = "A slightly burnt cookie with a creepy smiling face drawn in frosting."

		lesson_target.equip_to_slot_or_del(treat, slot_l_hand)
		if(!istype(lesson_target.l_hand, /obj/item/reagent_containers/food/snacks/bobble_treat))
			lesson_target.equip_to_slot_or_del(treat, slot_r_hand)
			if(!istype(lesson_target.r_hand, /obj/item/reagent_containers/food/snacks/bobble_treat))
				to_chat(lesson_target, SPAN_WARNING("Your hands are full! The treat falls to the floor."))
			else
				lesson_target.update_inv_r_hand()
				visible_message(SPAN_NOTICE("A treat appears in [lesson_target]'s right hand!"))
		else
			lesson_target.update_inv_l_hand()
			visible_message(SPAN_NOTICE("A treat appears in [lesson_target]'s left hand!"))
	else
		playsound(src.loc, 'sounds/scp/993/boo.ogg', 60)
		visible_message(SPAN_DANGER("[src] shakes its head and zaps [lesson_target] with a buzzer!"))
		lesson_target.apply_damage(25, BURN)
		lesson_target.Weaken(3)
		to_chat(lesson_target, SPAN_DANGER("<b>WRONG! A painful jolt shoots through you!</b>"))

	lesson_target = null

// ========== ABILITY 3: COOKING SHOW ==========

/mob/living/simple_animal/scp993/verb/CookingShow()
	set name = "Cooking Show"
	set category = "SCP-993"
	set desc = "Cook a corpse into a delicious meal."

	if(world.time < cooking_cooldown)
		to_chat(src, SPAN_WARNING("The kitchen isn't ready. Wait [round((cooking_cooldown - world.time) / 10)] seconds."))
		return

	var/list/targets = list()
	for(var/mob/living/carbon/human/H in view(5, src))
		if(H.stat == DEAD)
			targets += H

	if(!LAZYLEN(targets))
		to_chat(src, SPAN_WARNING("No ingredients nearby! Find a corpse to cook."))
		return

	var/mob/living/carbon/human/victim = input(src, "Who will be the main ingredient?", "Cooking Show") as null|anything in targets
	if(!victim || victim.stat != DEAD)
		return

	cooking_cooldown = world.time + cooking_cooldown_time

	playsound(src.loc, 'sounds/effects/pig1.ogg', 60)
	visible_message(SPAN_DANGER("[src] ties on a frilly apron and begins cooking [victim] into something delicious!"))

	if(!do_after(src, 10 SECONDS, victim, bonus_percentage = 50))
		visible_message(SPAN_WARNING("[src] is interrupted and stomps its foot in frustration!"))
		return

	playsound(src.loc, 'sounds/effects/ding.ogg', 50)
	visible_message(SPAN_DANGER("[src] presents the finished meal with a flourish: a disturbingly appetizing dish!"))

	var/obj/structure/bobble_meal/meal = new(victim.loc)
	meal.name = "cooked [victim.name]"
	meal.desc = "What was once [victim.name], now baked into a disturbingly aromatic dish. Despite everything, it smells delicious."
	meal.icon = victim.icon
	meal.icon_state = victim.icon_state
	meal.overlays = victim.overlays.Copy()

	qdel(victim)

// ========== RP SOUNDS ==========

/mob/living/simple_animal/scp993/verb/Laugh()
	set name = "Laugh"
	set category = "SCP-993"
	set desc = "Laugh creepily."
	if(world.time < action_cooldown)
		return
	var/list/laughs = list('sounds/scp/993/laugh_1.ogg', 'sounds/scp/993/laugh_2.ogg', 'sounds/scp/993/laugh_3.ogg')
	playsound(src.loc, pick(laughs), 50)
	visible_message(SPAN_WARNING("[src] lets out a cheerful, slightly distorted giggle!"))
	action_cooldown = world.time + action_cooldown_time

// ============================================================================
// BOBBLE'S TREAT
// ============================================================================

/obj/item/reagent_containers/food/snacks/bobble_treat
	name = "Bobble's Treat"
	desc = "A slightly burnt cookie decorated with a creepy smiling face."
	icon = 'icons/SCP/scp-993.dmi'
	icon_state = "treat"
	bitesize = 3

/obj/item/reagent_containers/food/snacks/bobble_treat/Initialize(mapload)
	. = ..()
	reagents.add_reagent(/datum/reagent/mindbreaker_toxin, 15)

// ============================================================================
// BOBBLE'S MEAL
// ============================================================================

/obj/structure/bobble_meal
	name = "cooked corpse"
	desc = "A disturbingly prepared body. It smells strangely appetizing."
	icon = 'icons/SCP/scp-993.dmi'
	icon_state = "treat"
	density = TRUE
	anchored = FALSE
	var/eating = FALSE

/obj/structure/bobble_meal/Destroy()
	return ..()

/obj/structure/bobble_meal/attack_hand(mob/user)
	if(eating)
		to_chat(user, SPAN_WARNING("Someone is already eating this!"))
		return

	eating = TRUE

	user.visible_message(
		SPAN_DANGER("[user] begins hungrily devouring [src]..."),
		SPAN_DANGER("You begin eating [src]... It tastes disturbingly good!")
	)

	playsound(src.loc, 'sounds/effects/pig1.ogg', 30)

	if(!do_after(user, 5 SECONDS, src, bonus_percentage = 50))
		user.visible_message(
			SPAN_WARNING("[user] stops eating [src], looking nauseous."),
			SPAN_WARNING("You stop eating. Something feels wrong.")
		)
		eating = FALSE
		return

	playsound(src.loc, 'sounds/effects/ding.ogg', 40)
	user.visible_message(
		SPAN_DANGER("[user] finishes [src] and immediately looks unwell!"),
		SPAN_DANGER("You finish eating. Your mind begins to warp...")
	)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.reagents.add_reagent(/datum/reagent/mindbreaker_toxin, 15)
		H.adjustBruteLoss(10)
		to_chat(H, SPAN_DANGER("Colors shift and sounds distort. What have you done?!"))

	qdel(src)

// ============================================================================
// TV - Sound only in range, turns off when inactive
// ============================================================================

/obj/structure/scp993_tv
	name = "old television"
	desc = "An old television set. It smells of ozone and burnt caramel."
	icon = 'icons/SCP/scp-993.dmi'
	icon_state = "television"
	density = TRUE
	anchored = TRUE
	var/active = TRUE
	var/mob/living/simple_animal/scp993/bobble = null
	var/respawning = FALSE
	var/sound_range = 5

/obj/structure/scp993_tv/Initialize(mapload)
	. = ..()
	update_icon()
	START_PROCESSING(SSobj, src)
	addtimer(CALLBACK(src, PROC_REF(spawn_bobble)), 15 SECONDS)

/obj/structure/scp993_tv/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(bobble && !QDELETED(bobble))
		bobble.my_tv = null
		qdel(bobble)
		bobble = null
	return ..()

/obj/structure/scp993_tv/Process()
	if(!active)
		return
	for(var/mob/M in hearers(sound_range, src))
		M.playsound_local(get_turf(src), 'sounds/scp/993/static.ogg', 20, FALSE)

/obj/structure/scp993_tv/update_icon()
	cut_overlays()
	if(active)
		add_overlay(image(icon, src, "television_broken"))
	else
		add_overlay(image(icon, src, "television_screen"))

/obj/structure/scp993_tv/attack_hand(mob/user)
	active = !active
	if(active)
		user.visible_message(
			SPAN_DANGER("[user] turns on [src]. Static fills the screen..."),
			SPAN_DANGER("You turn on [src]. Something stirs in the static...")
		)
		if(!bobble || QDELETED(bobble))
			spawn_bobble()
	else
		user.visible_message(
			SPAN_DANGER("[user] turns off [src]. The screen fades to black."),
			SPAN_DANGER("You turn off [src].")
		)
		if(bobble && !QDELETED(bobble))
			bobble.my_tv = null
			visible_message(SPAN_WARNING("[bobble] flickers and disappears with a sad wave!"))
			qdel(bobble)
			bobble = null
	playsound(src.loc, 'sounds/scp/993/static.ogg', 50)
	update_icon()

/obj/structure/scp993_tv/attackby(obj/item/W, mob/user)
	user.setClickCooldown(CLICK_CD_ATTACK)

	if(istype(W, /obj/item/wirecutters))
		user.visible_message(
			SPAN_DANGER("[user] cuts the wires of [src]!"),
			SPAN_DANGER("You cut the wires of [src]!")
		)
		playsound(src.loc, 'sounds/scp/993/static.ogg', 50)
		qdel(src)
		return

	if(W.force >= 1)
		user.visible_message(
			SPAN_DANGER("[user] smashes [src] to pieces!"),
			SPAN_DANGER("You smash [src]!")
		)
		playsound(src.loc, 'sounds/scp/993/static.ogg', 50)
		qdel(src)
		return

	..()

/obj/structure/scp993_tv/proc/spawn_bobble()
	if(QDELETED(src) || !active)
		return

	if(bobble && !QDELETED(bobble))
		return

	if(respawning)
		return

	respawning = TRUE

	var/turf/T = get_step(src, pick(GLOB.cardinal))
	if(!T || T.density)
		T = get_turf(src)

	bobble = new(T)
	bobble.my_tv = src
	playsound(src.loc, 'sounds/scp/993/static.ogg', 40)
	visible_message(SPAN_DANGER("[src] flickers violently as Bobble steps out of the screen!"))

	respawning = FALSE

/obj/structure/scp993_tv/examine(mob/user)
	. = ..()
	if(active)
		to_chat(user, SPAN_NOTICE("The screen shows shifting static. Faint shapes move within. It's ON."))
	else
		to_chat(user, SPAN_NOTICE("The screen is dark. It's OFF."))

// ============================================================================
// RANDOM TV SPAWN VIA LANDMARKS
// ============================================================================

/obj/effect/landmark/scp993_tv
	name = "SCP-993 TV spawn point"
	icon_state = "x3"
	invisibility = 101

/obj/effect/landmark/scp993_tv/Initialize(mapload)
	. = ..()
	if(!mapload)
		return INITIALIZE_HINT_QDEL
	GLOB.scp993_tv_spawns += loc
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/scp993_tv/LateInitialize()
	if(LAZYLEN(GLOB.scp993_tv_spawns) > 0)
		var/turf/chosen = pick(GLOB.scp993_tv_spawns)
		new /obj/structure/scp993_tv(chosen)
	for(var/obj/effect/landmark/scp993_tv/L in world)
		qdel(L)
	GLOB.scp993_tv_spawns = null

// ============================================================================
// CONFETTI
// ============================================================================

/obj/effect/decal/cleanable/confetti
	name = "confetti"
	desc = "Colorful bits of paper and glitter."
	icon = 'icons/effects/effects.dmi'
	icon_state = "confetti"
	anchored = TRUE

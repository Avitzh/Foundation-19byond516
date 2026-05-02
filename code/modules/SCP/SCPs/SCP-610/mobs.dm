// code/modules/SCP/SCPs/SCP-610/mobs.dm
// ============================================================================
// SCP-610 - Necromorph mobs (Slasher, Leaper, Lurker, Puker) as simple_animal
// ============================================================================

// ============================================================================
// SOUND HELPER
// ============================================================================

/proc/play_random_flesh_sound(var/atom/source, var/vol = 30)
	var/list/sounds = list(
		'sounds/scp/610/610_flesh.ogg',
		'sounds/scp/610/610_flesh_2.ogg',
		'sounds/scp/610/610_flesh_3.ogg',
		'sounds/scp/610/610_flesh_4.ogg',
		'sounds/scp/610/610_flesh_5.ogg'
	)
	playsound(source, pick(sounds), vol, 0, -2)

// ============================================================================
// HELPER - Check if mob is allied
// ============================================================================

/proc/is_scp610_mob(var/mob/M)
	return (istype(M, /mob/living/simple_animal/hostile/scp610_slasher) || istype(M, /mob/living/simple_animal/hostile/scp610_leaper) || istype(M, /mob/living/simple_animal/hostile/scp610_lurker) || istype(M, /mob/living/simple_animal/hostile/scp610_puker))

// ============================================================================
// SLASHER
// ============================================================================

/mob/living/simple_animal/hostile/scp610_slasher
	name = "slasher"
	desc = "A reanimated corpse reshaped into a horrific form. Its blade arms are deadly."
	icon = 'icons/SCP/scp610/slasher.dmi'
	icon_state = "slasher"
	icon_living = "slasher"
	default_pixel_x = -8
	pixel_x = -8
	pixel_y = 0
	var/nest_cooldown = 60 SECONDS
	var/nest_cooldown_track = 0
	var/move_sound_cooldown = 0
	var/ambient_sound_cooldown = 0
	maxHealth = 150
	health = 150
	movement_cooldown = 3
	natural_weapon = /obj/item/natural_weapon/scp610_slasher_blades
	natural_armor = list(melee = ARMOR_MELEE_RESISTANT, bullet = ARMOR_BALLISTIC_PISTOL)

/mob/living/simple_animal/hostile/scp610_slasher/Initialize(mapload)
	. = ..()
	pixel_x = default_pixel_x
	add_language("Scarred Hivemind")

/mob/living/simple_animal/hostile/scp610_slasher/Life()
	. = ..()
	if(pixel_x != default_pixel_x || pixel_y != 0)
		pixel_x = default_pixel_x
		pixel_y = 0
	if((world.time - ambient_sound_cooldown) >= 8 SECONDS && prob(30))
		play_random_flesh_sound(src, 20)
		ambient_sound_cooldown = world.time

/mob/living/simple_animal/hostile/scp610_slasher/Move()
	. = ..()
	if(. && (world.time - move_sound_cooldown) >= 4 SECONDS && prob(40))
		play_random_flesh_sound(src, 15)
		move_sound_cooldown = world.time

/mob/living/simple_animal/hostile/scp610_slasher/UnarmedAttack(var/atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!is_scp610_mob(H) && H.species?.name != "Scarred Creature")
			playsound(src, 'sounds/scp/610/610_flesh_3.ogg', 30, 0)
			if(prob(15))
				H.infect_scp610()
	return ..()

/mob/living/simple_animal/hostile/scp610_slasher/death(gibbed)
	. = ..()
	var/turf/T = get_turf(src)
	playsound(T, 'sounds/scp/610/610_flesh_2.ogg', 60, TRUE)
	for(var/mob/living/carbon/human/H in range(3, T))
		if(!is_scp610_mob(H))
			H.infect_scp610()
	for(var/turf/simulated/floor/F in range(2, T))
		if(!istype(F, /turf/space) && prob(70))
			new /turf/simulated/floor/flesh(F)
	new /obj/effect/gibspawner/generic(T)
	new /obj/structure/corruption_nest(T)
	qdel(src)

/mob/living/simple_animal/hostile/scp610_slasher/verb/PlaceNest()
	set name = "Place Nest"
	set category = "Necromorph"
	if((world.time - nest_cooldown_track) < nest_cooldown)
		to_chat(src, SPAN_WARNING("Nest is not ready yet!"))
		return
	var/turf/T = get_step(src, src.dir)
	if(!T || T.density)
		to_chat(src, SPAN_WARNING("Not enough space in front of you!"))
		return
	visible_message(SPAN_DANGER("\The [src] tears a chunk of flesh and plants a nest!"))
	adjustBruteLoss(40)
	new /obj/structure/corruption_nest(T)
	play_random_flesh_sound(src, 40)
	nest_cooldown_track = world.time

/mob/living/simple_animal/hostile/scp610_slasher/verb/PlaceMaw()
	set name = "Place Maw"
	set category = "Necromorph"
	var/turf/T = get_step(src, src.dir)
	if(!T || T.density)
		to_chat(src, SPAN_WARNING("Not enough space in front of you!"))
		return
	if(!istype(T, /turf/simulated/floor/flesh) && !istype(T, /turf/simulated/floor/flesh/node))
		to_chat(src, SPAN_WARNING("You can only place a maw on corruption!"))
		return
	visible_message(SPAN_DANGER("\The [src] tears open a gaping maw in the floor!"))
	adjustBruteLoss(20)
	new /obj/structure/corruption_maw(T)
	play_random_flesh_sound(src, 35)

/obj/item/natural_weapon/scp610_slasher_blades
	name = "blade arms"
	attack_verb = list("slashed", "ripped", "cleaved", "scythed")
	hitsound = 'sounds/scp/610/610_flesh_3.ogg'
	damtype = BRUTE
	force = 18
	edge = TRUE
	sharp = TRUE
	armor_penetration = 10

// ============================================================================
// LEAPER
// ============================================================================

/mob/living/simple_animal/hostile/scp610_leaper
	name = "leaper"
	desc = "A twisted creature with a bladed tail. It moves with unsettling, erratic motions."
	icon = 'icons/SCP/scp610/leaper.dmi'
	icon_state = "body"
	icon_living = "body"
	default_pixel_x = -16
	default_pixel_y = -24
	pixel_x = -16
	pixel_y = -24
	var/nest_cooldown = 60 SECONDS
	var/nest_cooldown_track = 0
	var/move_sound_cooldown = 0
	var/ambient_sound_cooldown = 0
	maxHealth = 250
	health = 250
	movement_cooldown = 2
	natural_weapon = /obj/item/natural_weapon/scp610_leaper_tail
	natural_armor = list(melee = ARMOR_MELEE_RESISTANT, bullet = ARMOR_BALLISTIC_PISTOL)
	var/leap_cooldown = 8 SECONDS
	var/gallop_cooldown = 12 SECONDS
	var/leap_cooldown_track = 0
	var/gallop_cooldown_track = 0
	var/aiming_mode = FALSE

/mob/living/simple_animal/hostile/scp610_leaper/Initialize(mapload)
	. = ..()
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y
	add_language("Scarred Hivemind")

/mob/living/simple_animal/hostile/scp610_leaper/Life()
	. = ..()
	if(pixel_x != default_pixel_x || pixel_y != default_pixel_y)
		pixel_x = default_pixel_x
		pixel_y = default_pixel_y
	if((world.time - ambient_sound_cooldown) >= 6 SECONDS && prob(35))
		play_random_flesh_sound(src, 25)
		ambient_sound_cooldown = world.time

/mob/living/simple_animal/hostile/scp610_leaper/Move()
	. = ..()
	if(. && (world.time - move_sound_cooldown) >= 3 SECONDS && prob(50))
		play_random_flesh_sound(src, 20)
		move_sound_cooldown = world.time

/mob/living/simple_animal/hostile/scp610_leaper/UnarmedAttack(var/atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!is_scp610_mob(H) && H.species?.name != "Scarred Creature")
			playsound(src, 'sounds/scp/610/610_flesh_3.ogg', 30, 0)
			if(prob(15))
				H.infect_scp610()
	return ..()

/mob/living/simple_animal/hostile/scp610_leaper/death(gibbed)
	. = ..()
	var/turf/T = get_turf(src)
	playsound(T, 'sounds/scp/610/610_flesh_2.ogg', 60, TRUE)
	for(var/mob/living/carbon/human/H in range(4, T))
		if(!is_scp610_mob(H))
			H.infect_scp610()
	for(var/turf/simulated/floor/F in range(3, T))
		if(!istype(F, /turf/space) && prob(90))
			new /turf/simulated/floor/flesh(F)
	new /obj/effect/gibspawner/human(T)
	new /obj/structure/corruption_nest(T)
	qdel(src)

/mob/living/simple_animal/hostile/scp610_leaper/verb/Leap()
	set name = "Leap"
	set category = "Necromorph"
	if((world.time - leap_cooldown_track) < leap_cooldown)
		to_chat(src, SPAN_WARNING("Leap is not ready yet!"))
		return
	aiming_mode = TRUE
	to_chat(src, SPAN_DANGER("Leap ready! Click a target to pounce."))

/mob/living/simple_animal/hostile/scp610_leaper/ClickOn(atom/A)
	if(aiming_mode)
		aiming_mode = FALSE
		perform_leap(A)
		return
	..()

/mob/living/simple_animal/hostile/scp610_leaper/proc/perform_leap(atom/target)
	var/turf/T = get_turf(target)
	if(!T || T.density)
		to_chat(src, SPAN_WARNING("Can't leap there!"))
		return
	visible_message(SPAN_DANGER("\The [src] launches through the air at [target]!"))
	playsound(get_turf(src), 'sounds/scp/610/610_flesh_5.ogg', 50, TRUE)
	src.forceMove(T)
	for(var/mob/living/carbon/human/H in range(1, T))
		if(H.stat == DEAD) continue
		if(is_scp610_mob(H) || H.species?.name == "Scarred Creature") continue
		H.Weaken(4)
		H.apply_damage(15, BRUTE)
		H.infect_scp610()
		H.visible_message(SPAN_DANGER("[H] is knocked down by the impact!"), SPAN_DANGER("\The [src] crashes into you!"))
	leap_cooldown_track = world.time

/mob/living/simple_animal/hostile/scp610_leaper/verb/Gallop()
	set name = "Gallop"
	set category = "Necromorph"
	if((world.time - gallop_cooldown_track) < gallop_cooldown)
		to_chat(src, SPAN_WARNING("Gallop is not ready yet!"))
		return
	visible_message(SPAN_DANGER("\The [src] breaks into a terrifying gallop!"))
	playsound(get_turf(src), 'sounds/scp/610/610_flesh_5.ogg', 50, TRUE)
	movement_cooldown = 1
	addtimer(CALLBACK(src, /mob/living/simple_animal/hostile/scp610_leaper/proc/end_gallop), 3 SECONDS)
	gallop_cooldown_track = world.time

/mob/living/simple_animal/hostile/scp610_leaper/proc/end_gallop()
	movement_cooldown = 2

/mob/living/simple_animal/hostile/scp610_leaper/verb/PlaceNest()
	set name = "Place Nest"
	set category = "Necromorph"
	if((world.time - nest_cooldown_track) < nest_cooldown)
		to_chat(src, SPAN_WARNING("Nest is not ready yet!"))
		return
	var/turf/T = get_step(src, src.dir)
	if(!T || T.density)
		to_chat(src, SPAN_WARNING("Not enough space in front of you!"))
		return
	visible_message(SPAN_DANGER("\The [src] tears a chunk of flesh and plants a nest!"))
	adjustBruteLoss(40)
	new /obj/structure/corruption_nest(T)
	play_random_flesh_sound(src, 40)
	nest_cooldown_track = world.time

/mob/living/simple_animal/hostile/scp610_leaper/verb/PlaceMaw()
	set name = "Place Maw"
	set category = "Necromorph"
	var/turf/T = get_step(src, src.dir)
	if(!T || T.density)
		to_chat(src, SPAN_WARNING("Not enough space in front of you!"))
		return
	if(!istype(T, /turf/simulated/floor/flesh) && !istype(T, /turf/simulated/floor/flesh/node))
		to_chat(src, SPAN_WARNING("You can only place a maw on corruption!"))
		return
	visible_message(SPAN_DANGER("\The [src] tears open a gaping maw in the floor!"))
	adjustBruteLoss(20)
	new /obj/structure/corruption_maw(T)
	play_random_flesh_sound(src, 35)

/obj/item/natural_weapon/scp610_leaper_tail
	name = "bladed tail"
	attack_verb = list("impaled", "gored", "skewered", "pierced")
	hitsound = 'sounds/scp/610/610_flesh_3.ogg'
	damtype = BRUTE
	force = 22
	edge = TRUE
	sharp = TRUE
	armor_penetration = 15

// ============================================================================
// SPINE PROJECTILE
// ============================================================================

/obj/item/projectile/spine
	name = "bone spine"
	icon = 'icons/SCP/scp610/lurker.dmi'
	icon_state = "spine_projectile"
	damage = 13
	damage_type = BRUTE
	speed = 0.5
	nodamage = FALSE

/obj/item/projectile/spine/on_hit(atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.apply_damage(damage, damage_type)
		H.infect_scp610()
		visible_message(SPAN_DANGER("[H] is impaled by a spine!"))

// ============================================================================
// LURKER
// ============================================================================

/obj/item/natural_weapon/lurker_tentacles
	name = "tentacles"
	attack_verb = list("whipped", "lashed", "slapped")
	hitsound = 'sounds/scp/610/610_flesh_3.ogg'
	damtype = BRUTE
	force = 8
	edge = FALSE
	armor_penetration = 0

/mob/living/simple_animal/hostile/scp610_lurker
	name = "lurker"
	desc = "A small creature with retractable armor."
	icon = 'icons/SCP/scp610/lurker.dmi'
	icon_state = "torso"
	icon_living = "torso"
	default_pixel_x = -16
	pixel_x = -16
	pixel_y = 0
	var/nest_cooldown = 60 SECONDS
	var/nest_cooldown_track = 0
	var/move_sound_cooldown = 0
	var/ambient_sound_cooldown = 0
	maxHealth = 150
	health = 150
	movement_cooldown = 2
	natural_weapon = /obj/item/natural_weapon/lurker_tentacles
	natural_armor = list(melee = ARMOR_MELEE_RESISTANT, bullet = ARMOR_BALLISTIC_RIFLE)
	var/shell_open = FALSE
	var/spine_cooldown = 3 SECONDS
	var/spine_cooldown_track = 0
	var/toggle_cooldown = 2 SECONDS
	var/toggle_cooldown_track = 0
	var/aiming_mode = FALSE

/mob/living/simple_animal/hostile/scp610_lurker/Initialize(mapload)
	. = ..()
	pixel_x = default_pixel_x
	add_language("Scarred Hivemind")

/mob/living/simple_animal/hostile/scp610_lurker/Life()
	. = ..()
	if(pixel_x != default_pixel_x || pixel_y != 0)
		pixel_x = default_pixel_x
		pixel_y = 0
	if((world.time - ambient_sound_cooldown) >= 10 SECONDS && prob(25))
		play_random_flesh_sound(src, 15)
		ambient_sound_cooldown = world.time

/mob/living/simple_animal/hostile/scp610_lurker/Move()
	. = ..()
	if(. && (world.time - move_sound_cooldown) >= 5 SECONDS && prob(30))
		play_random_flesh_sound(src, 12)
		move_sound_cooldown = world.time

/mob/living/simple_animal/hostile/scp610_lurker/UnarmedAttack(var/atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!is_scp610_mob(H) && H.species?.name != "Scarred Creature")
			playsound(src, 'sounds/scp/610/610_flesh_3.ogg', 25, 0)
			if(prob(15))
				H.infect_scp610()
	return ..()

/mob/living/simple_animal/hostile/scp610_lurker/update_icon()
	if(shell_open)
		icon_state = "torso-tentacles"
		icon_living = "torso-tentacles"
	else
		icon_state = "torso"
		icon_living = "torso"

/mob/living/simple_animal/hostile/scp610_lurker/verb/ToggleShell()
	set name = "Toggle Shell"
	set category = "Necromorph"
	if((world.time - toggle_cooldown_track) < toggle_cooldown)
		to_chat(src, SPAN_WARNING("Shell not ready to toggle yet!"))
		return
	shell_open = !shell_open
	aiming_mode = FALSE
	if(shell_open)
		movement_cooldown = 4
		natural_armor = list(melee = ARMOR_MELEE_MINOR, bullet = ARMOR_BALLISTIC_MINOR)
		visible_message(SPAN_DANGER("\The [src]'s shell retracts, exposing its tentacles!"))
		playsound(src, 'sounds/scp/610/610_flesh_4.ogg', 25, 0)
	else
		movement_cooldown = 2
		natural_armor = list(melee = ARMOR_MELEE_RESISTANT, bullet = ARMOR_BALLISTIC_RIFLE)
		visible_message(SPAN_DANGER("\The [src]'s shell closes, armoring it completely!"))
		playsound(src, 'sounds/scp/610/610_flesh_4.ogg', 25, 0)
	toggle_cooldown_track = world.time
	update_icon()

/mob/living/simple_animal/hostile/scp610_lurker/verb/SpineLaunch()
	set name = "Spine Launch"
	set category = "Necromorph"
	if(!shell_open)
		to_chat(src, SPAN_WARNING("You must open your shell first!"))
		return
	if((world.time - spine_cooldown_track) < spine_cooldown)
		to_chat(src, SPAN_WARNING("Spines not ready yet!"))
		return
	aiming_mode = TRUE
	to_chat(src, SPAN_DANGER("Spines ready! Click a target to fire."))

/mob/living/simple_animal/hostile/scp610_lurker/ClickOn(atom/A)
	if(aiming_mode)
		aiming_mode = FALSE
		fire_spines(A)
		return
	..()

/mob/living/simple_animal/hostile/scp610_lurker/proc/fire_spines(atom/target)
	if(!shell_open)
		return
	visible_message(SPAN_DANGER("\The [src] launches a fan of bony spines!"))
	playsound(get_turf(src), 'sounds/scp/610/610_flesh_4.ogg', 40, TRUE)
	var/turf/start_turf = get_turf(src)
	for(var/i in 1 to 3)
		var/obj/item/projectile/spine/P = new /obj/item/projectile/spine(start_turf)
		P.firer = src
		P.original = target
		P.launch(target, src, 0, (i-1)*5 - 5)
	spine_cooldown_track = world.time

/mob/living/simple_animal/hostile/scp610_lurker/death(gibbed)
	. = ..()
	var/turf/T = get_turf(src)
	playsound(T, 'sounds/scp/610/610_flesh_2.ogg', 60, TRUE)
	for(var/mob/living/carbon/human/H in range(3, T))
		if(!is_scp610_mob(H))
			H.infect_scp610()
	for(var/turf/simulated/floor/F in range(2, T))
		if(!istype(F, /turf/space) && prob(70))
			new /turf/simulated/floor/flesh(F)
	new /obj/effect/gibspawner/generic(T)
	new /obj/structure/corruption_nest(T)
	qdel(src)

/mob/living/simple_animal/hostile/scp610_lurker/verb/PlaceNest()
	set name = "Place Nest"
	set category = "Necromorph"
	if((world.time - nest_cooldown_track) < nest_cooldown)
		to_chat(src, SPAN_WARNING("Nest is not ready yet!"))
		return
	var/turf/T = get_step(src, src.dir)
	if(!T || T.density)
		to_chat(src, SPAN_WARNING("Not enough space in front of you!"))
		return
	visible_message(SPAN_DANGER("\The [src] tears a chunk of flesh and plants a nest!"))
	adjustBruteLoss(40)
	new /obj/structure/corruption_nest(T)
	play_random_flesh_sound(src, 40)
	nest_cooldown_track = world.time

/mob/living/simple_animal/hostile/scp610_lurker/verb/PlaceMaw()
	set name = "Place Maw"
	set category = "Necromorph"
	var/turf/T = get_step(src, src.dir)
	if(!T || T.density)
		to_chat(src, SPAN_WARNING("Not enough space in front of you!"))
		return
	if(!istype(T, /turf/simulated/floor/flesh) && !istype(T, /turf/simulated/floor/flesh/node))
		to_chat(src, SPAN_WARNING("You can only place a maw on corruption!"))
		return
	visible_message(SPAN_DANGER("\The [src] tears open a gaping maw in the floor!"))
	adjustBruteLoss(20)
	new /obj/structure/corruption_maw(T)
	play_random_flesh_sound(src, 35)

// ============================================================================
// PUKER PROJECTILE
// ============================================================================

/obj/item/projectile/puker_snap
	name = "acid spit"
	icon = 'icons/SCP/scp610/puker_projectile.dmi'
	icon_state = "pukeshot"
	damage = 14
	damage_type = BURN
	speed = 0.5
	nodamage = FALSE

/obj/item/projectile/puker_snap/on_hit(atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.apply_damage(damage, damage_type)
		H.infect_scp610()
		visible_message(SPAN_DANGER("[H] is splashed with acid!"))

// ============================================================================
// PUKER
// ============================================================================

/obj/item/natural_weapon/puker_claws
	name = "corroded claws"
	attack_verb = list("slashed", "burned", "melted")
	hitsound = 'sounds/scp/610/610_flesh_4.ogg'
	damtype = BURN
	force = 14
	edge = TRUE
	armor_penetration = 5

/mob/living/simple_animal/hostile/scp610_puker
	name = "puker"
	desc = "A bloated creature leaking corrosive fluids. It gurgles with barely contained bile."
	icon = 'icons/SCP/scp610/puker.dmi'
	icon_state = "puker"
	icon_living = "puker"
	default_pixel_x = -8
	pixel_x = -8
	pixel_y = 0
	var/nest_cooldown = 60 SECONDS
	var/nest_cooldown_track = 0
	var/move_sound_cooldown = 0
	var/ambient_sound_cooldown = 0
	maxHealth = 180
	health = 180
	movement_cooldown = 3
	natural_weapon = /obj/item/natural_weapon/puker_claws
	natural_armor = list(melee = ARMOR_MELEE_RESISTANT, bullet = ARMOR_BALLISTIC_PISTOL)
	var/snapshot_cooldown = 3 SECONDS
	var/snapshot_cooldown_track = 0
	var/aiming_mode = FALSE

/mob/living/simple_animal/hostile/scp610_puker/Initialize(mapload)
	. = ..()
	pixel_x = default_pixel_x
	add_language("Scarred Hivemind")

/mob/living/simple_animal/hostile/scp610_puker/Life()
	. = ..()
	if(pixel_x != default_pixel_x || pixel_y != 0)
		pixel_x = default_pixel_x
		pixel_y = 0
	if((world.time - ambient_sound_cooldown) >= 7 SECONDS && prob(35))
		play_random_flesh_sound(src, 25)
		ambient_sound_cooldown = world.time

/mob/living/simple_animal/hostile/scp610_puker/Move()
	. = ..()
	if(. && (world.time - move_sound_cooldown) >= 3 SECONDS && prob(45))
		play_random_flesh_sound(src, 18)
		move_sound_cooldown = world.time

/mob/living/simple_animal/hostile/scp610_puker/UnarmedAttack(var/atom/target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!is_scp610_mob(H) && H.species?.name != "Scarred Creature")
			playsound(src, 'sounds/scp/610/610_flesh_4.ogg', 30, 0)
			if(prob(15))
				H.infect_scp610()
	return ..()

/mob/living/simple_animal/hostile/scp610_puker/death(gibbed)
	. = ..()
	var/turf/T = get_turf(src)
	playsound(T, 'sounds/scp/610/610_flesh_2.ogg', 60, TRUE)
	for(var/mob/living/carbon/human/H in range(4, T))
		if(!is_scp610_mob(H))
			H.infect_scp610()
	for(var/turf/simulated/floor/F in range(3, T))
		if(!istype(F, /turf/space) && prob(90))
			new /turf/simulated/floor/flesh(F)
	new /obj/effect/gibspawner/human(T)
	new /obj/structure/corruption_nest(T)
	qdel(src)

/mob/living/simple_animal/hostile/scp610_puker/verb/Snapshot()
	set name = "Snapshot"
	set category = "Necromorph"
	if((world.time - snapshot_cooldown_track) < snapshot_cooldown)
		to_chat(src, SPAN_WARNING("Snapshot is not ready yet!"))
		return
	aiming_mode = TRUE
	to_chat(src, SPAN_DANGER("Snapshot ready! Click a target to fire."))

/mob/living/simple_animal/hostile/scp610_puker/ClickOn(atom/A)
	if(aiming_mode)
		aiming_mode = FALSE
		fire_snapshot(A)
		return
	..()

/mob/living/simple_animal/hostile/scp610_puker/proc/fire_snapshot(atom/target)
	visible_message(SPAN_DANGER("\The [src] spits a glob of acid at [target]!"))
	playsound(get_turf(src), 'sounds/scp/610/610_flesh_4.ogg', 40, TRUE)
	var/obj/item/projectile/puker_snap/P = new /obj/item/projectile/puker_snap(get_turf(src))
	P.firer = src
	P.original = target
	P.launch(target, src)
	snapshot_cooldown_track = world.time

/mob/living/simple_animal/hostile/scp610_puker/verb/PlaceNest()
	set name = "Place Nest"
	set category = "Necromorph"
	if((world.time - nest_cooldown_track) < nest_cooldown)
		to_chat(src, SPAN_WARNING("Nest is not ready yet!"))
		return
	var/turf/T = get_step(src, src.dir)
	if(!T || T.density)
		to_chat(src, SPAN_WARNING("Not enough space in front of you!"))
		return
	visible_message(SPAN_DANGER("\The [src] tears a chunk of flesh and plants a nest!"))
	adjustBruteLoss(40)
	new /obj/structure/corruption_nest(T)
	play_random_flesh_sound(src, 40)
	nest_cooldown_track = world.time

/mob/living/simple_animal/hostile/scp610_puker/verb/PlaceMaw()
	set name = "Place Maw"
	set category = "Necromorph"
	var/turf/T = get_step(src, src.dir)
	if(!T || T.density)
		to_chat(src, SPAN_WARNING("Not enough space in front of you!"))
		return
	if(!istype(T, /turf/simulated/floor/flesh) && !istype(T, /turf/simulated/floor/flesh/node))
		to_chat(src, SPAN_WARNING("You can only place a maw on corruption!"))
		return
	visible_message(SPAN_DANGER("\The [src] tears open a gaping maw in the floor!"))
	adjustBruteLoss(20)
	new /obj/structure/corruption_maw(T)
	play_random_flesh_sound(src, 35)

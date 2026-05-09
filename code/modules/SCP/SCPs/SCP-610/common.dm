// ============================================================================
// SCP-610 - Common (language, corruption, bottle, disease, structures)
// ============================================================================

// ============================================================================
// LANGUAGE
// ============================================================================

/datum/language/scarred_hivemind
	name = "Scarred Hivemind"
	desc = "A series of wet clicks, rasps, and guttural sounds shared by the flesh-infected."
	speech_verb = "rasps"
	ask_verb = "clicks"
	exclaim_verb = "shrieks"
	key = "h"
	flags = RESTRICTED | HIVEMIND
	shorthand = "FLESH"

// ============================================================================
// CORRUPTION WEEDS
// ============================================================================

/obj/structure/corruption/weeds
	name = "corruption"
	desc = "A patch of writhing, pulsating corruption."
	icon = 'icons/SCP/scp610/structure.dmi'
	icon_state = "corruption-1"
	density = FALSE
	anchored = TRUE
	layer = TURF_LAYER + 0.1
	var/health = 15
	var/max_health = 15
	/// Reference to parent nest
	var/obj/structure/corruption/nest/parent_nest
	/// Is this weed currently dying
	var/dying = FALSE

/obj/structure/corruption/weeds/Initialize(mapload)
	. = ..()
	health = max_health
	icon_state = pick("corruption-1", "corruption-2", "corruption-3")
	if(parent_nest)
		LAZYADD(parent_nest.weed_list, src)

/obj/structure/corruption/weeds/Destroy()
	if(parent_nest)
		LAZYREMOVE(parent_nest.weed_list, src)
		parent_nest = null
	return ..()

/// Heal SCP-610 mobs standing on it
/obj/structure/corruption/weeds/Crossed(atom/movable/AM)
	. = ..()
	if(is_scp610_mob(AM))
		var/mob/living/L = AM
		L.adjustBruteLoss(-3)

/// Damage from melee weapons
/obj/structure/corruption/weeds/attackby(obj/item/W, mob/user)
	user.setClickCooldown(CLICK_CD_ATTACK)
	visible_message(SPAN_DANGER("[user] strikes [src] with [W]!"))
	var/damage = W.force
	if(W.sharp)
		damage *= 1.5
	if(W.edge)
		damage *= 1.2
	health -= damage
	if(health <= 0)
		visible_message(SPAN_DANGER("[src] is destroyed!"))
		qdel(src)

/// Fire destroys corruption
/obj/structure/corruption/weeds/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 400)
		visible_message(SPAN_DANGER("The corruption sizzles and burns away!"))
		qdel(src)

/// Smooth dying animation when nest is destroyed
/obj/structure/corruption/weeds/proc/start_dying()
	if(dying)
		return
	dying = TRUE
	animate(src, alpha = 0, time = rand(3 SECONDS, 8 SECONDS))
	addtimer(CALLBACK(src, PROC_REF(do_qdel)), rand(3 SECONDS, 8 SECONDS))

/obj/structure/corruption/weeds/proc/do_qdel()
	qdel(src)

// ============================================================================
// CORRUPTION NEST
// ============================================================================

/obj/structure/corruption/nest
	name = "nest"
	desc = "A thick column of hardened corruption. It pulses with a warm, organic glow."
	icon = 'icons/SCP/scp610/structure.dmi'
	icon_state = "nest"
	density = TRUE
	anchored = TRUE
	layer = OBJ_LAYER
	var/health = 120
	var/max_health = 120
	/// List of all weeds spawned by this nest
	var/list/weed_list = list()
	/// Max weeds this nest can support
	var/max_weeds = 40

/obj/structure/corruption/nest/Initialize(mapload)
	. = ..()
	health = max_health
	START_PROCESSING(SSobj, src)

	var/turf/T = get_turf(src)
	for(var/turf/simulated/floor/F in range(2, T))
		if(istype(F, /turf/space))
			continue
		if(locate(/obj/structure/corruption/weeds) in F)
			continue
		if(prob(60))
			spawn_weed(F)

/obj/structure/corruption/nest/Destroy()
	STOP_PROCESSING(SSobj, src)
	// Smooth dying for all weeds
	for(var/obj/structure/corruption/weeds/W in weed_list)
		if(W && !QDELETED(W) && !W.dying)
			W.start_dying()
	weed_list.Cut()
	return ..()

/obj/structure/corruption/nest/Process()
	if(LAZYLEN(weed_list) >= max_weeds)
		return

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	for(var/turf/simulated/floor/F in range(3, T))
		if(istype(F, /turf/space))
			continue
		if(locate(/obj/structure/corruption/weeds) in F)
			continue
		if(prob(15))
			spawn_weed(F)

/// Spawn a weed at the specified turf
/obj/structure/corruption/nest/proc/spawn_weed(turf/T)
	if(LAZYLEN(weed_list) >= max_weeds)
		return
	var/obj/structure/corruption/weeds/W = new(T)
	W.parent_nest = src
	LAZYADD(weed_list, W)

/// Melee damage
/obj/structure/corruption/nest/attackby(obj/item/W, mob/user)
	user.setClickCooldown(CLICK_CD_ATTACK)
	visible_message(SPAN_DANGER("[user] strikes [src] with [W]!"))
	var/damage = W.force
	if(W.sharp)
		damage *= 1.5
	if(W.edge)
		damage *= 1.2
	health -= damage
	if(health <= 0)
		visible_message(SPAN_DANGER("[src] ruptures and collapses!"))
		playsound(get_turf(src), 'sounds/scp/610/610_flesh_2.ogg', 60, TRUE)
		qdel(src)

/// Allow passage
/obj/structure/corruption/nest/CanPass(atom/movable/mover, turf/target)
	return TRUE

/// Heal SCP-610 mobs on nest
/obj/structure/corruption/nest/Crossed(atom/movable/AM)
	. = ..()
	if(is_scp610_mob(AM))
		var/mob/living/L = AM
		L.adjustBruteLoss(-5)

/// Fire destroys the nest and all related weeds
/obj/structure/corruption/nest/fire_act(exposed_temperature, exposed_volume)
	if(exposed_temperature > 400)
		visible_message(SPAN_DANGER("[src] is rapidly consumed by flames!"))
		qdel(src)
	else
		health -= round(exposed_temperature / 30)
		if(health <= 0)
			visible_message(SPAN_DANGER("[src] collapses as it burns!"))
			qdel(src)

// ============================================================================
// CORRUPTION MAW
// ============================================================================

/obj/structure/corruption/maw
	name = "maw"
	desc = "A gaping orifice in the floor, lined with teeth of bone and corruption."
	icon = 'icons/SCP/scp610/structure.dmi'
	icon_state = "maw"
	density = FALSE
	anchored = TRUE
	layer = OBJ_LAYER - 0.1
	var/trap_cooldown = 10 SECONDS
	var/list/trapped_mobs = list()

/obj/structure/corruption/maw/Initialize(mapload)
	. = ..()
	playsound(get_turf(src), 'sounds/scp/610/610_flesh_4.ogg', 40, TRUE)
	START_PROCESSING(SSobj, src)

/obj/structure/corruption/maw/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/structure/corruption/maw/Process()
	var/turf/T = get_turf(src)
	if(!T)
		return
	if(!(locate(/obj/structure/corruption/weeds) in T) && !(locate(/obj/structure/corruption/nest) in T))
		visible_message(SPAN_WARNING("[src] withers away without corruption to sustain it!"))
		qdel(src)

/obj/structure/corruption/maw/Crossed(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H in trapped_mobs || H.lying)
			return
		if(is_scp610_mob(H))
			return
		if(H.species?.name == "Scarred Creature")
			return
		if(H.SCP)
			return
		H.visible_message(
			SPAN_DANGER("[H] is caught by the maw!"),
			SPAN_DANGER("A maw snaps shut around your leg!")
		)
		playsound(get_turf(src), 'sounds/scp/610/610_flesh_2.ogg', 50, TRUE)
		H.Weaken(5)
		H.apply_damage(20, BRUTE)
		H.infect_scp610()
		trapped_mobs += H
		addtimer(CALLBACK(src, PROC_REF(release_mob), H), trap_cooldown)

/obj/structure/corruption/maw/proc/release_mob(mob/living/carbon/human/H)
	if(H && !QDELETED(H))
		trapped_mobs -= H

/obj/structure/corruption/maw/attackby(obj/item/W, mob/user)
	if(W.sharp && W.force >= 10)
		visible_message(SPAN_DANGER("[user] cuts through [src], destroying it!"))
		playsound(get_turf(src), 'sounds/scp/610/610_flesh_2.ogg', 40, TRUE)
		qdel(src)
		return
	..()

/obj/structure/corruption/maw/fire_act(exposed_temperature, exposed_volume)
	visible_message(SPAN_DANGER("[src] sizzles and burns away!"))
	qdel(src)

// ============================================================================
// BOTTLE
// ============================================================================

/obj/item/reagent_containers/glass/bottle/scp610
	name = "corruption sample"
	desc = "A sealed container holding a pulsating mass of corruption."
	icon = 'icons/SCP/scp610/structure.dmi'
	icon_state = "610_sample"

/obj/item/reagent_containers/glass/bottle/scp610/attack_self(mob/user)
	if(alert(user, "Opening this will release corruption and may infect you and those nearby. Continue?", "Corruption Sample", "Yes", "No") != "Yes")
		return
	user.visible_message(
		SPAN_DANGER("[user] uncorks the bottle, releasing a foul stench!"),
		SPAN_DANGER("You open the bottle. The corruption spills out!")
	)
	for(var/mob/living/carbon/human/H in range(2, user))
		H.infect_scp610()
	playsound(get_turf(user), 'sounds/scp/610/610_flesh.ogg', 30, TRUE)
	qdel(src)

/obj/item/reagent_containers/glass/bottle/scp610/afterattack(atom/target, mob/user, proximity_flag)
	if(!proximity_flag)
		return
	if(ishuman(target))
		if(alert(user, "Smash the bottle against [target]? This will infect them and those nearby.", "Corruption Sample", "Yes", "No") != "Yes")
			return
		var/mob/living/carbon/human/H = target
		H.infect_scp610()
		for(var/mob/living/carbon/human/V in range(1, H))
			V.infect_scp610()
		playsound(get_turf(H), 'sounds/scp/610/610_flesh.ogg', 50, TRUE)
		qdel(src)
		return
	if(istype(target, /turf/simulated/floor))
		if(alert(user, "Smash the bottle on the floor? This will spread corruption.", "Corruption Sample", "Yes", "No") != "Yes")
			return
		var/turf/simulated/floor/F = target
		new /obj/structure/corruption/nest(F)
		playsound(get_turf(target), 'sounds/scp/610/610_flesh.ogg', 50, TRUE)
		qdel(src)
		return
	..()

// ============================================================================
// DISEASE
// ============================================================================

/datum/disease/scp610
	name = "Corruption Infection"
	form = "Necrotic Corruption"
	max_stages = 3
	spread_text = "Physical contact, contaminated surfaces"
	spread_flags = DISEASE_SPREAD_BLOOD | DISEASE_SPREAD_CONTACT_SKIN | DISEASE_SPREAD_CONTACT_FLUIDS
	cure_text = "Amputation of affected limb in early stages; incineration of late-stage victims"
	cures = list()
	agent = "corruption mutagen"
	viable_mobtypes = list(/mob/living/carbon/human)
	desc = "A slowly spreading infection. Causes severe scarring and eventual transformation."
	severity = DISEASE_SEVERITY_DANGEROUS
	permeability_mod = 1
	bypasses_immunity = TRUE

/datum/disease/scp610/StageAct()
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = affected_mob
	if(!istype(H))
		return
	// Don't affect SCPs
	if(H.SCP)
		return

	switch(stage)
		if(1)
			if(prob(8))
				to_chat(H, SPAN_WARNING("Your skin feels slightly irritated."))
			if(prob(3))
				H.adjustToxLoss(0.3)
				to_chat(H, SPAN_WARNING("A faint rash appears on your skin."))

		if(2)
			if(prob(10))
				var/part = pick(list("chest", "arms", "legs", "face", "back", "hands"))
				to_chat(H, SPAN_DANGER("Scar-like marks cover your [part]."))
				H.adjustBruteLoss(1)
			if(prob(5))
				H.Weaken(3)
				to_chat(H, SPAN_DANGER("Your muscles twitch painfully."))

		if(3)
			H.visible_message(SPAN_DANGER("<b>[H.name]</b> collapses, body convulsing violently!"))
			H.Stun(12)
			H.adjustBruteLoss(18)
			spawn(300)
				if(H && H.stat != DEAD)
					complete_transformation(H)

/datum/disease/scp610/proc/complete_transformation(mob/living/carbon/human/H)
	var/transform_type = pickweight(list(
		"slasher" = 50,
		"puker" = 30,
		"leaper" = 10,
		"lurker" = 10
	))
	var/mob/living/simple_animal/hostile/new_mob
	switch(transform_type)
		if("slasher")
			H.visible_message(SPAN_DANGER("<b>[H.name] twists into a slasher!</b>"))
			new_mob = new /mob/living/simple_animal/hostile/scp610_slasher(get_turf(H))
		if("leaper")
			H.visible_message(SPAN_DANGER("<b>[H.name] mutates into a leaper!</b>"))
			new_mob = new /mob/living/simple_animal/hostile/scp610_leaper(get_turf(H))
		if("lurker")
			H.visible_message(SPAN_DANGER("<b>[H.name] shrinks into a lurker!</b>"))
			new_mob = new /mob/living/simple_animal/hostile/scp610_lurker(get_turf(H))
		if("puker")
			H.visible_message(SPAN_DANGER("<b>[H.name] bloats into a puker!</b>"))
			new_mob = new /mob/living/simple_animal/hostile/scp610_puker(get_turf(H))
	if(new_mob && H.mind)
		H.mind.transfer_to(new_mob)
	playsound(get_turf(H), 'sounds/scp/610/610_flesh_5.ogg', 60, TRUE)
	qdel(H)

/mob/living/carbon/human/proc/infect_scp610()
	set name = "Infect SCP-610"
	set hidden = TRUE
	for(var/datum/disease/scp610/D in diseases)
		return FALSE
	// Don't infect SCPs
	if(SCP)
		return FALSE
	var/datum/disease/scp610/D = new()
	D.Infect(src, FALSE)
	playsound(get_turf(src), 'sounds/scp/610/610_flesh_4.ogg', 30, TRUE)
	visible_message(SPAN_DANGER("[src] comes into contact with corruption!"))
	to_chat(src, SPAN_WARNING("You feel something foreign against your skin..."))
	return TRUE

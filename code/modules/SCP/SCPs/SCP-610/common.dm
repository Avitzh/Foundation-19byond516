// code/modules/SCP/SCPs/SCP-610/common.dm
// ============================================================================
// SCP-610 - Common (language, turfs, bottle, disease, structures)
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
// CORRUPTION TURFS - heal like weed, node is neutral, maw infects
// ============================================================================

/turf/simulated/floor/flesh
	name = "corruption"
	desc = "A patch of writhing, pulsating corruption."
	icon = 'icons/SCP/scp610/structure.dmi'

/turf/simulated/floor/flesh/Initialize(mapload)
	. = ..()
	icon_state = "corruption-[rand(1,3)]"
	START_PROCESSING(SSobj, src)

/turf/simulated/floor/flesh/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/turf/simulated/floor/flesh/Entered(var/atom/movable/AM)
	..()
	if(istype(AM, /mob/living/simple_animal/hostile/scp610_slasher) || istype(AM, /mob/living/simple_animal/hostile/scp610_leaper) || istype(AM, /mob/living/simple_animal/hostile/scp610_lurker) || istype(AM, /mob/living/simple_animal/hostile/scp610_puker))
		var/mob/living/L = AM
		L.adjustBruteLoss(-3)

/turf/simulated/floor/flesh/Process()
	for(var/mob/living/simple_animal/hostile/scp610_slasher/M in src)
		M.adjustBruteLoss(-1)
	for(var/mob/living/simple_animal/hostile/scp610_leaper/M in src)
		M.adjustBruteLoss(-1)
	for(var/mob/living/simple_animal/hostile/scp610_lurker/M in src)
		M.adjustBruteLoss(-1)
	for(var/mob/living/simple_animal/hostile/scp610_puker/M in src)
		M.adjustBruteLoss(-1)

/turf/simulated/floor/flesh/node
	name = "corruption node"
	icon_state = "corruption-2"

/turf/simulated/floor/flesh/node/Initialize(mapload)
	. = ..()
	icon_state = "corruption-2"

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
		new /turf/simulated/floor/flesh(F)
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

/datum/disease/scp610/proc/complete_transformation(var/mob/living/carbon/human/H)
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
	var/datum/disease/scp610/D = new()
	D.Infect(src, FALSE)
	playsound(get_turf(src), 'sounds/scp/610/610_flesh_4.ogg', 30, TRUE)
	visible_message(SPAN_DANGER("[src] comes into contact with corruption!"))
	to_chat(src, SPAN_WARNING("You feel something foreign against your skin..."))
	return TRUE

// ============================================================================
// STRUCTURES - Nest allows all to pass, Maw infects
// ============================================================================

/obj/structure/corruption_nest
	name = "nest"
	desc = "A thick column of hardened corruption. It pulses with a warm, organic glow."
	icon = 'icons/SCP/scp610/structure.dmi'
	icon_state = "nest"
	density = TRUE
	anchored = TRUE
	var/max_health = 120
	var/health = 120
	var/list/spawned_turfs = list()

/obj/structure/corruption_nest/Initialize(mapload)
	. = ..()
	health = max_health
	START_PROCESSING(SSobj, src)
	var/turf/T = get_turf(src)
	if(istype(T))
		for(var/turf/simulated/floor/F in range(2, T))
			if(!istype(F, /turf/space) && prob(40))
				var/turf/simulated/floor/flesh/new_flesh = new /turf/simulated/floor/flesh(F)
				spawned_turfs += new_flesh

/obj/structure/corruption_nest/Destroy()
	STOP_PROCESSING(SSobj, src)
	for(var/turf/simulated/floor/flesh/F in spawned_turfs)
		if(!QDELETED(F))
			F.ChangeTurf(/turf/simulated/floor)
	spawned_turfs.Cut()
	return ..()

/obj/structure/corruption_nest/Process()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	for(var/turf/simulated/floor/F in range(3, T))
		if(!istype(F, /turf/space) && prob(20))
			var/turf/simulated/floor/flesh/new_flesh = new /turf/simulated/floor/flesh(F)
			spawned_turfs += new_flesh

/obj/structure/corruption_nest/attackby(obj/item/W, mob/user)
	user.setClickCooldown(CLICK_CD_ATTACK)
	visible_message(SPAN_DANGER("[user] strikes [src] with [W]!"))
	var/damage = W.force
	if(W.sharp) damage *= 1.5
	if(W.edge) damage *= 1.2
	health -= damage
	if(health <= 0)
		visible_message(SPAN_DANGER("[src] ruptures and collapses!"))
		playsound(get_turf(src), 'sounds/scp/610/610_flesh_2.ogg', 40, TRUE)
		qdel(src)
	..()

/obj/structure/corruption_nest/CanPass(atom/movable/mover, turf/target)
	return TRUE

/obj/structure/corruption_maw
	name = "maw"
	desc = "A gaping orifice in the floor, lined with teeth of bone and corruption."
	icon = 'icons/SCP/scp610/structure.dmi'
	icon_state = "maw"
	density = FALSE
	anchored = TRUE
	var/trap_cooldown = 10 SECONDS
	var/list/trapped_mobs = list()

/obj/structure/corruption_maw/Initialize(mapload)
	. = ..()
	playsound(get_turf(src), 'sounds/scp/610/610_flesh_4.ogg', 40, TRUE)

/obj/structure/corruption_maw/Crossed(var/atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		if(H in trapped_mobs || H.lying)
			return
		if(istype(H, /mob/living/simple_animal/hostile/scp610_slasher) || istype(H, /mob/living/simple_animal/hostile/scp610_leaper) || istype(H, /mob/living/simple_animal/hostile/scp610_lurker) || istype(H, /mob/living/simple_animal/hostile/scp610_puker))
			return
		if(H.species?.name == "Scarred Creature")
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
		addtimer(CALLBACK(src, /obj/structure/corruption_maw/proc/release_mob, H), trap_cooldown)

/obj/structure/corruption_maw/proc/release_mob(var/mob/living/carbon/human/H)
	if(H && !QDELETED(H))
		trapped_mobs -= H

/obj/structure/corruption_maw/attackby(obj/item/W, mob/user)
	if(W.sharp && W.force >= 10)
		visible_message(SPAN_DANGER("[user] cuts through [src], destroying it!"))
		playsound(get_turf(src), 'sounds/scp/610/610_flesh_2.ogg', 40, TRUE)
		qdel(src)
		return
	..()

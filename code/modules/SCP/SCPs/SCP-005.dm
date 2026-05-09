// ============================================================================
// SCP-005 - Skeleton Key
// ============================================================================

/obj/item/scp005
	name = "an ornate key"
	desc = "An elaborately designed key with an unusual number of teeth. It looks ancient, yet perfectly preserved."
	icon = 'icons/SCP/scp-005.dmi'
	icon_state = "key"
	item_state = "key"
	w_class = ITEM_SIZE_SMALL

	var/use_cooldown = 20 SECONDS
	var/use_cooldown_track = 0

/obj/item/scp005/Initialize(mapload)
	. = ..()
	SCP = new /datum/scp(
		src,
		"ornate key",
		SCP_SAFE,
		"005"
	)

/obj/item/scp005/afterattack(atom/target, mob/user, proximity_flag)
	if(!proximity_flag)
		return

	if(world.time < use_cooldown_track)
		to_chat(user, SPAN_WARNING("[src] is not ready yet. Wait [round((use_cooldown_track - world.time) / 10)] seconds."))
		return

	// Check for SCP-004 door
	if(istype(target, /obj/structure/scp004_door))
		use_cooldown_track = world.time + use_cooldown

		user.visible_message(
			SPAN_DANGER("[user] inserts [src] into [target] and begins turning it..."),
			SPAN_DANGER("You insert [src] into [target]. The lock resists, then something feels wrong...")
		)

		playsound(get_turf(user), 'sounds/effects/wounds/bonebreak1.ogg', 50, TRUE)

		if(!do_after(user, 2 SECONDS, target, bonus_percentage = 50))
			return

		user.visible_message(
			SPAN_DANGER("[user]'s body is torn apart by an unseen force as [src] backfires!"),
			SPAN_DANGER("A horrible ripping sensation tears through you as the key backfires!")
		)
		playsound(get_turf(user), 'sounds/effects/splat.ogg', 60, TRUE)
		user.gib(1, 1, 1)
		return

	// Normal locked objects
	if(!istype(target, /obj/machinery/door) && !istype(target, /obj/structure/closet))
		return

	if(istype(target, /obj/machinery/door))
		var/obj/machinery/door/D = target
		if(!D.density)
			to_chat(user, SPAN_WARNING("[D] is already open."))
			return

	if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/C = target
		if(!C.locked && C.opened)
			to_chat(user, SPAN_WARNING("[C] is already open."))
			return

	use_cooldown_track = world.time + use_cooldown

	user.visible_message(
		SPAN_DANGER("[user] inserts [src] into [target] and begins turning it..."),
		SPAN_DANGER("You insert [src] into [target] and begin turning...")
	)

	playsound(get_turf(user), 'sounds/effects/wounds/bonebreak1.ogg', 50, TRUE)

	if(!do_after(user, 2 SECONDS, target, bonus_percentage = 50))
		return

	if(istype(target, /obj/machinery/door))
		var/obj/machinery/door/D = target
		if(istype(D, /obj/machinery/door/airlock))
			var/obj/machinery/door/airlock/A = D
			A.unlock(TRUE)
		D.open(1)
		user.visible_message(
			SPAN_DANGER("[D] clicks open as [user] turns [src]!"),
			SPAN_DANGER("[D] unlocks and swings open!")
		)

	if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/C = target
		C.locked = FALSE
		C.open()
		user.visible_message(
			SPAN_DANGER("[C] unlocks as [user] turns [src]!"),
			SPAN_DANGER("[C] clicks open!")
		)

/obj/item/scp005/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("The key seems to shimmer slightly, as if eager to unlock something."))

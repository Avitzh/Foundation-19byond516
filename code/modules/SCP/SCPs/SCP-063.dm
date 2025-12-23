/obj/item/scp063
	name = "The World's Best TothBrush"
	desc = "It looks like a regular toothbrush, pale blue. There's writing on the side: <i>\"The World's Best TothBrush.\"</i> "
	icon = 'icons/SCP/scp-063.dmi'
	icon_state = "scp063"

	throw_speed = 7
	throw_range = 15
	w_class = ITEM_SIZE_TINY


/obj/item/scp063/Initialize()
	. = ..()
	SCP = new /datum/scp(
		src, // Ref to actual SCP atom
		"pale blue toothbrush", //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_SAFE, //Obj Class
		"063" //Numerical Designation
	)

/obj/item/scp063/attack(atom/A, mob/user, target_zone)
	if(ismob(A))
		var/mob/M = A
		if(ishuman(A) && user.a_intent == I_HELP && target_zone == BP_MOUTH)
			var/mob/living/carbon/human/H = M
			to_chat(user, SPAN_INFO("You started brushing [H]'s teeth."))
			if(do_after(user, 10 SECONDS, bonus_percentage = 25))
				visible_message("\The [user] brushed \the [H]'s teeth.")
		else
			to_chat(user, SPAN_WARNING("You stab [M] with \the [src]."))
			admin_attack_log(user, M, "Stabbed using \a [src]", "Was stabbed with \a [src]", "used \a [src] to stab")

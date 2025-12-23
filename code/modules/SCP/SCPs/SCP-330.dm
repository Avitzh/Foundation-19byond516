/obj/item/scp330
	name = "a strange candy jar"
	desc = "Jar filled with Halloween candy. The label on the jar reads: <i>\"Take no more than two, please!\"</i>"
	icon = 'icons/SCP/scp-330.dmi'
	icon_state = "scp330"

	throw_speed = 3
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	var/used_list = list()

	var/probably_candy = list(/obj/item/storage/chewables/candy/gum,
						/obj/item/storage/chewables/candy/cookies,
						/obj/item/reagent_containers/food/snacks/candy,
						/obj/item/clothing/mask/chewable/candy/lolli)

/obj/item/scp330/Initialize()
	. = ..()
	SCP = new /datum/scp(
		src, // Ref to actual SCP atom
		"a strange candy jar", //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_SAFE, //Obj Class
		"330" //Numerical Designation
	)

/obj/item/scp330/attack_hand(mob/user as mob)
	if(ishuman(user))
		if(user in used_list)
			used_list[user] += 1
		else
			used_list[user] = 1

		var/mob/living/carbon/human/H = user
		var/candy_path = pick(probably_candy)
		var/atom/A = new candy_path(user.loc)
		H.put_in_hands(A)
		if(used_list[user] > 2)
			Punishment(user)

/obj/item/scp330/proc/Punishment(mob/user as mob)
	var/mob/living/carbon/human/H = user
	to_chat(user, FONT_HUGE(SPAN_DANGER("You feel strange force...")))
	if (H.has_organ("l_hand"))
		H.drop_l_hand()
		var/obj/item/organ/external/L = H.get_organ("l_hand")
		L.droplimb()
	if (H.has_organ("r_hand"))
		H.drop_r_hand()
		var/obj/item/organ/external/L = H.get_organ("r_hand")
		L.droplimb()
	to_chat(user, FONT_HUGE(SPAN_DANGER("Your arms are torn off!!")))
	playsound(H, "bone_break", 45, TRUE)
	H.emote("scream")



/obj/item/scp330/Conversion914(mode = MODE_ONE_TO_ONE, mob/user = usr)
	switch(mode)
		if(MODE_VERY_FINE)
			log_and_message_admins("put [src] through SCP-914 on \"Very Fine\" mode.", user, src)
			visible_message("\The [src] started to glow.")
			return null
	return ..()

// 063 | 098 067 145 458 | 354 682 1025
// 912 145-J

// 330 063

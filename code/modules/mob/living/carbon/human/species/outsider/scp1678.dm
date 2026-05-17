/datum/species/scp1678
	name = "SCP-1678-A"
	name_plural = "SCP-1678-As"

	siemens_coefficient = 0
	total_health = 200

	blood_color = "#1a1a1a"
	flesh_color = "#2a2a2a"

	species_flags = SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_PAIN
	spawn_flags = SPECIES_IS_RESTRICTED

	has_fine_manipulation = TRUE

	hud_type = /datum/hud_data/scp1678

	genders = list(MALE)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/scp1678),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/scp1678),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/scp1678),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/scp1678),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/scp1678),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/scp1678),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/scp1678),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/scp1678),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/scp1678),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/scp1678),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/scp1678)
	)

	icobase = null
	deform = null
	damage_overlays = null
	damage_mask = null
	blood_mask = null

	brute_mod = 1.0
	burn_mod = 1.0
	oxy_mod = 0.0
	toxins_mod = 0.0
	radiation_mod = 0.0
	flash_mod = 0.0

/obj/item/organ/external/chest/scp1678
	max_damage = 100
	min_broken_damage = 65
	arterial_bleed_severity = 0

/obj/item/organ/external/groin/scp1678
	max_damage = 90
	min_broken_damage = 55
	arterial_bleed_severity = 0

/obj/item/organ/external/head/scp1678
	max_damage = 80
	min_broken_damage = 50
	arterial_bleed_severity = 0

/obj/item/organ/external/arm/scp1678
	max_damage = 65
	min_broken_damage = 45
	arterial_bleed_severity = 0

/obj/item/organ/external/arm/right/scp1678
	max_damage = 65
	min_broken_damage = 45
	arterial_bleed_severity = 0

/obj/item/organ/external/leg/scp1678
	max_damage = 65
	min_broken_damage = 45
	arterial_bleed_severity = 0

/obj/item/organ/external/leg/right/scp1678
	max_damage = 65
	min_broken_damage = 45
	arterial_bleed_severity = 0

/obj/item/organ/external/hand/scp1678
	max_damage = 50
	min_broken_damage = 35
	arterial_bleed_severity = 0
	limb_flags = ORGAN_FLAG_CAN_GRASP

/obj/item/organ/external/hand/right/scp1678
	max_damage = 50
	min_broken_damage = 35
	arterial_bleed_severity = 0
	limb_flags = ORGAN_FLAG_CAN_GRASP

/obj/item/organ/external/foot/scp1678
	max_damage = 50
	min_broken_damage = 35
	arterial_bleed_severity = 0
	limb_flags = ORGAN_FLAG_CAN_STAND

/obj/item/organ/external/foot/right/scp1678
	max_damage = 50
	min_broken_damage = 35
	arterial_bleed_severity = 0
	limb_flags = ORGAN_FLAG_CAN_STAND

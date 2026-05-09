/datum/species/scp1678
	name = "SCP-1678-A"
	name_plural = "SCP-1678-As"

	has_organ = list()
	siemens_coefficient = 0
	blood_color = "#2a2a2a"
	flesh_color = "#3a3a3a"

	species_flags = SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_POISON | SPECIES_FLAG_NO_EMBED | SPECIES_FLAG_NO_TANGLE | SPECIES_FLAG_NO_PAIN
	spawn_flags = SPECIES_IS_RESTRICTED

	// Полный иммунитет к падениям и оглушениям
	stun_mod = 0
	weaken_mod = 0
	paralysis_mod = 0

	genders = list(MALE, FEMALE, PLURAL)

	// Отключаем человеческие оверлеи (иконка из DMI моба)
	icobase = null
	deform = null
	damage_overlays = null
	damage_mask = null
	blood_mask = null

	// Устойчивость к урону: 50% физического и огня
	brute_mod = 0.5
	burn_mod = 0.5
	oxy_mod = 0.0
	toxins_mod = 0.0
	radiation_mod = 0.0
	flash_mod = 0.0

	// Небьющиеся органы (как у SCP-106)
	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/unbreakable/scp1678),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/unbreakable/scp1678),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/unbreakable/scp1678),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/unbreakable/scp1678),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/unbreakable/scp1678),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/unbreakable/scp1678),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/unbreakable/scp1678),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/unbreakable/scp1678),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/unbreakable/scp1678),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/unbreakable/scp1678),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/unbreakable/scp1678),
	)

// Небьющиеся органы
/obj/item/organ/external/chest/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = 0
/obj/item/organ/external/groin/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = 0
/obj/item/organ/external/head/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = 0
/obj/item/organ/external/arm/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = 0
/obj/item/organ/external/arm/right/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = 0
/obj/item/organ/external/leg/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = 0
/obj/item/organ/external/leg/right/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = 0
/obj/item/organ/external/foot/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = ORGAN_FLAG_CAN_STAND
/obj/item/organ/external/foot/right/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = 0
/obj/item/organ/external/hand/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = ORGAN_FLAG_CAN_GRASP
/obj/item/organ/external/hand/right/unbreakable/scp1678
	dislocated = -1
	arterial_bleed_severity = 0
	limb_flags = 0

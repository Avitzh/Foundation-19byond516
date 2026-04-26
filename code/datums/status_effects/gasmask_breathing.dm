/datum/status_effect/gasmask_breathing
	id = "gasmask_breathing"
	duration = -1
	tick_interval = 30
	alert_type = null
	var/obj/item/clothing/mask/linked_mask
	var/sound_channel_internal = 1012
	var/sound_channel_external = 1013
	var/is_playing = FALSE

/datum/status_effect/gasmask_breathing/on_creation(mob/living/new_owner, obj/item/clothing/mask/source_mask)
	. = ..()
	if(!.)
		return
	linked_mask = source_mask
	play_breath_sounds()

/datum/status_effect/gasmask_breathing/tick()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		qdel(src)
		return

	if(H.wear_mask != linked_mask)
		qdel(src)
		return

	play_breath_sounds()

/datum/status_effect/gasmask_breathing/proc/play_breath_sounds()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return

	if(is_playing)
		return
	is_playing = TRUE

	// Внутренний звук — слышит только владелец
	var/sound/internal_sound = sound('sounds/effects/gasmask_breath_internal.ogg')
	internal_sound.volume = 20 // УМЕНЬШИЛ ГРОМКОСТЬ
	internal_sound.channel = sound_channel_internal
	internal_sound.wait = 1
	H << internal_sound

	// Внешний звук — слышат все кроме владельца
	var/sound/external_sound = sound('sounds/effects/gasmask_breath_external.ogg')
	external_sound.volume = 30
	external_sound.channel = sound_channel_external
	external_sound.wait = 1
	external_sound.falloff = 3
	external_sound.environment = -1

	for(var/mob/M in hearers(7, H))
		if(M == H)
			continue
		M << external_sound

	addtimer(CALLBACK(src, PROC_REF(reset_playing)), 15 SECONDS)

/datum/status_effect/gasmask_breathing/proc/reset_playing()
	is_playing = FALSE

/datum/status_effect/gasmask_breathing/Destroy()
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		// Останавливаем внутренний канал
		var/sound/stop1 = sound(null)
		stop1.channel = sound_channel_internal
		H << stop1
		// Останавливаем внешний канал для окружающих
		for(var/mob/M in hearers(7, H))
			if(M == H)
				continue
			var/sound/stop_ext = sound(null)
			stop_ext.channel = sound_channel_external
			M << stop_ext
	linked_mask = null
	return ..()

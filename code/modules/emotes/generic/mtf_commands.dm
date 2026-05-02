#ifndef AUDIBLE_MESSAGE
#define AUDIBLE_MESSAGE 1
#endif

#ifndef VISIBLE_MESSAGE
#define VISIBLE_MESSAGE 2
#endif

#ifndef EMOTE_CHECK_CONSCIOUS
#define EMOTE_CHECK_CONSCIOUS 0x1
#endif

// MTF Tactical Voice Commands (specific phrases with sounds)
/datum/emote/mtf
	message_type = AUDIBLE_MESSAGE
	state_checks = EMOTE_CHECK_CONSCIOUS
	cooldown = 15        // 1.5 секунды
	audio_cooldown = 30  // 3 секунды

/datum/emote/mtf/get_sfx_volume()
	return 70

// ---------- Class-D spotted! ----------
/datum/emote/mtf/classd_spotted
	key = "classd_spotted"
	message_1p = "You shout, \"Class-D spotted!\""
	message_3p = "shouts, \"Class-D spotted!\""
	message_impaired_production = "points urgently."
	message_miming = "acts out spotting a Class-D."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/Stop2.ogg'
	statpanel_proc = /mob/proc/mtf_classd_spotted_emote

/mob/proc/mtf_classd_spotted_emote()
	set name = "Class-D Spotted!"
	set category = "MTF Commands"
	emote("classd_spotted", intentional = TRUE)

// ---------- You, stop! ----------
/datum/emote/mtf/you_stop
	key = "you_stop"
	message_1p = "You shout, \"You, stop!\""
	message_3p = "shouts, \"You, stop!\""
	message_impaired_production = "holds up a hand."
	message_miming = "acts out ordering someone to stop."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/Stop6.ogg'
	statpanel_proc = /mob/proc/mtf_you_stop_emote

/mob/proc/mtf_you_stop_emote()
	set name = "You, Stop!"
	set category = "MTF Commands"
	emote("you_stop", intentional = TRUE)

// ---------- Come out you bastard! ----------
/datum/emote/mtf/come_out_bastard
	key = "come_out_bastard"
	message_1p = "You shout, \"Come out you bastard!\""
	message_3p = "shouts, \"Come out you bastard!\""
	message_impaired_production = "gestures aggressively."
	message_miming = "acts out demanding someone to come out."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/Searching1.ogg'
	statpanel_proc = /mob/proc/mtf_come_out_bastard_emote

/mob/proc/mtf_come_out_bastard_emote()
	set name = "Come Out You Bastard!"
	set category = "MTF Commands"
	emote("come_out_bastard", intentional = TRUE)

// ---------- Target terminated. ----------
/datum/emote/mtf/target_terminated
	key = "target_terminated"
	message_1p = "You report, \"Target terminated.\""
	message_3p = "reports, \"Target terminated.\""
	message_impaired_production = "makes a cutting motion across throat."
	message_miming = "acts out a target neutralized."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/Targetterminated1.ogg'
	statpanel_proc = /mob/proc/mtf_target_terminated_emote

/mob/proc/mtf_target_terminated_emote()
	set name = "Target Terminated"
	set category = "MTF Commands"
	emote("target_terminated", intentional = TRUE)

// ---------- Class-D has been terminated. ----------
/datum/emote/mtf/classd_terminated
	key = "classd_terminated"
	message_1p = "You report, \"Class-D has been terminated.\""
	message_3p = "reports, \"Class-D has been terminated.\""
	message_impaired_production = "nods grimly."
	message_miming = "acts out confirming a kill."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/TargetTerminated3.ogg'
	statpanel_proc = /mob/proc/mtf_classd_terminated_emote

/mob/proc/mtf_classd_terminated_emote()
	set name = "Class-D Terminated"
	set category = "MTF Commands"
	emote("classd_terminated", intentional = TRUE)

// ---------- SCP-173 spotted! ----------
/datum/emote/mtf/statue_spotted
	key = "statue_spotted"
	message_1p = "You shout, \"SCP-173 spotted!\""
	message_3p = "shouts, \"SCP-173 spotted!\""
	message_impaired_production = "points ahead with alarm."
	message_miming = "acts out spotting SCP-173."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/173spotted1.ogg'
	statpanel_proc = /mob/proc/mtf_statue_spotted_emote

/mob/proc/mtf_statue_spotted_emote()
	set name = "SCP-173 Spotted!"
	set category = "MTF Commands"
	emote("statue_spotted", intentional = TRUE)

// ---------- Plague Doctor spotted! ----------
/datum/emote/mtf/plague_doctor_spotted
	key = "plague_doctor_spotted"
	message_1p = "You shout, \"Plague Doctor has just been spotted!\""
	message_3p = "shouts, \"Plague Doctor has just been spotted!\""
	message_impaired_production = "gestures urgently toward the doctor."
	message_miming = "acts out spotting SCP-049."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/049Spotted5.ogg'
	statpanel_proc = /mob/proc/mtf_plague_doctor_spotted_emote

/mob/proc/mtf_plague_doctor_spotted_emote()
	set name = "Plague Doctor Spotted!"
	set category = "MTF Commands"
	emote("plague_doctor_spotted", intentional = TRUE)

// ---------- Hey, hey! Halt! ----------
/datum/emote/mtf/hey_halt
	key = "hey_halt"
	message_1p = "You shout, \"Hey, hey! Halt!\""
	message_3p = "shouts, \"Hey, hey! Halt!\""
	message_impaired_production = "waves arms to stop."
	message_miming = "acts out halting someone."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/Stop5.ogg'
	statpanel_proc = /mob/proc/mtf_hey_halt_emote

/mob/proc/mtf_hey_halt_emote()
	set name = "Hey, Halt!"
	set category = "MTF Commands"
	emote("hey_halt", intentional = TRUE)

// ---------- Come on out, you're gonna die anyway. ----------
/datum/emote/mtf/come_out_die
	key = "come_out_die"
	message_1p = "You shout, \"Come on out, you're gonna die anyway.\""
	message_3p = "shouts, \"Come on out, you're gonna die anyway.\""
	message_impaired_production = "taunts with a beckoning motion."
	message_miming = "acts out threatening someone to come out."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/Searching3.ogg'
	statpanel_proc = /mob/proc/mtf_come_out_die_emote

/mob/proc/mtf_come_out_die_emote()
	set name = "Come On Out, You're Gonna Die"
	set category = "MTF Commands"
	emote("come_out_die", intentional = TRUE)

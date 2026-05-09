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

// ---------- Target lost, reverting back to the original objective. ----------
/datum/emote/mtf/target_lost
	key = "target_lost"
	message_1p = "You report, \"Target lost, reverting back to the original objective.\""
	message_3p = "reports, \"Target lost, reverting back to the original objective.\""
	message_impaired_production = "shakes head and taps earpiece."
	message_miming = "acts out losing sight of a target."
	message_muzzled = "makes a frustrated noise!"
	sound = 'sounds/voice/mtf/TargetLost1.ogg'
	statpanel_proc = /mob/proc/mtf_target_lost_emote

/mob/proc/mtf_target_lost_emote()
	set name = "Target Lost"
	set category = "MTF Commands"
	emote("target_lost", intentional = TRUE)

// ---------- Stop right there! ----------
/datum/emote/mtf/stop_right_there
	key = "stop_right_there"
	message_1p = "You shout, \"Stop right there!\""
	message_3p = "shouts, \"Stop right there!\""
	message_impaired_production = "holds out a hand in a 'stop' gesture."
	message_miming = "acts out stopping someone in their tracks."
	message_muzzled = "makes a loud noise!"
	sound = 'sounds/voice/mtf/Stop1.ogg'
	statpanel_proc = /mob/proc/mtf_stop_right_there_emote

/mob/proc/mtf_stop_right_there_emote()
	set name = "Stop Right There!"
	set category = "MTF Commands"
	emote("stop_right_there", intentional = TRUE)

// ---------- Blinking. (SCP-173) ----------
/datum/emote/mtf/blinking
	key = "blinking"
	message_1p = "You announce, \"Blinking.\""
	message_3p = "announces, \"Blinking.\""
	message_impaired_production = "makes a deliberate eye gesture."
	message_miming = "acts out blinking rhythmically."
	message_muzzled = "makes a brief noise!"
	sound = 'sounds/voice/mtf/173blinking.ogg'
	statpanel_proc = /mob/proc/mtf_blinking_emote

/mob/proc/mtf_blinking_emote()
	set name = "Blinking"
	set category = "MTF Commands"
	emote("blinking", intentional = TRUE)

// ---------- SCP-106 has been spotted, running! ----------
/datum/emote/mtf/recontainment_spotted
	key = "recontainment_spotted"
	message_1p = "You yell, \"SCP-106 has been spotted, running!\""
	message_3p = "yells, \"SCP-106 has been spotted, running!\""
	message_impaired_production = "points behind and starts moving quickly."
	message_miming = "acts out spotting an old man and fleeing."
	message_muzzled = "makes a panicked noise!"
	sound = 'sounds/voice/mtf/106spotted1.ogg'
	statpanel_proc = /mob/proc/mtf_recontainment_spotted_emote

/mob/proc/mtf_recontainment_spotted_emote()
	set name = "SCP-106 Spotted, Running!"
	set category = "MTF Commands"
	emote("recontainment_spotted", intentional = TRUE)

// ---------- SCP-096 has been spotted. Starting SCRAMBLE gear. ----------
/datum/emote/mtf/scrambler_activated
	key = "scrambler_activated"
	message_1p = "You alert, \"SCP-096 has been spotted. Starting SCRAMBLE gear.\""
	message_3p = "alerts, \"SCP-096 has been spotted. Starting SCRAMBLE gear.\""
	message_impaired_production = "taps headgear urgently."
	message_miming = "acts out activating headgear."
	message_muzzled = "makes a muffled but urgent noise!"
	sound = 'sounds/voice/mtf/096spotted1.ogg'
	statpanel_proc = /mob/proc/mtf_scrambler_activated_emote

/mob/proc/mtf_scrambler_activated_emote()
	set name = "SCP-096 Spotted, Scramble"
	set category = "MTF Commands"
	emote("scrambler_activated", intentional = TRUE)

var/global/send_emergency_team = 0

// Базовый тип для всех МОГ
/datum/antagonist/mtf
	id = MODE_ERT
	role_text = "Оперативник МОГ"
	role_text_plural = "Оперативники МОГ"
	welcome_text = "Вы — член Мобильной Оперативной Группы. Следуйте за лидером и выполните миссию."
	antag_text = "Вы — <b>анти-</b>антагонист! В рамках правил, \
		постарайтесь спасти комплекс и его сотрудников от продолжающегося кризиса. \
		Постарайтесь, чтобы другие игроки получили <i>удовольствие от игры</i>! Если вы растеряны — всегда пишите в админхелп, \
		а перед радикальными действиями, пожалуйста, попробуйте также связаться с администрацией! \
		Обдумывайте свои действия и поддерживайте погружение в роль! <b>Пожалуйста, помните, что все \
		правила, кроме тех, для которых есть прямые исключения, распространяются и на МОГ.</b>"
	leader_welcome_text = "ВЫ НЕ ДОЛЖНЫ ЭТО ВИДЕТЬ"
	landmark_id = "Response Team"
	id_type = /obj/item/card/id/mtf

	flags = ANTAG_OVERRIDE_JOB | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7
	show_objectives_on_creation = 0
	var/reason = ""

	var/agent_outfit = null
	var/leader_outfit = null

	/// Текст объявления о вызове
	var/ert_announce_text = "Похоже, для объекта %STATION% была запрошена Мобильная Оперативная Группа. Мы подготовим и отправим её как можно скорее."
	/// Звук объявления о вызове
	var/ert_announce_sound = 'sounds/scp/mtf_dispatch.ogg'

	var/leader_indicator = "hud_mtf_leader"

/datum/antagonist/mtf/get_indicator(datum/mind/recipient, datum/mind/other)
	if(!leader_indicator || !other.current || !recipient.current)
		return
	if(other == leader)
		var/image/I = image('icons/mob/hud.dmi', loc = other.current, icon_state = leader_indicator, layer = ABOVE_HUMAN_LAYER)
		if(ishuman(other.current))
			var/mob/living/carbon/human/H = other.current
			I.pixel_x = H.species.antaghud_offset_x
			I.pixel_y = H.species.antaghud_offset_y
		return I
	return null

/datum/antagonist/mtf/update_icons_added(datum/mind/player)
	if(!leader_indicator || !player.current)
		return
	spawn(0)
		if(player == leader)
			for(var/datum/mind/member in current_antagonists)
				if(!member.current || !member.current.client)
					continue
				member.current.client.images |= get_indicator(member, player)
		else if(leader)
			if(player.current.client)
				player.current.client.images |= get_indicator(player, leader)

/datum/antagonist/mtf/update_icons_removed(datum/mind/player)
	if(!leader_indicator || !player.current)
		return
	spawn(0)
		clear_indicators(player)
		if(player.current?.client)
			for(var/datum/mind/antag in current_antagonists)
				if(!antag.current?.client)
					continue
				for(var/image/I in antag.current.client.images)
					if(I.loc == player.current)
						qdel(I)
		if(player == leader)
			for(var/datum/mind/subordinate in current_antagonists)
				if(subordinate == leader || !subordinate.current?.client)
					continue
				for(var/image/I in subordinate.current.client.images)
					if(I.icon_state == leader_indicator && I.loc == player.current)
						qdel(I)

/datum/antagonist/mtf/create_default(mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/mtf/New()
	..()
	if(leader_welcome_text == initial(leader_welcome_text))
		leader_welcome_text = "Как лидер [role_text], вы подчиняетесь исключительно Совету О5 и имеете право отменять приказы персонала Комплекса, если это необходимо для выполнения целей миссии. Однако рекомендуется по возможности сотрудничать с персоналом Комплекса."

/datum/antagonist/mtf/greet(datum/mind/player)
	if(!..())
		return
	to_chat(player.current, "Мобильная Оперативная Группа подчиняется Совету О5; ваша задача — содержать SCP-объекты и устранять нарушителей. На объекте [station_name()] объявлен код «Красный», вам поручено отправиться и устранить проблему.")
	to_chat(player.current, "Сначала экипируйтесь и обсудите план с командой. Возможно, прибудут дополнительные бойцы — не выступайте, пока не будете готовы.")

/datum/antagonist/mtf/equip(mob/living/carbon/human/player)
	player.add_language(LANGUAGE_ENGLISH)

	var/outfit_to_use = agent_outfit
	if(leader && player.mind == leader && leader_outfit)
		outfit_to_use = leader_outfit

	if(outfit_to_use)
		dressup_human(player, outfits_decls_by_type_[outfit_to_use], TRUE)
	else
		dressup_human(player, outfits_decls_by_type_[/decl/hierarchy/outfit/mtf/epsilon_11/agent], TRUE)

	// Добавляем тактические голосовые команды
	add_verb(player, /mob/proc/mtf_classd_spotted_emote)
	add_verb(player, /mob/proc/mtf_you_stop_emote)
	add_verb(player, /mob/proc/mtf_come_out_bastard_emote)
	add_verb(player, /mob/proc/mtf_target_terminated_emote)
	add_verb(player, /mob/proc/mtf_classd_terminated_emote)
	add_verb(player, /mob/proc/mtf_statue_spotted_emote)
	add_verb(player, /mob/proc/mtf_plague_doctor_spotted_emote)
	add_verb(player, /mob/proc/mtf_hey_halt_emote)
	add_verb(player, /mob/proc/mtf_come_out_die_emote)

	// Регистрируем эмоуты в системе, чтобы работали через *ключ
	for(var/emote_type in typesof(/datum/emote/mtf))
		if(emote_type == /datum/emote/mtf)
			continue
		var/datum/emote/E = GLOB.all_emotes[emote_type]
		if(E)
			player.set_emote(E.key, E)

	// Регистрируем сигнал речи для звука рации
	RegisterSignal(player, COMSIG_LIVING_TREAT_MESSAGE, PROC_REF(play_mtf_radio_beep))

	return 1

/datum/antagonist/mtf/proc/play_mtf_radio_beep(mob/living/speaker, list/message_args)
	// Проверяем, что на персонаже надета гарнитура ERT (в левом или правом ухе)
	var/mob/living/carbon/human/H = speaker
	if(!istype(H))
		return
	if(istype(H.l_ear, /obj/item/device/radio/headset/ert) || istype(H.r_ear, /obj/item/device/radio/headset/ert))
		playsound(speaker, 'sounds/effects/BeepMTF.ogg', 25, 0, falloff = 3, frequency = rand(80, 120) / 100)

/datum/antagonist/mtf/remove_antagonist(datum/mind/player, show_message, implanted)
	. = ..()
	if(. && player.current)
		UnregisterSignal(player.current, COMSIG_LIVING_TREAT_MESSAGE)

// ------------------------------------------------------------------
// Конкретные отряды
// ------------------------------------------------------------------

GLOBAL_DATUM_INIT(mtf_epsilon_11, /datum/antagonist/mtf/epsilon_11, new)
/datum/antagonist/mtf/epsilon_11
	role_text = "МОГ Девятихвостая Лиса — Агент Эпсилон-11"
	role_text_plural = "МОГ Девятихвостая Лиса — Агенты Эпсилон-11"
	welcome_text = "Вы — агент МОГ Эпсилон-11 «Девятихвостая лиса». Под надзором МОГ Альфа-1 ваша группа обеспечивает внутреннюю безопасность Фонда. Вы — особое подразделение, направляемое в Зоны, когда множественное нарушение условий содержания становится неизбежным."
	leader_welcome_text = "Вы — командир МОГ Эпсилон-11 «Девятихвостая лиса». Вы возглавляете отряд внутренней безопасности, последний рубеж при нарушениях содержания. Координируйте агентов, восстанавливайте контроль, докладывайте Альфа-1."
	agent_outfit = /decl/hierarchy/outfit/mtf/epsilon_11/agent
	leader_outfit = /decl/hierarchy/outfit/mtf/epsilon_11/leader

	/// Доступные классы для обычных агентов (не лидера)
	var/list/class_outfits = list(
		"Агент"    = /decl/hierarchy/outfit/mtf/epsilon_11/agent,
		"Штурмовик" = /decl/hierarchy/outfit/mtf/epsilon_11/breacher,
		"Медик"    = /decl/hierarchy/outfit/mtf/epsilon_11/medic,
		"Стрелок" = /decl/hierarchy/outfit/mtf/epsilon_11/pointman
	)

/datum/antagonist/mtf/epsilon_11/equip(mob/living/carbon/human/player)
	player.add_language(LANGUAGE_ENGLISH)

	var/outfit_to_use
	if(leader && player.mind == leader && leader_outfit)
		// Лидер – сразу выдаём его уникальный аутфит
		outfit_to_use = leader_outfit
	else
		// Предлагаем обычному агенту выбрать класс
		var/chosen_class = tgui_input_list(player, "Выберите специализацию:", "Выбор класса МОГ", class_outfits)
		if(chosen_class)
			outfit_to_use = class_outfits[chosen_class]
		else
			// Если игрок закрыл окно или не выбрал – даём стандартного агента
			outfit_to_use = agent_outfit

	// Применяем выбранный или запасной аутфит
	if(outfit_to_use)
		dressup_human(player, outfits_decls_by_type_[outfit_to_use], TRUE)
	else
		dressup_human(player, outfits_decls_by_type_[/decl/hierarchy/outfit/mtf/epsilon_11/agent], TRUE)

	// Тактические голосовые команды (общие для всех МОГ)
	add_verb(player, /mob/proc/mtf_classd_spotted_emote)
	add_verb(player, /mob/proc/mtf_you_stop_emote)
	add_verb(player, /mob/proc/mtf_come_out_bastard_emote)
	add_verb(player, /mob/proc/mtf_target_terminated_emote)
	add_verb(player, /mob/proc/mtf_classd_terminated_emote)
	add_verb(player, /mob/proc/mtf_statue_spotted_emote)
	add_verb(player, /mob/proc/mtf_plague_doctor_spotted_emote)
	add_verb(player, /mob/proc/mtf_hey_halt_emote)
	add_verb(player, /mob/proc/mtf_come_out_die_emote)
	add_verb(player, /mob/proc/mtf_target_lost_emote)
	add_verb(player, /mob/proc/mtf_stop_right_there_emote)
	add_verb(player, /mob/proc/mtf_blinking_emote)
	add_verb(player, /mob/proc/mtf_recontainment_spotted_emote)
	add_verb(player, /mob/proc/mtf_scrambler_activated_emote)

	// Регистрируем эмоуты в системе для использования через *
	for(var/emote_type in typesof(/datum/emote/mtf))
		if(emote_type == /datum/emote/mtf)
			continue
		var/datum/emote/E = GLOB.all_emotes[emote_type]
		if(E)
			player.set_emote(E.key, E)

	// Звук рации при разговоре
	RegisterSignal(player, COMSIG_LIVING_TREAT_MESSAGE, PROC_REF(play_mtf_radio_beep))

	return 1

GLOBAL_DATUM_INIT(mtf_nu_7, /datum/antagonist/mtf/nu_7, new)
/datum/antagonist/mtf/nu_7
	role_text = "Оперативник МОГ Ню-7"
	role_text_plural = "Оперативники МОГ Ню-7"
	welcome_text = "Вы — оперативник ММОГ Ню-7 «Удар молота». Ваша группа — милитаризованный батальон быстрого реагирования на катастрофические инциденты: потеря связи с учреждением, масштабное нарушение ОУС, вторжение противника. Вы — тяжёлая артиллерия Фонда."
	leader_welcome_text = "Вы — командир ММОГ Ню-7 «Удар молота». В вашем распоряжении батальон тяжёлой пехоты, техника и авиация. Примите командование объектом и подавите любую угрозу силой."
	agent_outfit = /decl/hierarchy/outfit/mtf/nu_7
	ert_announce_text = "Внимание. Военизированная Мобильная Оперативная Группа Ню-7 «Удар молота» выдвигается. Мобилизованы силы полного батальона. Всему не-охранному персоналу предписано эвакуироваться в назначенные убежища или следовать за сопровождением охраны. Не вступайте в бой с враждебными силами. Ню-7 принимает командование объектом."
	ert_announce_sound = 'sounds/MTF_Alert/NU-7_MTF.ogg'

GLOBAL_DATUM_INIT(mtf_beta_7, /datum/antagonist/mtf/beta_7, new)
/datum/antagonist/mtf/beta_7
	role_text = "Оперативник МОГ Бета-7"
	role_text_plural = "Оперативники МОГ Бета-7"
	welcome_text = "Вы — оперативник МОГ Бета-7 «Шляпные болванчики». Ваша специализация — захват и содержание аномалий, представляющих высокую биологическую, химическую или радиационную опасность. Вы обучены быстрой локализации и очистке заражённых территорий, а также противодействию аномальным патогенам."
	leader_welcome_text = "Вы — командир МОГ Бета-7 «Шляпные болванчики». Под вашим руководством специалисты по ХБРЯ-угрозам проведут зачистку и локализацию. От ваших приказов зависит, сколь быстро будет остановлено распространение аномальной заразы."
	agent_outfit = /decl/hierarchy/outfit/mtf/beta_7
	ert_announce_text = "Внимание. Мобильная Оперативная Группа Бета-7 «Шляпные болванчики» развёрнута. Это подразделение специализируется на биологических, химических и радиологических угрозах. Всему персоналу избегать контакта с источниками заражения и ожидать протоколов карантина и обеззараживания. Немедленно следуйте указаниям Бета-7."
	ert_announce_sound = 'sounds/MTF_Alert/Beta_MTF.ogg'

GLOBAL_DATUM_INIT(mtf_eta_10, /datum/antagonist/mtf/eta_10, new)
/datum/antagonist/mtf/eta_10
	role_text = "Оперативник МОГ Эта-10"
	role_text_plural = "Оперативники МОГ Эта-10"
	welcome_text = "Вы — оперативник МОГ Эта-10 «Не вижу зла». Ваша группа специализируется на обнаружении, захвате и содержании объектов, представляющих опасность визуального восприятия, меметических агентов визуального действия и прочих случаев, где для безопасного взаимодействия требуется непрямое или альтернативное наблюдение."
	leader_welcome_text = "Вы — командир МОГ Эта-10 «Не вижу зла». Вы отвечаете за проведение операций против визуальных когнитоугроз. Убедитесь, что ваши люди смотрят правильно — или не смотрят вовсе."
	agent_outfit = /decl/hierarchy/outfit/mtf/eta_10
	ert_announce_text = "Внимание. Мобильная Оперативная Группа Эта-10 «Не вижу зла» вызвана. Это подразделение занимается визуальными когнитоугрозами и меметическими угрозами. Персоналу напоминают избегать прямого визуального контакта с неизвестными субъектами. Закройте глаза, если будет дана такая команда. Без колебаний следуйте указаниям оперативников Эта-10."
	ert_announce_sound = 'sounds/MTF_Alert/Eta-10_MTF.ogg'

GLOBAL_DATUM_INIT(mtf_alpha_1, /datum/antagonist/mtf/alpha_1, new)
/datum/antagonist/mtf/alpha_1
	role_text = "Оперативник МОГ Альфа-1"
	role_text_plural = "Оперативники МОГ Альфа-1"
	welcome_text = "Вы — оперативник МОГ Альфа-1 «Багряная десница». Вы подчиняетесь непосредственно Совету О5 и задействуетесь в ситуациях, требующих строжайшей оперативной секретности. Ваша группа состоит из лучших и наиболее преданных оперативников Фонда."
	leader_welcome_text = "Вы — командир МОГ Альфа-1 «Багряная десница». Вы возглавляете элитнейших агентов Фонда в операциях высшей секретности. Ваше слово — закон, ваше решение — окончательное. Совет О5 доверяет вам безоговорочно."
	agent_outfit = /decl/hierarchy/outfit/mtf/alpha_1
	ert_announce_text = "Внимание. Код «Чёрный надзор». Мобильная Оперативная Группа Альфа-1 активирована. Всему персоналу предписано прекратить деятельность и ожидать прямых приказов от оперативников Альфа-1. Не препятствовать, не задавать вопросы, не приближаться к ним. Дальнейшие инструкции будут предоставлены по мере необходимости."
	ert_announce_sound = 'sounds/MTF_Alert/Alpha-1_MTF.ogg'

GLOBAL_DATUM_INIT(mtf_omega_1, /datum/antagonist/mtf/omega_1, new)
/datum/antagonist/mtf/omega_1
	role_text = "Исполнитель МОГ Омега-1"
	role_text_plural = "Исполнители МОГ Омега-1"
	welcome_text = "Вы — исполнитель МОГ Омега-1 «Шуйца Закона». Вы наделены полномочиями снимать с должности или устранять высокопоставленных сотрудников Фонда, действующих неэтично. Вы подчиняетесь напрямую Комитету по Этике."
	leader_welcome_text = "Вы — старший исполнитель МОГ Омега-1 «Шуйца Закона». Вы наделены полномочиями от Комитета по Этике устранять неэтичных сотрудников. Ваше решение — приговор. Беспрекословное подчинение этике."
	agent_outfit = /decl/hierarchy/outfit/mtf/omega1
	ert_announce_text = "Внимание. Мобильная Оперативная Группа Омега-1 «Шуйца Закона» присутствует на объекте. По приказу Этического Комитета, оперативники Омега-1 имеют все полномочия задерживать или отстранять любой персонал, нарушающий этические нормы поведения. Полностью сотрудничайте. Это не учебная тревога."
	ert_announce_sound = 'sounds/MTF_Alert/Omega_MTF.ogg'

GLOBAL_DATUM_INIT(mtf_epsilon_9, /datum/antagonist/mtf/epsilon_9, new)
/datum/antagonist/mtf/epsilon_9
	role_text = "Оперативник МОГ Эпсилон-9"
	role_text_plural = "Оперативники МОГ Эпсилон-9"
	welcome_text = "Вы — оперативник МОГ Эпсилон-9 «Пожиратели огня». Ваша специализация — использование зажигательного вооружения и проведение операций в высокотемпературных средах. Пламя — ваш главный инструмент."
	leader_welcome_text = "Вы — командир МОГ Эпсилон-9 «Пожиратели огня». Вы ведёте в бой мастеров зажигательного оружия. Укажите, что должно гореть, а что остаться нетронутым — и ваши люди это исполнят."
	agent_outfit = /decl/hierarchy/outfit/mtf/epsilon_9
	ert_announce_text = "Внимание. Мобильная Оперативная Группа Эпсилон-9 «Пожиратели огня» приступила к работе на объекте. Проводится специализированная реакция с применением зажигательных средств. Персонал в затронутых зонах должен немедленно эвакуироваться, если не приказано иное. Держитесь подальше от обозначенных огневых зон."
	ert_announce_sound = 'sounds/MTF_Alert/Epsilon-9_MTF.ogg'

GLOBAL_DATUM_INIT(mtf_isd, /datum/antagonist/mtf/isd, new)
/datum/antagonist/mtf/isd
	role_text = "Оперативник Отдела Внутренней Безопасности"
	role_text_plural = "Оперативники ОВБ"
	welcome_text = "Вы — оперативник Отдела Внутренней Безопасности. Ваша задача — поддержание порядка, расследование нарушений и защита персонала от внутренних угроз."
	leader_welcome_text = "Вы — глава Отдела Внутренней Безопасности. Вы координируете действия оперативников ОВБ по поддержанию порядка и расследованию инцидентов."
	agent_outfit = /decl/hierarchy/outfit/mtf/isd

GLOBAL_DATUM_INIT(mtf_o5rep, /datum/antagonist/mtf/o5rep, new)
/datum/antagonist/mtf/o5rep
	role_text = "Представитель О5"
	role_text_plural = "Представители О5"
	welcome_text = "Вы — Представитель Совета О5. Вы обладаете верховной властью на объекте и уполномочены принимать любые решения для обеспечения интересов Фонда."
	leader_welcome_text = "Как единственный представитель О5, вся ответственность лежит на вас. Ваше слово — закон. Используйте свои полномочия, чтобы добиться успеха миссии."
	agent_outfit = /decl/hierarchy/outfit/mtf/o5rep
	flags = ANTAG_OVERRIDE_JOB | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	hard_cap = 1
	hard_cap_round = 1
	initial_spawn_req = 1
	initial_spawn_target = 1

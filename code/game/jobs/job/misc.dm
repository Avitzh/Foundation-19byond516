/datum/job/classd
	title = "Класс D"
	department = "Гражданский"
	selection_color = "#E55700"
	economic_power = 1
	total_positions = 999
	spawn_positions = 999
	supervisors = "весь персонал Фонда"
	access = list()
	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/civ/classd
	class = CLASS_D
	hud_icon = "huddclass"
	var/static/list/used_numbers = list()

	max_skill = list(
		SKILL_COMBAT = SKILL_TRAINED,
		SKILL_WEAPONS = SKILL_TRAINED
	)

	roleplay_difficulty = "Переменная"
	mechanical_difficulty = "Переменная"
	duties = "Вы заключённый. У вас нет обязанностей!"

/datum/job/classd/equip(mob/living/carbon/human/H)
	H.fully_replace_character_name(random_name(H.gender, H.species.name))
	. = ..()
	var/r = rand(100,9000)
	while (used_numbers.Find(r))
		r = rand(100,9000)
	used_numbers += r
	if(istype(H.wear_id, /obj/item/card/id))
		var/obj/item/card/id/ID = H.wear_id
		ID.registered_name = "D-[used_numbers[used_numbers.len]]"

// LOGISTICS DEPARTMENT
/datum/job/qm
	title = "Офицер Логистики"
	department = "Логистика"
	department_flag = SUP|BUR
	total_positions = 1
	spawn_positions = 1
	supervisors = "Директор Зоны"
	selection_color = "#c4a071"
	economic_power = 5
	minimal_player_age = 7
	ideal_character_age = 35
	requirements = list("Специалист по логистике" = 300)
	outfit_type = /decl/hierarchy/outfit/job/command/logisticsofficer
	hud_icon = "huddeckchief"
	class = CLASS_B

	access = list(
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_LOG_COMMS,
		ACCESS_MAINT_TUNNELS,
		ACCESS_EMERGENCY_STORAGE,
		ACCESS_CARGO,
		ACCESS_CARGO_BOT,
		ACCESS_MAILSORTING
	)
	minimal_access = list()


	min_skill = list(
		SKILL_FINANCE     = SKILL_BASIC,
		SKILL_HAULING     = SKILL_BASIC
	)

	max_skill = list()
	skill_points = 18

	software_on_spawn = list(/datum/computer_file/program/supply,
							/datum/computer_file/program/reports)

	roleplay_difficulty = "Средняя"
	mechanical_difficulty = "Средняя"
	duties = "Управляйте отделом логистики. Обеспечивайте снабжение всей Зоны. Закупайте припасы."

/datum/job/cargo_tech
	title = "Специалист по логистике"
	department = "Логистика"
	department_flag = SUP|BUR
	total_positions = 2
	spawn_positions = 2
	selection_color = "#927248"
	supervisors = "Офицер Логистики"
	minimal_player_age = 3
	ideal_character_age = 24
	outfit_type = /decl/hierarchy/outfit/job/command/logisticspecialist
	class = CLASS_C
	hud_icon = "huddecktechnician"

	access = list(
		ACCESS_LOG_COMMS,
		ACCESS_MAINT_TUNNELS,
		ACCESS_EMERGENCY_STORAGE,
		ACCESS_CARGO,
		ACCESS_CARGO_BOT,
		ACCESS_ADMIN_LVL1,
		ACCESS_MAILSORTING
	)
	minimal_access = list()


	min_skill = list(
		SKILL_FINANCE     = SKILL_BASIC,
		SKILL_HAULING     = SKILL_BASIC
	)

	max_skill = list()
	skill_points = 18

	software_on_spawn = list(/datum/computer_file/program/supply,
							/datum/computer_file/program/reports)

	roleplay_difficulty = "Лёгкая - Средняя"
	mechanical_difficulty = "Средняя"
	duties = "Обеспечивайте снабжение всей Зоны. Закупайте припасы."

//Office Worker

/datum/job/officeworker
	title = "Офисный работник"
	department = "Гражданский"
	department_flag = CIV|BUR
	total_positions = 100
	spawn_positions = 100
	minimal_player_age = 10
	economic_power = 2
	minimal_player_age = 5
	ideal_character_age = 30
	alt_titles = list("Административный помощник", "Бухгалтер", "Аудитор", "Секретарь")
	outfit_type = /decl/hierarchy/outfit/job/civ/officeworker
	class = CLASS_C
	hud_icon = "hudcrewman"

	access = list(
		ACCESS_CIV_COMMS,
		ACCESS_ADMIN_LVL1,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
	)

	minimal_access = list()

	roleplay_difficulty = "Средняя"
	mechanical_difficulty = "Лёгкая - Средняя"
	duties = "Работайте с различными отделами и на них. Заполняйте формуляры. Доводите бюрократию до совершенства."
	codex_guides = list("<l>Бумажная работа</l>")

// MISC JOBS

/datum/job/janitor
	title = "Уборщик"
	department = "Гражданский"
	department_flag = CIV|SRV
	selection_color = "#515151"
	total_positions = 3
	spawn_positions = 3
	supervisors = "Менеджер Зоны"
	ideal_character_age = 16
	alt_titles = list("Смотритель помещений")
	outfit_type = /decl/hierarchy/outfit/job/civ/janitor
	class = CLASS_C
	hud_icon = "hudsanitationtechnician"

	access = list(
		ACCESS_CIV_COMMS,
		ACCESS_SCIENCE_LVL1,
		ACCESS_MEDICAL_LVL1,
		ACCESS_DCLASS_JANITORIAL,
		ACCESS_DCLASS_MEDICAL
)
	minimal_access = list()

	min_skill = list(
		SKILL_HAULING = SKILL_BASIC
	)

	roleplay_difficulty = "Лёгкая"
	mechanical_difficulty = "Лёгкая - Средняя"
	duties = "Поддерживайте чистоту на Зоне любой ценой."

/datum/job/chef
	title = "Шеф-повар"
	department = "Гражданский"
	department_flag = CIV|SRV
	selection_color = "#515151"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Менеджер Зоны"
	ideal_character_age = 18
	alt_titles = list("Повар")
	outfit_type = /decl/hierarchy/outfit/job/civ/chef
	class = CLASS_C
	hud_icon = "hudcook"

	access = list(
		ACCESS_CIV_COMMS,
		ACCESS_DCLASS_KITCHEN,
		ACCESS_DCLASS_BOTANY,
		ACCESS_BAR,
		ACCESS_KITCHEN,
		ACCESS_HYDROPONICS
	) // Limited internal D-Block access e.g. when training D-Class or unlocking their crates
	minimal_access = list()

	min_skill = list(
		SKILL_COOKING   = SKILL_EXPERIENCED,
		SKILL_CHEMISTRY = SKILL_BASIC
	)

	roleplay_difficulty = "Лёгкая - Средняя"
	mechanical_difficulty = "Средняя"
	duties = "Готовьте вкусные блюда (или несъедобную бурду). Управляйте кухней."


/datum/job/bartender
	title = "Бармен"
	department = "Гражданский"
	department_flag = CIV|SRV
	selection_color = "#515151"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Менеджер Зоны"
	ideal_character_age = 21
	alt_titles = list("Официант")
	outfit_type = /decl/hierarchy/outfit/job/civ/bartender
	class = CLASS_C
	hud_icon = "hudbartender"

	access = list(
		ACCESS_CIV_COMMS,
		ACCESS_DCLASS_KITCHEN,
		ACCESS_DCLASS_BOTANY,
		ACCESS_BAR,
		ACCESS_KITCHEN,
		ACCESS_HYDROPONICS
	) // Limited internal D-Block access e.g. when training D-Class or unlocking their crates
	minimal_access = list()

	min_skill = list(
		SKILL_COOKING   = SKILL_EXPERIENCED,
		SKILL_CHEMISTRY = SKILL_BASIC
	)

	roleplay_difficulty = "Лёгкая - Средняя"
	mechanical_difficulty = "Средняя"
	duties = "Смешивайте напитки для персонала. Управляйте баром."

/datum/job/chaplain
	title = "Священник"
	department = "Гражданский"
	department_flag = CIV|SRV

	total_positions = 1
	spawn_positions = 1
	supervisors = null

	access = list(
	ACCESS_MEDICAL_LVL1,
	ACCESS_CHAPEL_OFFICE
	)

	minimal_access = list()
	outfit_type = /decl/hierarchy/outfit/job/chaplain
	class = CLASS_C

	roleplay_difficulty = "Средняя"
	mechanical_difficulty = "Лёгкая"

/datum/job/chaplain/equip(mob/living/carbon/human/H, alt_title, ask_questions = TRUE)
	. = ..()
	if(!. || !ask_questions)
		return

	var/obj/item/storage/bible/B = locate(/obj/item/storage/bible) in H
	if(!B)
		return

	spawn(0)
		var/religion_name = "Христианство"
		var/new_religion = sanitize(input(H, "Вы — сотрудник службы досуга персонала. Хотите изменить свою религию? По умолчанию выбрано христианство.", "Смена имени", religion_name), MAX_NAME_LEN)

		if (!new_religion)
			new_religion = religion_name
		switch(lowertext(new_religion))
			if("христианство")
				B.SetName("Святая Библия")
			if("сатанизм")
				B.SetName("Нечестивая Библия")
			if("ктулху")
				B.SetName("Некрономикон")
			if("ислам")
				B.SetName("Коран")
			if("саентология")
				B.SetName(pick("Биография Л. Рона Хаббарда","Дианетика"))
			if("хаос")
				B.SetName("Книга Лоргара")
			if("империум")
				B.SetName("Боевой Устав")
			if("тулбоксия")
				B.SetName("Манифест Тулбокса")
			if("гомосексуализм")
				B.SetName("Парни пошли вразнос")
			if("наука")
				B.SetName(pick("Принцип относительности", "Квантовая загадка: физика встречает сознание", "Программируя Вселенную", "Квантовая физика и теология", "Теория струн для чайников", "Как построить собственный варп-двигатель", "Тайны блюспейса", "Игра в Бога: коллекционное издание"))
			else
				B.SetName("Святая книга [new_religion]")
		SSstatistics.set_field_details("religion_name","[new_religion]")

	spawn(1)
		var/deity_name = "Космический Иисус"
		var/new_deity = sanitize(input(H, "Хотите изменить божество? По умолчанию — Космический Иисус.", "Смена имени", deity_name), MAX_NAME_LEN)

		if ((length(new_deity) == 0) || (new_deity == "Космический Иисус") )
			new_deity = deity_name
		B.deity_name = new_deity

		var/accepted = 0
		var/outoftime = 0
		spawn(200) // 20 секунд на выбор
			outoftime = 1
		var/new_book_style = "Библия"

		while(!accepted)
			if(!B) break // предотвращает возможные ошибки времени выполнения
			new_book_style = input(H,"Какой стиль библии вы бы хотели?") in list("Библия", "Коран", "Альбом", "Крипер", "Белая Библия", "Святой Свет", "Атеист", "Том", "Король в Жёлтом", "Итаква", "Саентология", "Библия плавится", "Некрономикон")
			switch(new_book_style)
				if("Коран")
					B.icon_state = "koran"
					B.item_state = "koran"
				if("Альбом")
					B.icon_state = "scrapbook"
					B.item_state = "scrapbook"
				if("Крипер")
					B.icon_state = "creeper"
					B.item_state = "syringe_kit"
				if("Белая Библия")
					B.icon_state = "white"
					B.item_state = "syringe_kit"
				if("Святой Свет")
					B.icon_state = "holylight"
					B.item_state = "syringe_kit"
				if("Атеист")
					B.icon_state = "athiest"
					B.item_state = "syringe_kit"
				if("Том")
					B.icon_state = "tome"
					B.item_state = "syringe_kit"
				if("Король в Жёлтом")
					B.icon_state = "kingyellow"
					B.item_state = "kingyellow"
				if("Итаква")
					B.icon_state = "ithaqua"
					B.item_state = "ithaqua"
				if("Саентология")
					B.icon_state = "scientology"
					B.item_state = "scientology"
				if("Библия плавится")
					B.icon_state = "melted"
					B.item_state = "melted"
				if("Некрономикон")
					B.icon_state = "necronomicon"
					B.item_state = "necronomicon"
				else
					B.icon_state = "bible"
					B.item_state = "bible"

			H.update_inv_l_hand() // чтобы обновить item_state библии в руке

			switch(input(H,"Посмотрите на свою библию — это то, что вы хотите?") in list("Да","Нет"))
				if("Да")
					accepted = 1
				if("Нет")
					if(outoftime)
						to_chat(H, "Ну всё, время вышло, дружище. Придётся довольствоваться тем, что есть. В следующий раз выбирай быстрее.")
						accepted = 1

		SSstatistics.set_field_details("religion_deity","[new_deity]")
		SSstatistics.set_field_details("religion_book","[new_book_style]")
	return 1

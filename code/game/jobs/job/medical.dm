/datum/job/cmo
	title = "Директор Медицинского Отдела"
	supervisors = "Директор Зоны"
	economic_power = 10
	req_admin_notify = 1
	minimal_player_age = 15
	ideal_character_age = 48
	outfit_type = /decl/hierarchy/outfit/job/command/cmo
	class = CLASS_A
	hud_icon = "hudchiefmedicalofficer"
	department = "Медицинский отдел"
	department_flag = MED|COM
	selection_color = "#026865"
	requirements = list(EXP_TYPE_MEDICAL = 720)

	head_position = TRUE
	total_positions = 1
	spawn_positions = 1

	access = list(
		ACCESS_COM_COMMS,
		ACCESS_MED_COMMS,
		ACCESS_MEDICAL_EQUIP,
		ACCESS_KEYAUTH,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_MEDICAL_LVL3,
		ACCESS_MEDICAL_LVL4,
		ACCESS_MEDICAL_LVL5,
		ACCESS_SECURITY_LVL1,
		ACCESS_SECURITY_LVL2,
		ACCESS_SECURITY_LVL3,
		ACCESS_SCIENCE_LVL1,
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_DCLASS_MEDICAL
	)
	minimal_access = list()

	min_skill = list(
	    SKILL_MEDICAL     = SKILL_EXPERIENCED,
		SKILL_ANATOMY     = SKILL_EXPERIENCED,
	    SKILL_CHEMISTRY   = SKILL_BASIC,
		SKILL_DEVICES     = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_MEDICAL     = SKILL_MASTER,
	    SKILL_ANATOMY     = SKILL_MASTER,
	    SKILL_CHEMISTRY   = SKILL_MASTER
	)
	skill_points = 28
	roleplay_difficulty = "Средняя - Тяжёлая"
	mechanical_difficulty = "Средняя - Тяжёлая"
	duties = "Управляйте Медицинским отделом. Делегируйте лечение и операции. Организуйте реагирование на чрезвычайные ситуации."

/*/datum/job/acmo
	title = "Помощник Директора Медицинского Отдела"
	supervisors = "Директор Зоны и Директор Медицинского Отдела"
	economic_power = 10
	req_admin_notify = 1
	minimal_player_age = 15
	ideal_character_age = 44
	outfit_type = /decl/hierarchy/outfit/job/command/acmo
	class = CLASS_A
	hud_icon = "hudassistantmedicalofficer"
	department = "Медицинский отдел"
	department_flag = MED|COM
	selection_color = "#026865"
	requirements = list(EXP_TYPE_MEDICAL = 560)

	total_positions = 1
	spawn_positions = 1

	access = list(
		ACCESS_COM_COMMS,
		ACCESS_MED_COMMS,
		ACCESS_MEDICAL_EQUIP,
		ACCESS_KEYAUTH,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_MEDICAL_LVL3,
		ACCESS_MEDICAL_LVL4,
		ACCESS_SECURITY_LVL1,
		ACCESS_SCIENCE_LVL1,
		ACCESS_ADMIN_LVL1,
		ACCESS_ADMIN_LVL2,
		ACCESS_ADMIN_LVL3,
		ACCESS_ENGINEERING_LVL1
	)
	minimal_access = list()

	min_skill = list(
	    SKILL_MEDICAL     = SKILL_EXPERIENCED,
		SKILL_ANATOMY     = SKILL_TRAINED,
	    SKILL_CHEMISTRY   = SKILL_BASIC,
		SKILL_DEVICES     = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_MEDICAL     = SKILL_MASTER,
	    SKILL_ANATOMY     = SKILL_MASTER,
	    SKILL_CHEMISTRY   = SKILL_MASTER
	)
	skill_points = 26
	roleplay_difficulty = "Средняя - Тяжёлая"
	mechanical_difficulty = "Средняя - Тяжёлая"
	duties = "Помогайте Директору Медицинского Отдела управлять отделом. Участвуйте в лечении и операциях. Контролируйте младший медицинский персонал."*/

/datum/job/surgeon
	title = "Хирург"
	department = "Медицинский отдел"
	department_flag = MED
	selection_color = "#013d3b"
	total_positions = 3
	spawn_positions = 3
	ideal_character_age = 30
	economic_power = 5
	requirements = list(EXP_TYPE_MEDICAL = 360)
	supervisors = "Директор Медицинского Отдела и Помощник Директора Медицинского Отдела"
	minimal_player_age = 3
	outfit_type = /decl/hierarchy/outfit/job/medical/surgeon
	class = CLASS_B
	hud_icon = "hudsurgeon"

	access = list(
		ACCESS_MED_COMMS,
		ACCESS_MEDICAL_EQUIP,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_MEDICAL_LVL3,
		ACCESS_SCIENCE_LVL1,
		ACCESS_SCIENCE_LVL2
	)
	minimal_access = list()

	min_skill = list(
	    SKILL_MEDICAL     = SKILL_EXPERIENCED,
	    SKILL_ANATOMY     = SKILL_EXPERIENCED,
	    SKILL_CHEMISTRY   = SKILL_BASIC,
		SKILL_DEVICES     = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_MEDICAL     = SKILL_MASTER,
	    SKILL_ANATOMY     = SKILL_MASTER,
	    SKILL_CHEMISTRY   = SKILL_MASTER
	)
	skill_points = 27
	roleplay_difficulty = "Средняя - Тяжёлая"
	mechanical_difficulty = "Средняя - Тяжёлая"
	duties = "Проводите хирургические операции пациентам, как плановые, так и в экстренных случаях."

/datum/job/chemist
	title = "Химик"
	department = "Медицинский отдел"
	department_flag = MED
	minimal_player_age = 3
	total_positions = 2
	spawn_positions = 2
	requirements = list(EXP_TYPE_MEDICAL = 120)
	supervisors = "Директор Медицинского Отдела, Помощник Директора Медицинского Отдела и Старший Врач"
	selection_color = "#013d3b"
	economic_power = 4
	alt_titles = list("Фармацевт")
	ideal_character_age = 30
	outfit_type = /decl/hierarchy/outfit/job/medical/chemist
	class = CLASS_C
	hud_icon = "hudpharmacist"

	access = list(
		ACCESS_MED_COMMS,
		ACCESS_MEDICAL_EQUIP,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2
	)
	minimal_access = list()

	min_skill = list(
	    SKILL_MEDICAL     = SKILL_TRAINED,
	    SKILL_ANATOMY     = SKILL_TRAINED,
	    SKILL_CHEMISTRY   = SKILL_EXPERIENCED,
		SKILL_DEVICES     = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_MEDICAL     = SKILL_MASTER,
	    SKILL_ANATOMY     = SKILL_MASTER,
	    SKILL_CHEMISTRY   = SKILL_MASTER
	)
	skill_points = 24

	roleplay_difficulty = "Лёгкая"
	mechanical_difficulty = "Средняя - Тяжёлая"
	duties = "Приготовляйте лекарства для своего отдела. Экспериментируйте с аномалиями на основе химии."

/datum/job/psychiatrist
	title = "Психиатр"
	department = "Медицинский отдел"
	department_flag = MED
	selection_color = "#013d3b"
	total_positions = 1
	spawn_positions = 1
	minimal_player_age = 3
	ideal_character_age = 40
	economic_power = 5
	supervisors = "Директор Медицинского Отдела, Помощник Директора Медицинского Отдела и Старший Врач"
	alt_titles = list("Консультант")
	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist
	class = CLASS_C
	hud_icon = "hudcounselor"

	access = list(
		ACCESS_MED_COMMS,
		ACCESS_MEDICAL_EQUIP,
		ACCESS_MEDICAL_LVL1
	)
	minimal_access = list()

	min_skill = list(
	    SKILL_MEDICAL     = SKILL_TRAINED,
	    SKILL_ANATOMY     = SKILL_TRAINED,
		SKILL_CHEMISTRY   = SKILL_BASIC,
		SKILL_DEVICES     = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_MEDICAL     = SKILL_MASTER,
	    SKILL_ANATOMY     = SKILL_MASTER,
	    SKILL_CHEMISTRY   = SKILL_MASTER
	)
	skill_points = 24

	roleplay_difficulty = "Средняя - Тяжёлая"
	mechanical_difficulty = "Лёгкая"
	duties = "Проводите терапию и выдавайте препараты для поддержания психического здоровья как персонала, так и SCP."

/datum/job/medicaldoctor
	title = "Врач"
	department = "Медицинский отдел"
	department_flag = MED
	selection_color = "#013d3b"
	total_positions = 5
	spawn_positions = 5
	requirements = list(EXP_TYPE_MEDICAL = 120)
	supervisors = "Директор Медицинского Отдела, Помощник Директора Медицинского Отдела и Старший Врач"
	ideal_character_age = 26
	minimal_player_age = 3
	economic_power = 5
	alt_titles = list("Коронер")
	outfit_type = /decl/hierarchy/outfit/job/medical/medicaldoctor
	class = CLASS_C
	hud_icon = "hudphysician"

	access = list(
		ACCESS_MED_COMMS,
		ACCESS_MEDICAL_EQUIP,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_MEDICAL_LVL3,
		ACCESS_SCIENCE_LVL1
	)
	minimal_access = list()

	min_skill = list(
	    SKILL_MEDICAL     = SKILL_TRAINED,
	    SKILL_ANATOMY     = SKILL_TRAINED,
	    SKILL_CHEMISTRY   = SKILL_TRAINED,
		SKILL_DEVICES     = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_MEDICAL     = SKILL_MASTER,
	    SKILL_ANATOMY     = SKILL_MASTER,
	    SKILL_CHEMISTRY   = SKILL_MASTER
	)
	skill_points = 24
	roleplay_difficulty = "Лёгкая"
	mechanical_difficulty = "Средняя"
	duties = "Диагностируйте и назначайте лечение поступившим пациентам. Сортируйте раненых в критических ситуациях."

/datum/job/surgeon
	title = "Хирург"

/datum/job/emt
	title = "Парамедик"
	department = "Медицинский отдел"
	department_flag = MED
	selection_color = "#013d3b"
	total_positions = 4
	spawn_positions = 4
	ideal_character_age = 40
	economic_power = 5
	requirements = list(EXP_TYPE_MEDICAL = 240)
	supervisors = "Директор Медицинского Отдела и Помощник Директора Медицинского Отдела"
	outfit_type = /decl/hierarchy/outfit/job/medical/emt
	class = CLASS_C
	hud_icon = "hudemt"
	alt_titles = list("Фельдшер") // Это моя отсебятина, ну а с другой стороны чебы нет?

	access = list(
		ACCESS_MED_COMMS,
		ACCESS_MEDICAL_EQUIP,
		ACCESS_SECURITY_LVL1,
		ACCESS_SCIENCE_LVL1,
		ACCESS_ENGINEERING_LVL1,
		ACCESS_ADMIN_LVL1,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2
	)
	minimal_access = list()

	min_skill = list(
	    SKILL_MEDICAL     = SKILL_TRAINED,
	    SKILL_ANATOMY     = SKILL_TRAINED,
	    SKILL_CHEMISTRY   = SKILL_BASIC,
		SKILL_DEVICES     = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_MEDICAL     = SKILL_MASTER,
	    SKILL_ANATOMY     = SKILL_MASTER,
	    SKILL_CHEMISTRY   = SKILL_MASTER
	)
	skill_points = 20
	roleplay_difficulty = "Лёгкая"
	mechanical_difficulty = "Тяжёлая"
	duties = "Быстро реагируйте на чрезвычайные ситуации. Сортируйте раненых. Стабилизируйте пациентов и по возможности доставляйте их в медицинский пост."

/datum/job/emt
	title = "Техник Скорой Медицинской Помощи"

/datum/job/medicalintern
	title = "Медицинский Интерн"
	department = "Медицинский отдел"
	department_flag = MED
	selection_color = "#013d3b"
	total_positions = 4
	spawn_positions = 4
	ideal_character_age = 40
	economic_power = 5
	supervisors = "Директор Медицинского Отдела и Помощник Директора Медицинского Отдела"
	alt_titles = list("Резидент", "Медицинский Аттендант")
	outfit_type = /decl/hierarchy/outfit/job/medical/medicalintern
	class = CLASS_C
	hud_icon = "hudtraineemedicaltechnician"

	access = list(
		ACCESS_MED_COMMS,
		ACCESS_MEDICAL_EQUIP,
		ACCESS_MEDICAL_LVL1,
		ACCESS_MEDICAL_LVL2,
		ACCESS_SCIENCE_LVL1
	)
	minimal_access = list()

	min_skill = list(
	    SKILL_MEDICAL     = SKILL_TRAINED,
	    SKILL_ANATOMY     = SKILL_BASIC,
	    SKILL_CHEMISTRY   = SKILL_BASIC,
		SKILL_DEVICES     = SKILL_TRAINED
	)

	max_skill = list(
		SKILL_MEDICAL     = SKILL_EXPERIENCED,
	    SKILL_ANATOMY     = SKILL_TRAINED,
	    SKILL_CHEMISTRY   = SKILL_EXPERIENCED
	)
	skill_points = 20

	roleplay_difficulty = "Лёгкая"
	mechanical_difficulty = "Средняя - Тяжёлая"
	duties = "Помогайте опытным врачам, учитесь проводить диагностику и лечить пациентов."

#define GET_RANDOM_JOB 0
#define BE_CLASS_D 1
#define RETURN_TO_LOBBY 2

//jobtime tracking

// Отделы
#define EXP_TYPE_CREW "Персонал"
#define EXP_TYPE_COMMAND "Командование"
#define EXP_TYPE_ENGINEERING "Инженерный отдел"
#define EXP_TYPE_MEDICAL "Медицинский отдел"
#define EXP_TYPE_SCIENCE "Научный отдел"
#define EXP_TYPE_SUPPLY "Снабжение"
#define EXP_TYPE_SECURITY "Охрана"
#define EXP_TYPE_SILICON "Синтетики"
#define EXP_TYPE_SERVICE "Обслуживание"
//Categories
#define EXP_TYPE_LIVING "Living"
#define EXP_TYPE_GHOST "Ghost"
#define EXP_TYPE_ANTAG "Antag"
#define EXP_TYPE_ADMIN "Admin"
#define EXP_TYPE_SCP "SCP"

//Sub Categories
#define EXP_TYPE_LCZ "ЛЗС"
#define EXP_TYPE_ECZ "ВЗ"
#define EXP_TYPE_HCZ "ТЗС"
#define EXP_TYPE_BUR "Бюрократ"
#define EXP_TYPE_REP "Представитель"
//Categories are stored on DB along with seperate jobs and sub-categories and departments are calculated in game to avoid cluttering DB.

//Bit Flag Defines
#define ENG			(1<<0)
#define SEC			(1<<1)
#define MED			(1<<2)
#define SCI			(1<<3)
#define CIV			(1<<4)
#define COM			(1<<5)
#define MSC			(1<<6)
#define SRV			(1<<7)
#define SUP			(1<<8)
#define SPT			(1<<9)
#define EXP			(1<<10)
#define ROB			(1<<11)
#define LCZ			(1<<12)
#define ECZ			(1<<13)
#define HCZ			(1<<14)
#define BUR			(1<<15)
#define REP			(1<<16)

// Class rank defines
#define CLASS_A "Класс-А"
#define CLASS_B "Класс-B"
#define CLASS_C "Класс-C"
#define CLASS_D "Класс-D"
#define CLASS_E "Класс-E"
#define CLASS_CI "Класс-CI" // Funnee CI edit.

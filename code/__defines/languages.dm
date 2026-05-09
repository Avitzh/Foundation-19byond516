//Human
#define LANGUAGE_HUMAN_GERMAN		"Немецкий"
#define LANGUAGE_HUMAN_CHINESE		"Мандаринский"
#define LANGUAGE_HUMAN_ARABIC		"Арабский"
#define LANGUAGE_HUMAN_INDIAN		"Хиндустани"
#define LANGUAGE_HUMAN_SPANISH		"Испанский"
#define LANGUAGE_HUMAN_RUSSIAN		"Русский"
#define LANGUAGE_HUMAN_FRENCH		"Французский"
#define LANGUAGE_HUMAN_JAPANESE		"Японский"
#define LANGUAGE_HUMAN_ITALIAN		"Итальянский"

//Human misc
#define LANGUAGE_GUTTER				"Гуттер"
#define LANGUAGE_ENGLISH			"Английский"

//Alien
#define LANGUAGE_EAL				"Кодированный аудио-язык"
#define LANGUAGE_UNATHI_SINTA		"Синта'унати"
#define LANGUAGE_UNATHI_YEOSA		"Йеоса'унати"
#define LANGUAGE_SKRELLIAN			"Скрелльский"
#define LANGUAGE_ROOTLOCAL			"Местный корнеговор"
#define LANGUAGE_ROOTGLOBAL			"Глобальный корнеговор"
#define LANGUAGE_ADHERENT			"Протокол"
#define LANGUAGE_VOX				"Вокс-пиджин"
#define LANGUAGE_NABBER				"Серпентид"

//Antag
#define LANGUAGE_CULT				"Культистский"
#define LANGUAGE_CULT_GLOBAL		"Оккультный"
#define LANGUAGE_ALIUM				"Алиум"

//Other
#define LANGUAGE_PRIMITIVE			"Примитивный"
#define LANGUAGE_SIGN				"Язык жестов"
#define LANGUAGE_ROBOT_GLOBAL		"Язык роботов"
#define LANGUAGE_DRONE_GLOBAL		"Язык дронов"
#define LANGUAGE_CHANGELING_GLOBAL	"Генокрадский"
#define LANGUAGE_BORER_GLOBAL		"Кортикальная связь"
#define LANGUAGE_MANTID_NONVOCAL	"Асцент-Глоу"
#define LANGUAGE_MANTID_VOCAL		"Асцент-Вок"
#define LANGUAGE_MANTID_BROADCAST	"Мирнет"
#define LANGUAGE_ZOMBIE 			"Зомби"

//SCP
#define LANGUAGE_EYEPOD				"Глазоход"
#define LANGUAGE_PLAGUESPEAK_GLOBAL	"Чуморечь"

// Language flags.
/// Language is available if the speaker is whitelisted.
#define WHITELISTED  (1<<0)
/// Language can only be acquired by spawning or an admin.
#define RESTRICTED   (1<<1)
/// Language has a significant non-verbal component. Speech is garbled without line-of-sight.
#define NONVERBAL    (1<<2)
/// Language is completely non-verbal. Speech is displayed through emotes for those who can understand.
#define SIGNLANG     (1<<3)
/// Broadcast to all mobs with this language.
#define HIVEMIND     (1<<4)
/// Do not add to general languages list.
#define NONGLOBAL    (1<<5)
/// All mobs can be assumed to speak and understand this language. (audible emotes)
#define INNATE       (1<<6)
/// Do not show the "\The [speaker] talks into \the [radio]" message
#define NO_TALK_MSG  (1<<7)
/// No stuttering, slurring, or other speech problems
#define NO_STUTTER   (1<<8)
/// Language is not based on vision or sound (TODO: add this into the say code and use it for the rootspeak languages)
#define ALT_TRANSMIT (1<<9)

// Misc
#define MAX_LANGUAGES 3

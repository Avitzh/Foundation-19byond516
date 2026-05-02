/* Diffrent misc types of tiles
 * Contains:
 *		Prototype
 *		Grass
 *		Wood
 *		Linoleum
 *		Carpet
 */

/obj/item/stack/tile
	name = "tile"
	singular_name = "tile"
	desc = "A non-descript floor tile."
	randpixel = 7
	w_class = ITEM_SIZE_NORMAL
	max_amount = 100
	icon = 'icons/obj/tiles.dmi'

	force = 1
	throwforce = 1
	throw_speed = 5
	throw_range = 20
	item_flags = 0
	obj_flags = 0

	drop_sound = SFX_DROP_AXE
	pickup_sound = SFX_PICKUP_AXE
/*
 * Grass
 */
/obj/item/stack/tile/grass
	name = "grass tile"
	singular_name = "grass floor tile"
	desc = "A patch of grass like they often use on golf courses."
	icon_state = "tile_grass"
	origin_tech = list(TECH_BIO = 1)

	drop_sound = SFX_DROP_HERB
	pickup_sound = SFX_PICKUP_HERB

/*
 * Wood
 */
/obj/item/stack/tile/wood
	name = "wood floor tile"
	singular_name = "wood floor tile"
	desc = "An easy to fit wooden floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_GENERIC
	matter = list(MATERIAL_WOOD = 450)

	drop_sound = SFX_DROP_WOODEN
	pickup_sound = SFX_PICKUP_WOODEN

/obj/item/stack/tile/wood/cyborg
	name = "wood floor tile synthesizer"
	desc = "A device that makes wood floor tiles."
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/wood
	build_type = /obj/item/stack/tile/wood

/obj/item/stack/tile/mahogany
	name = "mahogany floor tile"
	singular_name = "mahogany floor tile"
	desc = "An easy to fit mahogany wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_RICH
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/maple
	name = "maple floor tile"
	singular_name = "maple floor tile"
	desc = "An easy to fit maple wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_PALE
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/ebony
	name = "ebony floor tile"
	singular_name = "ebony floor tile"
	desc = "An easy to fit ebony floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_BLACK
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/walnut
	name = "walnut floor tile"
	singular_name = "walnut floor tile"
	desc = "An easy to fit walnut wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_CHOCOLATE
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/bamboo
	name = "bamboo floor tile"
	singular_name = "bamboo floor tile"
	desc = "An easy to fit bamboo wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_PALE2
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/yew
	name = "yew floor tile"
	singular_name = "yew floor tile"
	desc = "An easy to fit yew wood floor tile."
	icon_state = "tile-wood"
	color = WOOD_COLOR_YELLOW
	matter = list(MATERIAL_WOOD = 450)

/obj/item/stack/tile/floor
	name = "steel floor tile"
	singular_name = "steel floor tile"
	desc = "Those could work as a pretty decent throwing weapon." //why?
	icon_state = "tile"
	force = 6
	matter = list(MATERIAL_STEEL = 450)
	throwforce = 15
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/tiled
	name = "steel floor tile"
	singular_name = "steel floor tile"
	desc = "Those could work as a pretty decent throwing weapon."
	icon_state = "tile"
	force = 6
	matter = list(MATERIAL_STEEL = 450)
	throwforce = 15
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono
	name = "steel mono tile"
	singular_name = "steel mono tile"
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/corner
	name = "steel corner tiles"
	singular_name = "steel corner tile"
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/corner/white
	name = "white corner tiles"
	singular_name = "white corner tile"
	icon_state = "tile_white"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/corner/dark
	name = "dark corner tiles"
	singular_name = "dark corner tile"
	icon_state = "fr_tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/horizontal
	name = "steel horizontal tiles"
	singular_name = "steel horizontal tile"
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/vertical
	name = "steel vertical tiles"
	singular_name = "steel vertical tile"
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/horizontal/white
	name = "white horizontal tiles"
	singular_name = "white horizontal tile"
	icon_state = "tile_white"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/vertical/white
	name = "white vertical tiles"
	singular_name = "white vertical tile"
	icon_state = "tile_white"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/horizontal/dark
	name = "dark horizontal tiles"
	singular_name = "dark horizontal tile"
	icon_state = "fr_tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/vertical/dark
	name = "dark vertical tile"
	singular_name = "dark vertical tile"
	icon_state = "fr_tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/small
	name = "steel small tiles"
	singular_name = "steel small tile"
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/small/white
	name = "white small tiles"
	singular_name = "white small tile"
	icon_state = "tile_white"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/small/dark
	name = "dark vertical tiles"
	singular_name = "dark small tile"
	icon_state = "fr_tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono/dark
	name = "dark mono tile"
	singular_name = "dark mono tile"
	icon_state = "fr_tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/mono/white
	name = "white mono tile"
	singular_name = "white mono tile"
	icon_state = "tile_white"
	matter = list(MATERIAL_PLASTIC = 450)

/obj/item/stack/tile/grid
	name = "grey grid tile"
	singular_name = "grey grid tile"
	icon_state = "tile_grid"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/ridge
	name = "grey ridge tile"
	singular_name = "grey ridge tile"
	icon_state = "tile_ridged"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/techgrey
	name = "grey techfloor tile"
	singular_name = "grey techfloor tile"
	icon_state = "techtile_grey"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/techgrid
	name = "grid techfloor tile"
	singular_name = "grid techfloor tile"
	icon_state = "techtile_grid"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/techmaint
	name = "dark techfloor tile"
	singular_name = "dark techfloor tile"
	icon_state = "techtile_maint"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/floor_white
	name = "white floor tile"
	singular_name = "white floor tile"
	icon_state = "tile_white"
	matter = list(MATERIAL_PLASTIC = 450)

/obj/item/stack/tile/floor_white/fifty
	amount = 50

/obj/item/stack/tile/floor_dark
	name = "dark floor tile"
	singular_name = "dark floor tile"
	icon_state = "fr_tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/floor_dark/fifty
	amount = 50

/obj/item/stack/tile/floor_freezer
	name = "freezer floor tile"
	singular_name = "freezer floor tile"
	icon_state = "tile_freezer"
	matter = list(MATERIAL_PLASTIC = 450)

/obj/item/stack/tile/floor_freezer/fifty
	amount = 50

/obj/item/stack/tile/floor/cyborg
	name = "floor tile synthesizer"
	desc = "A device that makes floor tiles."
	gender = NEUTER
	matter = null
	uses_charge = 1
	charge_costs = list(250)
	stacktype = /obj/item/stack/tile/floor
	build_type = /obj/item/stack/tile/floor

/obj/item/stack/tile/linoleum
	name = "linoleum"
	singular_name = "linoleum"
	desc = "A piece of linoleum. It is the same size as a normal floor tile!"
	icon_state = "tile_linoleum"

/obj/item/stack/tile/linoleum/fifty
	amount = 50

/obj/item/stack/tile/stone
	name = "stone slabs"
	singular name = "stone slab"
	desc = "A smooth, flat slab of some kind of stone."
	icon_state = "tile_stone"

/*
 * Carpets
 */
/obj/item/stack/tile/carpet
	name = "carpet"
	singular_name = "carpet"
	desc = "A piece of carpet."
	icon_state = "tile_carpet"

/obj/item/stack/tile/carpetbrown
	name = "brown carpet"
	singular_name = "brown carpet"
	desc = "A piece of brown carpet."
	icon_state = "tile_carpetbrown"

/obj/item/stack/tile/carpetbrown/fifty
	amount = 50

/obj/item/stack/tile/carpetblue
	name = "blue carpet"
	desc = "A piece of blue and gold carpet."
	singular_name = "blue carpet"
	icon_state = "tile_carpetblue"

/obj/item/stack/tile/carpetblue/fifty
	amount = 50

/obj/item/stack/tile/carpetblue2
	name = "pale blue carpet"
	desc = "A piece of blue and pale blue carpet."
	singular_name = "pale blue carpet"
	icon_state = "tile_carpetblue2"

/obj/item/stack/tile/carpetblue2/fifty
	amount = 50

/obj/item/stack/tile/carpetblue3
	name = "sea blue carpet"
	desc = "A piece of blue and green carpet."
	singular_name = "sea blue carpet"
	icon_state = "tile_carpetblue3"

/obj/item/stack/tile/carpetblue3/fifty
	amount = 50

/obj/item/stack/tile/carpetmagenta
	name = "magenta carpet"
	desc = "A piece of magenta carpet."
	singular_name = "magenta carpet"
	icon_state = "tile_carpetmagenta"

/obj/item/stack/tile/carpetmagenta/fifty
	amount = 50

/obj/item/stack/tile/carpetpurple
	name = "purple carpet"
	desc = "A piece of purple carpet."
	singular_name = "purple carpet"
	icon_state = "tile_carpetpurple"

/obj/item/stack/tile/carpetpurple/fifty
	amount = 50

/obj/item/stack/tile/carpetorange
	name = "orange carpet"
	desc = "A piece of orange carpet."
	singular_name = "orange carpet"
	icon_state = "tile_carpetorange"

/obj/item/stack/tile/carpetorange/fifty
	amount = 50

/obj/item/stack/tile/carpetgreen
	name = "green carpet"
	desc = "A piece of green carpet."
	singular_name = "green carpet"
	icon_state = "tile_carpetgreen"

/obj/item/stack/tile/carpetgreen/fifty
	amount = 50

/obj/item/stack/tile/carpetred
	name = "red carpet"
	desc = "A piece of red carpet."
	singular_name = "red carpet"
	icon_state = "tile_carpetred"

/obj/item/stack/tile/carpetred/fifty
	amount = 50

/obj/item/stack/tile/carpetblack
	name = "black carpet"
	desc = "A piece of black carpet."
	singular_name = "red carpet"
	icon_state = "tile_carpetblack"

/obj/item/stack/tile/carpetblack/fifty
	amount = 50

/obj/item/stack/tile/pool
	name = "pool tiling"
	desc = "A set of tiles designed to build fluid pools."
	singular_name = "pool tile"
	icon_state = "tile_pool"
	matter = list(MATERIAL_STEEL = 450)


 // New Floor Tiles

/obj/item/stack/tile/plating_norn
	name = "plating norn tile"
	singular_name = "plating norn floor tile"
	desc = "Norn plating floor tile."
	icon_state = "techtile_grey"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/steel_monofloor
	name = "steel monofloor tile"
	singular_name = "steel monofloor tile"
	desc = "Steel monofloor tile."
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/tiled_white
	name = "tiled white tile"
	singular_name = "tiled white floor tile"
	desc = "Tiled white floor tile."
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/white_ridged
	name = "white ridged tile"
	singular_name = "white ridged floor tile"
	desc = "White ridged floor tile."
	icon_state = "white_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/white_herringbone
	name = "white herringbone tile"
	singular_name = "white herringbone floor tile"
	desc = "White herringbone floor tile."
	icon_state = "white_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/white_norn
	name = "white norn tile"
	singular_name = "white norn floor tile"
	desc = "White norn floor tile."
	icon_state = "white_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_white
	name = "textured white tile"
	singular_name = "textured white floor tile"
	desc = "Textured white floor tile."
	icon_state = "white_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_white_edge
	name = "textured white edge tile"
	singular_name = "textured white edge floor tile"
	desc = "Textured white edge floor tile."
	icon_state = "white_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_white_half
	name = "textured white half tile"
	singular_name = "textured white half floor tile"
	desc = "Textured white half floor tile."
	icon_state = "white_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_white_corner
	name = "textured white corner tile"
	singular_name = "textured white corner floor tile"
	desc = "Textured white corner floor tile."
	icon_state = "white_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/white_grid
	name = "white grid tile"
	singular_name = "white grid floor tile"
	desc = "White grid floor tile."
	icon_state = "white_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_white_large
	name = "textured white large tile"
	singular_name = "textured white large floor tile"
	desc = "Textured white large floor tile."
	icon_state = "white_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/darkfull
	name = "darkfull tile"
	singular_name = "darkfull floor tile"
	desc = "Darkfull floor tile."
	icon_state = "fr_tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/dark_old
	name = "dark old tile"
	singular_name = "dark old floor tile"
	desc = "Dark old floor tile."
	icon_state = "fr_tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/dark_herringbone
	name = "dark herringbone tile"
	singular_name = "dark herringbone floor tile"
	desc = "Dark herringbone floor tile."
	icon_state = "fr_tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/tiled_dark
	name = "tiled dark tile"
	singular_name = "tiled dark floor tile"
	desc = "Tiled dark floor tile."
	icon_state = "fr_tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/dark_ridged
	name = "dark ridged tile"
	singular_name = "dark ridged floor tile"
	desc = "Dark ridged floor tile."
	icon_state = "fr_tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/smooth_corner
	name = "smooth corner tile"
	singular_name = "smooth corner floor tile"
	desc = "Smooth corner floor tile."
	icon_state = "techtile_grid"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/smooth_large
	name = "smooth large tile"
	singular_name = "smooth large floor tile"
	desc = "Smooth large floor tile."
	icon_state = "techtile_grid"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/smooth
	name = "smooth tile"
	singular_name = "smooth floor tile"
	desc = "Smooth floor tile."
	icon_state = "techtile_grid"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/smooth_edge
	name = "smooth edge tile"
	singular_name = "smooth edge floor tile"
	desc = "Smooth edge floor tile."
	icon_state = "techtile_grid"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/smooth_half
	name = "smooth half tile"
	singular_name = "smooth half floor tile"
	desc = "Smooth half floor tile."
	icon_state = "techtile_grid"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured
	name = "steel cropped"
	singular_name = "textured floor tile"
	desc = "Textured floor tile."
	icon_state = "steel_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_edge
	name = "steel cropped"
	singular_name = "textured edge floor tile"
	desc = "Textured edge floor tile."
	icon_state = "steel_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_half
	name = "steel cropped"
	singular_name = "textured half floor tile"
	desc = "Textured half floor tile."
	icon_state = "steel_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_corner
	name = "steel cropped"
	singular_name = "textured corner floor tile"
	desc = "Textured corner floor tile."
	icon_state = "steel_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_large
	name = "textured large tile"
	singular_name = "textured large floor tile"
	desc = "Textured large floor tile."
	icon_state = "steel_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/steel_old
	name = "steel old tile"
	singular_name = "steel old floor tile"
	desc = "Steel old floor tile."
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_dark
	name = "textured dark tile"
	singular_name = "textured dark floor tile"
	desc = "Textured dark floor tile."
	icon_state = "fr_tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_dark_edge
	name = "textured dark edge tile"
	singular_name = "textured dark edge floor tile"
	desc = "Textured dark edge floor tile."
	icon_state = "fr_tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_dark_half
	name = "textured dark half tile"
	singular_name = "textured dark half floor tile"
	desc = "Textured dark half floor tile."
	icon_state = "fr_tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_dark_corner
	name = "textured dark corner tile"
	singular_name = "textured dark corner floor tile"
	desc = "Textured dark corner floor tile."
	icon_state = "textured_dark_corner"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/textured_dark_large
	name = "textured dark large tile"
	singular_name = "textured dark large floor tile"
	desc = "Textured dark large floor tile."
	icon_state = "fr_tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/black_half
	name = "black half tile"
	singular_name = "black half floor tile"
	desc = "Black half floor tile."
	icon_state = "tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/vault
	name = "vault tile"
	singular_name = "vault floor tile"
	desc = "Vault floor tile."
	icon_state = "tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/darkfull_norn
	name = "darkfull norn tile"
	singular_name = "darkfull norn floor tile"
	desc = "Darkfull norn floor tile."
	icon_state = "tile_rough"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/floor_norn
	name = "floor norn tile"
	singular_name = "floor norn floor tile"
	desc = "Floor norn floor tile."
	icon_state = "tile"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

/obj/item/stack/tile/steel_herringbone
	name = "steel herringbone tile"
	singular_name = "steel herringbone floor tile"
	desc = "Steel herringbone floor tile."
	icon_state = "steel_herringbone"
	matter = list(MATERIAL_STEEL = 450)
	obj_flags = OBJ_FLAG_CONDUCTIBLE

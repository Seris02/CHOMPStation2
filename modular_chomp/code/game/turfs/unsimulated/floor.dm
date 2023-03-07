/turf/unsimulated/floor
	name = "floor"
	icon = 'icons/turf/floors.dmi'
	icon_state = "Floor3"
	dynamic_lighting = TRUE

	// Flooring data.
	var/flooring_override
	var/initial_flooring // Allows us to get footstep sounds. :3
	var/decl/flooring/flooring
	var/list/old_decals = null

	var/static/list/base_footstep_sounds = list("human" = list(
		'sound/effects/footstep/plating1.ogg',
		'sound/effects/footstep/plating2.ogg',
		'sound/effects/footstep/plating3.ogg',
		'sound/effects/footstep/plating4.ogg',
		'sound/effects/footstep/plating5.ogg'))
	//CHOMP reagent belly sloshing sounds
	var/static/list/base_vorefootstep_sounds = list("human" = list(
		'sound/vore/walkslosh1.ogg',
		'sound/vore/walkslosh2.ogg',
		'sound/vore/walkslosh3.ogg',
		'sound/vore/walkslosh4.ogg',
		'sound/vore/walkslosh5.ogg',
		'sound/vore/walkslosh6.ogg',
		'sound/vore/walkslosh7.ogg',
		'sound/vore/walkslosh8.ogg',
		'sound/vore/walkslosh9.ogg',
		'sound/vore/walkslosh10.ogg'))


// Shuttle Turfs
/turf/unsimulated/shuttle/floor
	name = "floor"
	icon = 'icons/turf/flooring/shuttle.dmi'
	icon_state = "floor_blue"

/turf/unsimulated/shuttle/floor/red
	icon_state = "floor_red"

/turf/unsimulated/shuttle/floor/yellow
	icon_state = "floor_yellow"

/turf/unsimulated/shuttle/floor/darkred
	icon_state = "floor_dred"

/turf/unsimulated/shuttle/floor/purple
	icon_state = "floor_purple"

/turf/unsimulated/shuttle/floor/white
	icon_state = "floor_white"

/turf/unsimulated/shuttle/floor/black
	icon_state = "floor_black"

/turf/unsimulated/shuttle/floor/glass
	icon_state = "floor_glass"

/turf/unsimulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/decl/flooring/tiling/milspec
	name = "milspec floor"
	desc = "Scuffed from the passage of countless ground pounders."
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_base = "milspec"
	has_damage_range = 2
	damage_temperature = T0C+1400
	build_type = /obj/item/stack/tile/floor/milspec
	plating_type = /decl/flooring/eris_plating/under
	can_paint = 1
	can_engrave = TRUE
	footstep_sounds = list("human" = list(
		'sound/effects/footstep/floor1.ogg',
		'sound/effects/footstep/floor2.ogg',
		'sound/effects/footstep/floor3.ogg',
		'sound/effects/footstep/floor4.ogg',
		'sound/effects/footstep/floor5.ogg'))

/turf/unsimulated/floor/tiled/milspec
	name = "milspec floor"
	desc = "Scuffed from the passage of countless ground pounders."
	icon = 'icons/turf/flooring/tiles_vr.dmi'
	icon_state = "milspec"
	initial_flooring = /decl/flooring/tiling/milspec

/turf/unsimulated/floor/tiled/milspec/sterile
	name = "sterile milspec floor"
	icon_state = "dark_sterile"
	initial_flooring = /decl/flooring/tiling/milspec/sterile

/turf/unsimulated/floor/tiled/milspec/raised
	name = "raised milspec floor"
	icon_state = "milspec_tcomms"
	initial_flooring = /decl/flooring/tiling/milspec/raised

// Plating turf, for maint/etc
/turf/unsimulated/floor/plating
	name = "plating"
	desc = "Unfinished flooring."
	icon = 'icons/turf/flooring/plating_vr.dmi'
	icon_state = "plating"

// Sandy floors o:
/turf/unsimulated/mineral/floor
	name = "sand"
	icon = 'icons/turf/flooring/asteroid.dmi'
	icon_state = "asteroid"
	density = FALSE
	opacity = 0
	blocks_air = 0

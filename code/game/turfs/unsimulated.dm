/turf/unsimulated
	name = "command"
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/skip_init = TRUE // Don't call down the chain, apparently for performance when loading maps at runtime.
	flags = TURF_ACID_IMMUNE

/turf/unsimulated/Initialize(mapload)
	if(skip_init)
		initialized = TRUE
		return INITIALIZE_HINT_NORMAL
	. = ..()

// CHOMPStation Add: Set_Flooring
/turf/unsimulated/floor/Initialize(mapload, floortype)
	. = ..()
	// CHOMPEdit: Add Flooring types
	if(!floortype && initial_flooring)
		floortype = initial_flooring
	if(floortype)
		set_flooring(get_flooring_data(floortype), TRUE)
		. = INITIALIZE_HINT_LATELOAD // We'll update our icons after everyone is ready
	else
		vorefootstep_sounds = base_vorefootstep_sounds //CHOMPstation edit
		footstep_sounds = base_footstep_sounds

/turf/unsimulated/floor/proc/set_flooring(var/decl/flooring/newflooring, var/initializing)
	//make_plating(defer_icon_update = 1)
	if(is_plating() && !initializing) // Plating -> Flooring
		swap_decals()
	flooring = newflooring
	vorefootstep_sounds = newflooring.vorefootstep_sounds //CHOMPstation edit
	footstep_sounds = newflooring.footstep_sounds
	if(!initializing)
		update_icon(1)
	levelupdate()

/turf/unsimulated/floor/update_icon(var/update_neighbors)
	cut_overlays()

	if(flooring)
		// Set initial icon and strings.
		name = flooring.name
		desc = flooring.desc
		icon = flooring.icon

		if(flooring_override)
			icon_state = flooring_override
		else
			icon_state = flooring.icon_base
									//VOREStation Addition Start
			if(flooring.check_season)
				icon_state = "[icon_state]-[world_time_season]"	//VOREStation Addition End
			if(flooring.has_base_range)
				icon_state = "[icon_state][rand(0,flooring.has_base_range)]"
				flooring_override = icon_state

	// Re-apply floor decals
	if(LAZYLEN(decals))
		add_overlay(decals)

/turf/unsimulated/floor/proc/swap_decals()
	var/current_decals = decals
	decals = old_decals
	old_decals = current_decals

// CHOMPAdd End

//VOREStation Add
/turf/unsimulated/fake_space
	name = "\proper space"
	icon = 'icons/turf/space.dmi'
	icon_state = "0"
	dynamic_lighting = FALSE
	initialized = FALSE

/turf/unsimulated/fake_space/Initialize(mapload)
	. = ..()
	icon_state = "[((x + y) ^ ~(x * y) + z) % 25]"
//VOREStation Add End

// Better nip this just in case.
/turf/unsimulated/rcd_values(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	return FALSE

/turf/unsimulated/rcd_act(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	return FALSE

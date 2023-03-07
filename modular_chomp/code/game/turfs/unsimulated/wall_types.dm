/turf/unsimulated/wall
	dynamic_lighting = TRUE

/turf/unsimulated/wall/generic
	icon = 'icons/turf/wall_masks.dmi'
	icon_state = "generic"
	var/datum/material/material = MAT_STEEL
	var/list/wall_connections = list("0", "0", "0", "0")

/turf/unsimulated/wall/generic/r_wall
	icon_state = "rgeneric"
	material = MAT_PLASTEEL

/turf/unsimulated/wall/generic/New()
	..()
	material = get_material_by_name(material)
	update_connections()
	update_icon()

/turf/unsimulated/wall/generic/proc/update_connections(propagate = 0)
	var/list/dirs = list()
	var/inrange = orange(src, 1)
	for(var/turf/unsimulated/wall/W in inrange)
		if(istype(W, /turf/unsimulated/wall/generic))
			dirs += get_dir(src, W)

	wall_connections = dirs_to_corner_states(dirs)

/turf/unsimulated/wall/generic/update_icon()
	cut_overlays()
	var/image/I

	for(var/i = 1 to 4)
		I = image(icon, "[material.icon_base][wall_connections[i]]", dir = 1<<(i-1))
		I.color = material.icon_colour
		add_overlay(I)

/turf/unsimulated/wall/generic/r_wall/update_icon()
	..()
	var/image/I
	if("[material.icon_reinf]0" in cached_icon_states(icon))
		// Directional icon
		for(var/i = 1 to 4)
			I = image(icon, "[material.icon_reinf][wall_connections[i]]", dir = 1<<(i-1))
			I.color = material.icon_colour
			add_overlay(I)
	else if("[material.icon_reinf]" in cached_icon_states(icon))
		I = image(icon, material.icon_reinf)
		I.color = material.icon_colour
		add_overlay(I)

/*
 * Folder for adding our own props.
 * Not going to separate this out into multiple files yet.
*/

// APCs and power-related machinery/items.
/obj/structure/prop/machinery/power/apc
	name = "area power controller"
	desc = "A control terminal for the area electrical systems."
	icon = 'icons/obj/power.dmi'
	icon_state = "apc0"
	density = FALSE // Not dense, you can pass through APCs + cables

/obj/structure/prop/machinery/power/apc/New()
	..()
	if (!pixel_x && !pixel_y)
		offset_apc()

/obj/structure/prop/machinery/power/apc/proc/offset_apc()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? 26 : -26)
	pixel_y = (dir & 3) ? (dir == 1 ? 26 : -26) : 0

/obj/structure/prop/machinery/power/apc/critical

/obj/structure/prop/machinery/power/apc/high

/obj/structure/prop/machinery/power/apc/super

/obj/structure/prop/machinery/power/apc/super/critical

/obj/structure/prop/machinery/power/apc/hyper

/obj/structure/prop/machinery/power/apc/alarms_hidden

/obj/structure/prop/machinery/power/apc/angled
	icon = 'icons/obj/wall_machines_angled.dmi'

/obj/structure/prop/machinery/power/apc/angled/hidden

/obj/structure/prop/machinery/power/apc/angled/offset_apc()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? 24 : -24)
	pixel_y = (dir & 3) ? (dir == 1 ? 20 : -20) : 0

// Wires, copy-pasted from cable.dm
///////////////////////////////


////////////////////////////////
// Definitions
////////////////////////////////

/* Cable directions (d1 and d2)


  9   1   5
	\ | /
  8 - 0 - 4,
	/ | \
  10  2   6

If d1 = 0 and d2 = 0, there's no cable
If d1 = 0 and d2 = dir, it's a O-X cable, getting from the center of the tile to dir (knot cable)
If d1 = dir1 and d2 = dir2, it's a full X-X cable, getting from dir1 to dir2
By design, d1 is the smallest direction and d2 is the highest
*/

/obj/structure/prop/cable
	level = 1
	anchored =TRUE
	unacidable = TRUE
	name = "power cable"
	desc = "A flexible superconducting cable for heavy-duty power transfer."
	icon = 'icons/obj/power_cond_white.dmi'
	icon_state = "0-1"
	var/d1 = 0
	var/d2 = 1
	plane = PLATING_PLANE
	layer = WIRES_LAYER
	color = COLOR_RED

/obj/structure/prop/cable/yellow
	color = COLOR_YELLOW

/obj/structure/prop/cable/green
	color = COLOR_LIME

/obj/structure/prop/cable/blue
	color = COLOR_BLUE

/obj/structure/prop/cable/pink
	color = COLOR_PINK

/obj/structure/prop/cable/orange
	color = COLOR_ORANGE

/obj/structure/prop/cable/cyan
	color = COLOR_CYAN

/obj/structure/prop/cable/white
	color = COLOR_WHITE

/obj/structure/prop/cable/New() // Modified slightly, we're skipping the cable list
	..()

	// ensure d1 & d2 reflect the icon_state for entering and exiting cable

	var/dash = findtext(icon_state, "-")

	d1 = text2num( copytext( icon_state, 1, dash ) )

	d2 = text2num( copytext( icon_state, dash+1 ) )

	var/turf/T = src.loc			// hide if turf is not intact
	if(level==1) hide(!T.is_plating())


/obj/structure/prop/cable/Destroy()					// called when a cable is deleted
	return ..()									// then go ahead and delete the cable

// Rotating cables requires d1 and d2 to be rotated
/obj/structure/prop/cable/set_dir(new_dir)

	// If d1 is 0, then it's a not, and doesn't rotate
	if(d1)
		// Using turn will maintain the cable's shape
		// Taking the difference between current orientation and new one
		d1 = turn(d1, dir2angle(new_dir) - dir2angle(dir))
	d2 = turn(d2, dir2angle(new_dir) - dir2angle(dir))

	// Maintain d1 < d2
	if(d1 > d2)
		var/temp = d1
		d1 = d2
		d2 = temp

	//	..()	Cable sprite generation is dependent upon only d1 and d2.
	// 			Actually changing dir will rotate the generated sprite to look wrong, but function correctly.
	update_icon()

///////////////////////////////////
// General procedures
///////////////////////////////////

//If underfloor, hide the cable
/obj/structure/prop/cable/hide(var/i)
	if(istype(loc, /turf))
		invisibility = i ? 101 : 0
	update_icon()

/obj/structure/prop/cable/hides_under_flooring()
	return 1

/obj/structure/prop/cable/update_icon()
	icon_state = "[d1]-[d2]"
	alpha = invisibility ? 127 : 255

// Fire alarms, Air Alarms.
// These exist solely to enable easier copy/paste.
/obj/structure/prop/machinery/firealarm
	name = "fire alarm"
	desc = "<i>\"Pull this in case of emergency\"</i>. Thus, keep pulling it forever."
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire"
	layer = ABOVE_WINDOW_LAYER
	blocks_emissive = FALSE
	vis_flags = VIS_HIDE // They have an emissive that looks bad in openspace due to their wall-mounted nature
	anchored = TRUE
	unacidable = TRUE

/obj/structure/prop/machinery/firealarm/New()
	..()
	if (!pixel_x && !pixel_y)
		offset_alarm()

/obj/structure/prop/machinery/firealarm/proc/offset_alarm()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? 26 : -26)
	pixel_y = (dir & 3) ? (dir == 1 ? -26 : 26) : 0

/obj/structure/prop/machinery/firealarm/alarms_hidden

/obj/structure/prop/machinery/firealarm/angled
	icon = 'icons/obj/wall_machines_angled.dmi'

/obj/structure/prop/machinery/firealarm/angled/hidden

/obj/structure/prop/machinery/firealarm/angled/offset_alarm()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? 20 : -20)
	pixel_y = (dir & 3) ? (dir == 1 ? -18 : 21) : 0

/obj/structure/prop/machinery/partyalarm
	name = "\improper PARTY BUTTON"
	desc = "Cuban Pete is in the house!"
	icon = 'icons/obj/monitors.dmi'
	icon_state = "fire0"
	anchored = TRUE

/obj/structure/prop/machinery/alarm
	name = "alarm"
	desc = "Used to control various station atmospheric systems. The light indicates the current air status of the area."
	icon = 'icons/obj/monitors_vr.dmi' //VOREStation Edit - Other icons
	icon_state = "alarm_0"
	layer = ABOVE_WINDOW_LAYER
	vis_flags = VIS_HIDE // They have an emissive that looks bad in openspace due to their wall-mounted nature
	anchored = TRUE
	unacidable = TRUE

/obj/structure/prop/machinery/alarm/New()
	..()
	if (!pixel_x && !pixel_y)
		offset_airalarm()

/obj/structure/prop/machinery/alarm/proc/offset_airalarm()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? -26 : 26)
	pixel_y = (dir & 3) ? (dir == 1 ? -26 : 26) : 0

/obj/structure/prop/machinery/alarm/nobreach

/obj/structure/prop/machinery/alarm/monitor

/obj/structure/prop/machinery/alarm/alarms_hidden

/obj/structure/prop/machinery/alarm/angled
	icon = 'icons/obj/wall_machines_angled.dmi'

/obj/structure/prop/machinery/alarm/angled/hidden

/obj/structure/prop/machinery/alarm/angled/offset_airalarm()
	pixel_x = (dir & 3) ? 0 : (dir == 4 ? -21 : 21)
	pixel_y = (dir & 3) ? (dir == 1 ? -18 : 20) : 0

/obj/structure/prop/machinery/alarm/freezer

// Camera Replacement;
/obj/structure/prop/machinery/camera
	name = "security camera"
	desc = "It's used to monitor rooms."
	icon = 'icons/obj/monitors_vr.dmi' //VOREStation Edit - New Icons
	icon_state = "camera"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	var/c_tag = "null" // Nonexistant var, does nada for our props, but cuts down on work having to re-convert.

// NS-specific subtypes;
/obj/structure/prop/machinery/camera/network/command

/obj/structure/prop/machinery/camera/network/research

/obj/structure/prop/machinery/camera/network/medbay

/obj/structure/prop/machinery/camera/network/prison

/obj/structure/prop/machinery/camera/network/thunder

/obj/structure/prop/machinery/camera/network/northern_star

/obj/structure/prop/machinery/camera/network/civilian

/obj/structure/prop/machinery/camera/network/security

// Vents/Pipes + Scrubbers/Pumps
/obj/structure/prop/machinery/atmospherics/unary/vent_pump
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "map_vent"
	var/id_tag = null

	name = "Air Vent"
	desc = "Has a valve and pump attached to it"

/obj/structure/prop/machinery/atmospherics/unary/vent_pump/on
	icon_state = "map_vent_out"

/obj/structure/prop/machinery/atmospherics/unary/vent_pump/high_volume
	name = "Large Air Vent"
	var/id_tag = null
/obj/structure/prop/machinery/atmospherics/unary/vent_scrubber
	icon = 'icons/atmos/vent_scrubber.dmi'
	icon_state = "map_scrubber_off"
	var/id_tag = null

	name = "Air Scrubber"
	desc = "Has a valve and pump attached to it"

/obj/structure/prop/machinery/atmospherics/unary/vent_scrubber/on
	icon_state = "map_scrubber_on"

/obj/structure/prop/machinery/atmospherics/pipe
	layer = PIPES_LAYER

/obj/structure/prop/machinery/atmospherics/pipe/vent
	icon = 'icons/obj/atmospherics/pipe_vent.dmi'
	icon_state = "intact"
	name = "Vent"
	desc = "A large air vent"
	dir = SOUTH

/obj/structure/prop/machinery/atmospherics/pipe/simple
	icon = 'icons/atmos/pipes.dmi'
	name = "pipe"
	desc = "A one meter section of regular pipe"

	dir = SOUTH

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe"
	icon_state = "intact-scrubbers"
	layer = PIPES_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe"
	icon_state = "intact-supply"
	layer = PIPES_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/fuel
	name = "Fuel pipe"
	desc = "A one meter section of fuel pipe"
	icon_state = "intact-fuel"
	layer = PIPES_FUEL_LAYER
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/aux
	name = "Aux pipe"
	desc = "A one meter section of aux pipe"
	icon_state = "intact-aux"
	layer = PIPES_AUX_LAYER
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/green
	color = PIPE_COLOR_GREEN

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/black
	color = PIPE_COLOR_BLACK

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/red
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/blue
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden
	icon_state = "intact"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/scrubbers
	name = "Scrubbers pipe"
	desc = "A one meter section of scrubbers pipe"
	icon_state = "intact-scrubbers"
	layer = PIPES_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/supply
	name = "Air supply pipe"
	desc = "A one meter section of supply pipe"
	icon_state = "intact-supply"
	layer = PIPES_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/fuel
	name = "Fuel pipe"
	desc = "A one meter section of fuel pipe"
	icon_state = "intact-fuel"
	layer = PIPES_FUEL_LAYER
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/aux
	name = "Aux pipe"
	desc = "A one meter section of aux pipe"
	icon_state = "intact-aux"
	layer = PIPES_AUX_LAYER
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/green
	color = PIPE_COLOR_GREEN

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/black
	color = PIPE_COLOR_BLACK

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/red
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/purple
	color = PIPE_COLOR_PURPLE

/obj/structure/prop/machinery/atmospherics/pipe/manifold
	icon = 'icons/atmos/manifold.dmi'
	name = "pipe manifold"
	desc = "A manifold composed of regular pipes"

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible
	icon_state = "map"
	level = 2

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	layer = PIPES_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	layer = PIPES_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/fuel
	name="Fuel pipe manifold"
	desc = "A manifold composed of fuel pipes"
	icon_state = "map-fuel"
	layer = PIPES_FUEL_LAYER
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/aux
	name="Aux pipe manifold"
	desc = "A manifold composed of aux pipes"
	icon_state = "map-aux"
	layer = PIPES_AUX_LAYER
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/green
	color = PIPE_COLOR_GREEN

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/black
	color = PIPE_COLOR_BLACK

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/red
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/blue
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/manifold/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden
	icon_state = "map"
	level = 1
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	name="Scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	layer = PIPES_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/supply
	name="Air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map-supply"
	layer = PIPES_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/fuel
	name="Fuel pipe manifold"
	desc = "A manifold composed of fuel pipes"
	icon_state = "map-fuel"
	layer = PIPES_FUEL_LAYER
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/aux
	name="Aux pipe manifold"
	desc = "A manifold composed of aux pipes"
	icon_state = "map-aux"
	layer = PIPES_AUX_LAYER
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/green
	color = PIPE_COLOR_GREEN

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/black
	color = PIPE_COLOR_BLACK

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/red
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/manifold/hidden/purple
	color = PIPE_COLOR_PURPLE

/obj/structure/prop/machinery/atmospherics/pipe/simple/visible/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes"
	icon_state = "map_universal"

/obj/structure/prop/machinery/atmospherics/pipe/simple/hidden/universal
	name="Universal pipe adapter"
	desc = "An adapter for regular, supply and scrubbers pipes"
	icon_state = "map_universal"

/obj/structure/prop/machinery/atmospherics/binary/pump
	icon = 'icons/atmos/pump.dmi'
	icon_state = "map_off"

	name = "gas pump"
	desc = "A pump that moves gas from one place to another."

/obj/structure/prop/machinery/atmospherics/binary/pump/on
	icon_state = "map_on"

/obj/structure/prop/machinery/atmospherics/portables_connector
	icon = 'icons/atmos/connector.dmi'
	icon_state = "map_connector"

	name = "Connector Port"
	desc = "For connecting portables devices related to atmospherics control."

	dir = SOUTH

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w
	icon = 'icons/atmos/manifold.dmi'
	icon_state = ""
	name = "4-way pipe manifold"
	desc = "A manifold composed of regular pipes"

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible
	icon_state = "map_4way"

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/scrubbers
	name="4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map_4way-scrubbers"
	layer = PIPES_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/supply
	name="4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map_4way-supply"
	layer = PIPES_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/fuel
	name="4-way fuel pipe manifold"
	desc = "A manifold composed of fuel pipes"
	icon_state = "map_4way-fuel"
	layer = PIPES_FUEL_LAYER
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/aux
	name="4-way aux pipe manifold"
	desc = "A manifold composed of aux pipes"
	icon_state = "map_4way-aux"
	layer = PIPES_AUX_LAYER
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/green
	color = PIPE_COLOR_GREEN

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/black
	color = PIPE_COLOR_BLACK

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/red
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/blue
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/visible/purple
	color = PIPE_COLOR_PURPLE

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden
	icon_state = "map_4way"
	alpha = 128		//set for the benefit of mapping - this is reset to opaque when the pipe is spawned in game

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers
	name="4-way scrubbers pipe manifold"
	desc = "A manifold composed of scrubbers pipes"
	icon_state = "map_4way-scrubbers"
	layer = PIPES_SCRUBBER_LAYER
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/supply
	name="4-way air supply pipe manifold"
	desc = "A manifold composed of supply pipes"
	icon_state = "map_4way-supply"
	layer = PIPES_SUPPLY_LAYER
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/fuel
	name="4-way fuel pipe manifold"
	desc = "A manifold composed of fuel pipes"
	icon_state = "map_4way-fuel"
	layer = PIPES_FUEL_LAYER
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/aux
	name="4-way aux pipe manifold"
	desc = "A manifold composed of aux pipes"
	icon_state = "map_4way-aux"
	layer = PIPES_AUX_LAYER
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/green
	color = PIPE_COLOR_GREEN

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/black
	color = PIPE_COLOR_BLACK

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/red
	color = PIPE_COLOR_RED

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/structure/prop/machinery/atmospherics/pipe/manifold4w/hidden/purple
	color = PIPE_COLOR_PURPLE

/area/casino/casino_ship
	name = "\improper Casino Ship"
	icon_state = "yellow"
	requires_power = 0
	dynamic_lighting = 1

/area/casino/casino_ship/wing_left
	name = "\improper Casino Ship left wing"
	icon_state = "yellow"

/area/casino/casino_ship/wing_right
	name = "\improper Casino Ship right wing"
	icon_state = "yellow"

/area/casino/casino_ship/dorms
	name = "\improper Casino Ship dorms"
	icon_state = "yellow"
	soundproofed = TRUE

/area/casino/casino_ship/cockpit
	name = "\improper Casino Ship left wing"
	icon_state = "yellow"

/area/shuttle/casino/
	name = "\improper Casino Shuttle"
	dynamic_lighting = 0
	icon_state = "shuttlegrn"

/area/surface/outpost/main/dorms
	name = "\improper Main Outpost Dorms"
	soundproofed = TRUE
	forbid_events = TRUE

/area/surface/outpost/main/dorms/dorm_1
	name = "\improper Main Outpost Dorm One"
	limit_mob_size = FALSE

/area/surface/outpost/main/dorms/dorm_2
	name = "\improper Main Outpost Dorm Two"
	limit_mob_size = FALSE

/area/surface/outpost/main/dorms/dorm_3
	name = "\improper Main Outpost Dorm Three"
	limit_mob_size = FALSE

/area/surface/outpost/main/dorms/dorm_4
	name = "\improper Main Outpost Dorm Four"
	limit_mob_size = FALSE

/area/surface/outpost/main/dorms/dorm_5
	name = "\improper Main Outpost Dorm Five"
	limit_mob_size = FALSE

/area/surface/outpost/main/dorms/dorm_6
	name = "\improper Main Outpost Dorm Six"
	limit_mob_size = FALSE

//TFF 5/5/20 - make rad protection great again!
/area/crew_quarters/cafeteria
	flags = RAD_SHIELDED

/area/crew_quarters/coffee_shop
	flags = RAD_SHIELDED

/area/crew_quarters/kitchen
	flags = RAD_SHIELDED

/area/crew_quarters/bar
	flags = RAD_SHIELDED

/area/crew_quarters/barrestroom
	flags = RAD_SHIELDED

/area/crew_quarters/sleep
	soundproofed = TRUE
	forbid_events = TRUE

/area/crew_quarters/sleep/vistor_room_1
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_2
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_3
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_4
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_5
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_6
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_7
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_8
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_9
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_10
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_11
	limit_mob_size = FALSE

/area/crew_quarters/sleep/vistor_room_12
	limit_mob_size = FALSE

/area/medical/cryo/autoresleeve
	name = "\improper Medical Autoresleeving"
	forbid_events = TRUE

/area/rnd/research/particleaccelerator
	name = "\improper Particle Accelerator Lab"
	icon_state = "toxlab"

// CC Expansion for more granular area control. Does nothing really, but allows differing ambience per-area.
/area/centcom
	name = "\improper CentCom"
	icon_state = "centcom"
	requires_power = 0
	dynamic_lighting = 1
	flags = AREA_FLAG_IS_NOT_PERSISTENT

/area/centcom/security
	name = "\improper CentCom Security"
	icon_state = "centcom_security"

/area/centcom/medical
	name = "\improper CentCom Medical"
	icon_state = "centcom_medical"

/area/centcom/medical/lobby
	name = "\improper CentCom Medbay Reception"

/area/centcom/medical/chemistry
	name = "\improper CentCom Medbay Chemistry"

/area/centcom/medical/storage
	name = "\improper CentCom Medbay Storage"

/area/centcom/medical/operating_room_1
	name = "\improper CentCom Medbay OR 1"

/area/centcom/medical/operating_room_2
	name = "\improper CentCom Medbay OR 2"

/area/centcom/medical/morgue
	name = "\improper CentCom Morgue"

/area/centcom/medical/morgue
	name = "\improper CentCom Morgue"

/area/centcom/command
	name = "\improper CentCom Command" //Central Command Command totally isn't RAS Syndrome in action.
	icon_state = "centcom_command"
	ambience = AMBIENCE_HIGHSEC

/area/centcom/ai
	name = "\improper CentCom AI" //Central Command Command totally isn't RAS Syndrome in action.
	icon_state = "centcom_command"
	ambience = AMBIENCE_HIGHSEC

/area/centcom/main_hall
	name = "\improper Main Hallway"
	icon_state = "centcom_hallway1"

/area/centcom/dorms
	name = "\improper Centcomm Dorms"
	icon_state = "centcom_crew"

/area/centcom/bar
	name = "\improper CentCom Bar"
	icon_state = "centcom_crew"

/area/centcom/kitchen
	name = "\improper CentCom Kitchen"
	icon_state = "centcom_crew"


/area/centcom/restaurant
	name = "\improper CentCom Restaurant"
	icon_state = "centcom_crew"

/area/centcom/bathroom
	name = "\improper CentCom Bathroom"
	icon_state = "centcom_crew"
	sound_env = SMALL_ENCLOSED

/area/centcom/garden
	name = "\improper CentCom Garden"
	icon_state = "centcom_crew"

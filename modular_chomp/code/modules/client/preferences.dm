/datum/preferences
	var/digitigrade = 0 // 0 = no digi, 1 = default, 2+ = digi styles... (Not used yet)

	var/job_other_low = 0
	var/job_other_med = 0
	var/job_other_high = 0

/client/verb/toggle_random_emote_pitch()
	set name = "Toggle Random Emote Pitch"
	set category = "Preferences"
	set desc = "Toggles whether or not emotes with sound you make will have random pitch."

	var/pref_path = /datum/client_preference/random_emote_pitch

	toggle_preference(pref_path)

	to_chat(src, "Audible emotes you make will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] have a random pitch applied to them.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TRandomEmotePitch") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/toggle_autotranscore()
	set name = "Toggle Automatic Transcore Notification"
	set category = "Preferences"
	set desc = "Toggles whether or not your death with a backup implant will automatically trigger a transcore notification after a few minutes."

	var/pref_path = /datum/client_preference/autotranscore

	toggle_preference(pref_path)

	to_chat(src, "Your death with a backup implant will [ (is_preference_enabled(pref_path)) ? "now" : "no longer"] trigger an automatic transcore notification.")

	SScharacter_setup.queue_preferences_save(prefs)

	feedback_add_details("admin_verb","TAutoTranscore") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/preferences/proc/vanity_copy_to(var/mob/living/carbon/human/character, var/copy_flavour = TRUE, var/copy_ooc_notes = FALSE, var/from_protean)
	//snowflake copy_to, does not copy anything but the vanity things
	/*
	name, nickname, flavour, OOC notes
	gender, sex
	custom species name, custom bodytype, weight, scale, scaling center, sound type, sound freq
	custom say verbs
	ears, wings, tail, hair, facial hair
	ears colors, wings colors, tail colors
	body color, prosthetics (if they have a prosthetic) (convert to DSI if protean and not prosthetic), eye color, hair color etc
	markings
	custom synth markings toggle, custom synth color toggle
	digitigrade
	blood color
	*/
	if(config.humans_need_surnames)
		var/firstspace = findtext(real_name, " ")
		var/name_length = length(real_name)
		if(!firstspace)	//we need a surname
			real_name += " [pick(last_names)]"
		else if(firstspace == name_length)
			real_name += "[pick(last_names)]"
	character.real_name = real_name
	character.name = character.real_name
	if(character.dna)
		character.dna.real_name = character.real_name
	character.nickname = nickname
	character.gender = biological_gender
	character.identifying_gender = identifying_gender

	character.r_eyes	= r_eyes
	character.g_eyes	= g_eyes
	character.b_eyes	= b_eyes
	character.h_style	= h_style
	character.r_hair	= r_hair
	character.g_hair	= g_hair
	character.b_hair	= b_hair
	character.r_grad	= r_grad
	character.g_grad	= g_grad
	character.b_grad	= b_grad
	character.f_style	= f_style
	character.r_facial	= r_facial
	character.g_facial	= g_facial
	character.b_facial	= b_facial
	character.r_skin	= r_skin
	character.g_skin	= g_skin
	character.b_skin	= b_skin
	character.s_tone	= s_tone
	character.h_style	= h_style
	character.grad_style= grad_style
	character.f_style	= f_style
	character.grad_style= grad_style
	character.b_type	= b_type
	character.synth_color = synth_color
	character.r_synth	= r_synth
	character.g_synth	= g_synth
	character.b_synth	= b_synth
	character.synth_markings = synth_markings

	var/list/ear_styles = get_available_styles(global.ear_styles_list)
	character.ear_style =  ear_styles[ear_style]
	character.r_ears =     r_ears
	character.b_ears =     b_ears
	character.g_ears =     g_ears
	character.r_ears2 =    r_ears2
	character.b_ears2 =    b_ears2
	character.g_ears2 =    g_ears2
	character.r_ears3 =    r_ears3
	character.b_ears3 =    b_ears3
	character.g_ears3 =    g_ears3

	var/list/tail_styles = get_available_styles(global.tail_styles_list)
	character.tail_style = tail_styles[tail_style]
	character.r_tail =     r_tail
	character.b_tail =     b_tail
	character.g_tail =     g_tail
	character.r_tail2 =    r_tail2
	character.b_tail2 =    b_tail2
	character.g_tail2 =    g_tail2
	character.r_tail3 =    r_tail3
	character.b_tail3 =    b_tail3
	character.g_tail3 =    g_tail3

	var/list/wing_styles = get_available_styles(global.wing_styles_list)
	character.wing_style = wing_styles[wing_style]
	character.r_wing =     r_wing
	character.b_wing =     b_wing
	character.g_wing =     g_wing
	character.r_wing2 =    r_wing2
	character.b_wing2 =    b_wing2
	character.g_wing2 =    g_wing2
	character.r_wing3 =    r_wing3
	character.b_wing3 =    b_wing3
	character.g_wing3 =    g_wing3

	character.set_gender(biological_gender)

	// Destroy/cyborgize organs and limbs.
	for(var/name in list(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM, BP_L_FOOT, BP_R_FOOT, BP_L_LEG, BP_R_LEG, BP_GROIN, BP_TORSO))
		var/status = organ_data[name]
		var/obj/item/organ/external/O = character.organs_by_name[name]
		if(O)
			if(status == "amputated")
				continue
			else if(status == "cyborg")
				replace_organ_with_prosthetic(character, name, rlimb_data[name])
			else
				if (from_protean)
					var/bodytype
					var/datum/species/selected_species = GLOB.all_species[species]
					if(selected_species.selects_bodytype)
						bodytype = custom_base
					else
						bodytype = selected_species.get_bodytype()


	for(var/name in list(O_HEART,O_EYES,O_VOICE,O_LUNGS,O_LIVER,O_KIDNEYS,O_SPLEEN,O_STOMACH,O_INTESTINE,O_BRAIN))
		var/status = organ_data[name]
		if(!status)
			continue
		var/obj/item/organ/I = character.internal_organs_by_name[name]
		if(istype(I, /obj/item/organ/internal/brain))
			var/obj/item/organ/external/E = character.get_organ(I.parent_organ)
			if(E.robotic < ORGAN_ASSISTED)
				continue
		if(I)
			if(status == "assisted")
				I.mechassist()
			else if(status == "mechanical")
				I.robotize()
			else if(status == "digital")
				I.digitize()

	for(var/N in character.organs_by_name)
		var/obj/item/organ/external/O = character.organs_by_name[N]
		O.markings.Cut()

	var/priority = 0
	for(var/M in body_markings)
		priority += 1
		var/datum/sprite_accessory/marking/mark_datum = body_marking_styles_list[M]
		var/mark_color = "[body_markings[M]]"

		for(var/BP in mark_datum.body_parts)
			var/obj/item/organ/external/O = character.organs_by_name[BP]
			if(O)
				O.markings[M] = list("color" = mark_color, "datum" = mark_datum, "priority" = priority)
	character.markings_len = priority

	var/list/last_descriptors = list()
	if(islist(body_descriptors))
		last_descriptors = body_descriptors.Copy()
	body_descriptors = list()

	var/datum/species/mob_species = GLOB.all_species[species]
	if(LAZYLEN(mob_species.descriptors))
		for(var/entry in mob_species.descriptors)
			var/datum/mob_descriptor/descriptor = mob_species.descriptors[entry]
			if(istype(descriptor))
				if(isnull(last_descriptors[entry]))
					body_descriptors[entry] = descriptor.default_value // Species datums have initial default value.
				else
					body_descriptors[entry] = CLAMP(last_descriptors[entry], 1, LAZYLEN(descriptor.standalone_value_descriptors))


	if(icon_updates)
		character.force_update_limbs()
		character.update_icons_body()
		character.update_mutations()
		character.update_underwear()
		character.update_hair()

/datum/preferences/proc/replace_organ_with_prosthetic(var/mob/living/carbon/human/character, var/part, var/company)
	if (!character || !part || !company)
		return
	var/obj/item/organ/external/eo = organs_by_name[choice]
	if(!eo || istype(eo, /obj/item/organ/external/stump))
		return
	eo.robotize(company)
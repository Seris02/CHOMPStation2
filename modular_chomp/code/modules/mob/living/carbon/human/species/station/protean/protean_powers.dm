//TODO: Replace ventcrawl with morphing. /mob/living/simple_mob/vore/hostile/morph
#define PER_LIMB_STEEL_COST SHEET_MATERIAL_AMOUNT
////
//  One-part Refactor
////
/mob/living/carbon/human/proc/nano_partswap()
	set name = "Ref - Single Limb"
	set desc = "Allows you to replace and reshape your limbs as you see fit."
	set category = "Abilities"
	set hidden = 1

	var/mob/living/caller = src
	if(temporary_form)
		caller = temporary_form
	if(nano_dead_check(caller))
		to_chat(caller, "<span class='warning'>You need to be repaired first before you can act!</span>")
		return
	if(stat)
		to_chat(caller,"<span class='warning'>You must be awake and standing to perform this action!</span>")
		return

	if(!isturf(caller.loc))
		to_chat(caller,"<span class='warning'>You need more space to perform this action!</span>")
		return

	var/obj/item/organ/internal/nano/refactory/refactory = nano_get_refactory()
	//Missing the organ that does this
	if(!istype(refactory))
		to_chat(caller,"<span class='warning'>You don't have a working refactory module!</span>")
		return

	var/choice = tgui_input_list(src,"Pick the bodypart to change:", "Refactor - One Bodypart", species.has_limbs)
	if(!choice)
		return

	//Organ is missing, needs restoring
	if(!organs_by_name[choice] || istype(organs_by_name[choice], /obj/item/organ/external/stump)) //allows limb stumps to regenerate like removed limbs.
		if(refactory.get_stored_material(MAT_STEEL) < PER_LIMB_STEEL_COST)
			to_chat(caller,"<span class='warning'>You're missing that limb, and need to store at least [PER_LIMB_STEEL_COST] steel to regenerate it.</span>")
			return
		var/regen = tgui_alert(caller,"That limb is missing, do you want to regenerate it in exchange for [PER_LIMB_STEEL_COST] steel?","Regenerate limb?",list("Yes","No"))
		if(regen != "Yes")
			return
		if(!refactory.use_stored_material(MAT_STEEL,PER_LIMB_STEEL_COST))
			return
		if(organs_by_name[choice])
			var/obj/item/organ/external/oldlimb = organs_by_name[choice]
			oldlimb.removed()
			qdel(oldlimb)
		var/mob/living/simple_mob/protean_blob/blob
		if(!temporary_form)
			blob = nano_intoblob()
		else
			blob = temporary_form
		active_regen = 1
		if(do_after(blob,50,exclusive = TASK_ALL_EXCLUSIVE))
			var/list/limblist = species.has_limbs[choice]
			var/limbpath = limblist["path"]
			var/obj/item/organ/external/new_eo = new limbpath(src)
			organs_by_name[choice] = new_eo
			new_eo.robotize(synthetic ? synthetic.company : null) //Use the base we started with
			new_eo.sync_colour_to_human(src)
			regenerate_icons()
		active_regen = 0
		return

	//Organ exists, let's reshape it
	var/list/usable_manufacturers = list()
	for(var/company in chargen_robolimbs)
		var/datum/robolimb/M = chargen_robolimbs[company]
		if(!(choice in M.parts))
			continue
		if(species?.base_species in M.species_cannot_use)
			continue
		if(M.whitelisted_to && !(ckey in M.whitelisted_to))
			continue
		usable_manufacturers[company] = M
	if(!usable_manufacturers.len)
		return
	var/manu_choice = tgui_input_list(caller, "Which manufacturer do you wish to mimic for this limb?", "Manufacturer for [choice]", usable_manufacturers)

	if(!manu_choice)
		return //Changed mind

	var/obj/item/organ/external/eo = organs_by_name[choice]
	if(!eo)
		return //Lost it meanwhile

	eo.robotize(manu_choice)
	update_icons_body()

/mob/living/carbon/human/proc/nano_regenerate()
	set name = "Total Reassembly"
	set desc = "Fully repair yourself or reload your appearance from whatever character slot you have loaded."
	set category = "Abilities"
	set hidden = 1
	var/mob/living/caller = src
	if(temporary_form)
		caller = temporary_form
	var/input = tgui_alert(caller,{"Do you want to rebuild or reassemble yourself?
	Rebuilding will cost 10,000 steel and will rebuild all of your limbs as well as repair all damage over a 40s period.
	Reassembling costs no steel and will copy the appearance data of your currently loaded save slot."},"Reassembly",list("Rebuild","Reassemble","Cancel"))
	if(input == "Cancel" || !input)
		return
	if(input == "Rebuild")
		var/obj/item/organ/internal/nano/refactory/refactory = nano_get_refactory()
		if(refactory.get_stored_material(MAT_STEEL) >= 10000)
			to_chat(caller, "<span class='notify'>You begin to rebuild. You will need to remain still.</span>")
			if(do_after(caller, 400,exclusive = TASK_ALL_EXCLUSIVE))
				if(species?:OurRig)	//Unsafe, but we should only ever be using this with a Protean
					species?:OurRig?:make_alive(src,1)	//Re-using this proc
					refactory.use_stored_material(MAT_STEEL,refactory.get_stored_material(MAT_STEEL))	//Use all of our steel
				else
					to_chat(caller, "<span class='usrdanger'>Somehow, you are missing your protean rig. You are unable to rebuild without one.</span>")
		else
			to_chat(caller, "<span class='warning'>You do not have enough steel stored for this operation.</span>")
	else
		input = tgui_alert(caller,{"Include Flavourtext?"},"Reassembly",list("Yes","No","Cancel"))
		if(input == "Cancel" || !input)
			return
		var/flavour = 0
		if(input == "Yes")
			flavour = 1
		input = tgui_alert(caller,{"Include OOC notes?"},"Reassembly",list("Yes","No","Cancel"))
		if(input == "Cancel" || !input)
			return
		var/oocnotes = 0
		if(input == "Yes")
			oocnotes = 1
		to_chat(caller, "<span class='notify'>You begin to reassemble. You will need to remain still.</span>")
		caller.visible_message("<span class='notify'>[caller] rapidly contorts and shifts!</span>", "<span class='danger'>You begin to reassemble.</span>")
		if(do_after(caller, 40,exclusive = TASK_ALL_EXCLUSIVE))
			if(client.prefs)	//Make sure we didn't d/c
				var/obj/item/weapon/rig/protean/Rig = species?:OurRig
				caller.client?.prefs?.vanity_copy_to(caller, FALSE, flavour, oocnotes, TRUE)
				species?:OurRig = Rig	//Get a reference to our Rig and put it back after reassembling
				caller.visible_message("<span class='notify'>[caller] adopts a new form!</span>", "<span class='danger'>You have reassembled.</span>")

////
//  Storing metal
////
/mob/living/carbon/human/proc/nano_metalnom()
	set name = "Ref - Store Metals"
	set desc = "If you're holding a stack of material, you can consume some and store it for later."
	set category = "Abilities"
	set hidden = 1

	var/mob/living/caller = src
	if(temporary_form)
		caller = temporary_form
	if(nano_dead_check(caller))
		to_chat(caller, "<span class='warning'>You need to be repaired first before you can act!</span>")
		return

	var/obj/item/organ/internal/nano/refactory/refactory = nano_get_refactory()
	//Missing the organ that does this
	if(!istype(refactory))
		to_chat(caller,"<span class='warning'>You don't have a working refactory module!</span>")
		return

	var/held = caller.get_active_hand()
	if(!istype(held,/obj/item/stack/material))
		to_chat(caller,"<span class='warning'>You aren't holding a stack of materials in your active hand!</span>")
		return

	var/obj/item/stack/material/matstack = held
	var/substance = matstack.material.name
	var allowed = 0
	for(var/material in PROTEAN_EDIBLE_MATERIALS)
		if(material == substance) allowed = 1
	if(!allowed)
		to_chat(caller,"<span class='warning'>You can't process [substance]!</span>")
		return

	var/howmuch = tgui_input_number(caller,"How much do you want to store? (0-[matstack.get_amount()])","Select amount",null,matstack.get_amount(),0)
	if(!howmuch || matstack != caller.get_active_hand() || howmuch > matstack.get_amount())
		return //Quietly fail

	var/actually_added = refactory.add_stored_material(substance,howmuch*matstack.perunit)
	matstack.use(CEILING((actually_added/matstack.perunit), 1))
	if(actually_added && actually_added < howmuch)
		to_chat(caller,"<span class='warning'>Your refactory module is now full, so only [actually_added] units were stored.</span>")
		visible_message("<span class='notice'>[caller] nibbles some of the [substance] right off the stack!</span>")
	else if(actually_added)
		to_chat(caller,"<span class='notice'>You store [actually_added] units of [substance].</span>")
		visible_message("<span class='notice'>[caller] devours some of the [substance] right off the stack!</span>")
	else
		to_chat(caller,"<span class='notice'>You're completely capped out on [substance]!</span>")

////
//  Blob Form
////
/mob/living/carbon/human/proc/nano_blobform(var/forced)
	set name = "Toggle Blobform"
	set desc = "Switch between amorphous and humanoid forms."
	set category = "Abilities"
	set hidden = 1

	if(nano_dead_check(src))
		return
	if(forced)
		if(temporary_form)
			nano_outofblob(temporary_form, forced)
		else
			nano_intoblob(forced)
		return
	var/atom/movable/to_locate = temporary_form || src
	if(!isturf(to_locate.loc) && !forced)
		to_chat(to_locate,"<span class='warning'>You need more space to perform this action!</span>")
		return
	//Blob form
	if(temporary_form)
		if(temporary_form.stat)
			to_chat(temporary_form,"<span class='warning'>You can only do this while not stunned.</span>")
		else
			nano_outofblob(temporary_form)

	//Human form
	else if(stat)
		to_chat(src,"<span class='warning'>You can only do this while not stunned.</span>")
		return
	else if(handcuffed)
		to_chat(src, "<span class='warning'>You can't do this while handcuffed!</span>")
		return
	else
		nano_intoblob()

////
//  Change fitting
////
/mob/living/carbon/human/proc/nano_change_fitting()
	set name = "Change Species Fit"
	set desc = "Tweak your shape to change what suits you fit into (and their sprites!)."
	set category = "Abilities"

	if(stat)
		to_chat(src,"<span class='warning'>You must be awake and standing to perform this action!</span>")
		return

	var/new_species = tgui_input_list(usr, "Please select a species to emulate.", "Shapeshifter Body", GLOB.playable_species)
	if(new_species)
		species?.base_species = new_species // Really though you better have a species
		regenerate_icons() //Expensive, but we need to recrunch all the icons we're wearing

////
//	Rig Transform
////
/mob/living/carbon/human/proc/nano_rig_transform(var/forced)
	set name = "Modify Form - Hardsuit"
	set desc = "Allows a protean to retract its mass into its hardsuit module at will."
	set category = "Abilities"
	set hidden = 1

	var/mob/living/caller = src
	if(temporary_form)
		caller = temporary_form
	if(nano_dead_check(src))
		to_chat(caller, "<span class='warning'>You need to be repaired first before you can act!</span>")
		return
	to_chat(src, "<span class='notice'>You rapidly condense into your module.</span>")
	if(forced || do_after(caller,20,exclusive = TASK_ALL_EXCLUSIVE))
		if(!temporary_form)	//If you're human, force you into blob form before rig'ing
			nano_blobform(forced)
		spawn(2)

		if(istype(src.species, /datum/species/protean))
			var/datum/species/protean/S = src.species
			var/mob/living/simple_mob/protean_blob/P = temporary_form
			if(S.OurRig) //Do we even have a RIG?
				if(P.loc == S.OurRig)	//we're inside our own RIG
					if(ismob(S.OurRig.loc))
						var/mob/m = S.OurRig.loc
						m.drop_from_inventory(S.OurRig)
					if(S.OurRig.wearer) //We're being worn. Engulf em', if prefs align.. otherwise just drop off.
						var/mob/living/carbon/human/victim = S.OurRig.wearer
						if(P.can_be_drop_pred && victim.devourable && victim.can_be_drop_prey)
							if(P.vore_selected)
								perform_the_nom(P,victim,P,P.vore_selected,1)
					P.forceMove(get_turf(S.OurRig))
					S.OurRig.forceMove(src)
					S.OurRig.myprotean = src
					src.equip_to_slot_if_possible(S.OurRig, slot_back)
					S.OurRig.Moved()
					P.has_hands = 1
				else	//We're not in our own RIG
					if(P.stat || P.resting && !forced)
						to_chat(P,"<span class='warning'>You can only do this while not stunned.</span>")
					else
						if(P.l_hand)
							P.drop_l_hand()
						if(P.r_hand)
							P.drop_r_hand()
						P.has_hands = 0
						S.OurRig.myprotean = P
						src.drop_from_inventory(S.OurRig)
						P.forceMove(S.OurRig)
						S.OurRig.canremove = 1
				P.reset_view()
			else	//Make one if not
				to_chat(temporary_form, "<span class='warning'>Somehow, your RIG got disconnected from your species. This may have been caused by an admin heal. A new one has been created for you, contact a coder.</span>")
				new /obj/item/weapon/rig/protean(src,src)
	else
		to_chat(src, "<span class='warning'>You must remain still to condense!</span>")

/mob/living/carbon/human/proc/appearance_switch()
	set name = "Switch Blob Appearance"
	set desc = "Allows a protean blob to switch its outwards appearance."
	set category = "Abilities"
	set hidden = 1
	var/datum/species/protean/S = src.species
	var/mob/living/caller = src
	if(temporary_form)
		caller = temporary_form
	var/blobstyle = input(caller, "Which blob style would you like?") in list("Red and Blue Stars", "Blue Star", "Plain", "Catslug", "Pai Cat")
	switch(blobstyle)
		if("Red and Blue Stars")
			S.blob_appearance = "puddle2"
		if("Blue Star")
			S.blob_appearance = "puddle1"
		if("Plain")
			S.blob_appearance = "puddle0"
		if("Catslug")
			S.blob_appearance = "catslug"
		if("Pai Cat")
			S.blob_appearance = "pai-cat"
	if(temporary_form)
		if(blobstyle)
			temporary_form.icon_living = S.blob_appearance
			temporary_form.item_state = S.blob_appearance
			temporary_form.icon_rest = S.blob_appearance + "_rest"
			temporary_form.update_icon()
			if(istype(temporary_form.loc, /obj/item/weapon/holder/protoblob))
				var/obj/item/weapon/holder/protoblob/PB = temporary_form.loc
				PB.item_state = S.blob_appearance

/mob/living/carbon/human/proc/nano_latch()
	set name = "Latch/Unlatch host"
	set desc = "Allows a protean to forcibly latch or unlatch from a host."
	set category = "Abilities"
	set hidden = 1
	var/mob/living/caller = src
	var/mob/living/carbon/human/target
	var/datum/species/protean/S = src.species
	if(nano_dead_check(src))
		return
	if(temporary_form)
		caller = temporary_form
		if(caller.loc == S.OurRig)
			target = S.OurRig.wearer
			if(target)
				target.drop_from_inventory(S.OurRig)
				to_chat(caller, "<span class='notice'>You detach from your host.</span>")
			else
				to_chat(caller, "<span class='warning'>You aren't being worn, dummy.</span>")
			return
	var/obj/held_item = caller.get_active_hand()
	if(istype(held_item,/obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = held_item
		if(istype(G.affecting, /mob/living/carbon/human))
			target = G.affecting
			if(istype(target.species, /datum/species/protean))
				to_chat(caller, "<span class='danger'>You can't latch onto a fellow Protean!</span>")
				return
			if(G.loc == caller && G.state >= GRAB_AGGRESSIVE)
				caller.visible_message("<span class='warning'>[caller] is attempting to latch onto [target]!</span>", "<span class='danger'>You attempt to latch onto [target]!</span>")
				if(do_after(caller, 50, target,exclusive = TASK_ALL_EXCLUSIVE))
					if(G.loc == caller && G.state >= GRAB_AGGRESSIVE)
						target.drop_from_inventory(target.back)
						caller.visible_message("<span class='danger'>[caller] latched onto [target]!</span>", "<span class='danger'>You latch yourself onto [target]!</span>")
						target.Weaken(3)
						nano_rig_transform(1)
						spawn(5)	//Have to give time for the above proc to resolve
						//S.OurRig.forceMove(target)
						target.equip_to_slot(S.OurRig, slot_back)
						S.OurRig.Moved()
						spawn(1)	//Same here :(
						S.OurRig.wearer = target
			else
				to_chat(caller, "<span class='warning'>You need a more aggressive grab to do this!</span>")
		else
			to_chat(caller, "<span class='warning'>You can only latch onto humanoid mobs!</span>")
	else
		to_chat(caller, "<span class='warning'>You need to be grabbing a humanoid mob aggressively to latch onto them.</span>")

/// /// /// A helper to reuse
/mob/living/proc/nano_get_refactory(obj/item/organ/internal/nano/refactory/R)
	if(istype(R))
		if(!(R.status & ORGAN_DEAD))
			return R
	return

/mob/living/simple_mob/protean_blob/nano_get_refactory()
	if(refactory)
		return ..(refactory)
	if(humanform)
		return humanform.nano_get_refactory()

/mob/living/carbon/human/nano_get_refactory()
	return ..(locate(/obj/item/organ/internal/nano/refactory) in internal_organs)

//I hate this whole bit but I want proteans to be able to "die" and still be "alive" in their blob as a suit
/mob/living/carbon/human/proc/nano_dead_check(var/mob/living/caller)
	if(istype(src.species, /datum/species/protean))
		var/datum/species/protean/S = src.species
		if(S.pseudodead)
			return 1
	return 0

/mob/living/carbon/human/proc/nano_set_dead(var/num)
	if(istype(src.species, /datum/species/protean))
		var/datum/species/protean/S = src.species
		S.pseudodead = num

/// /// /// Ability objects for stat panel
/obj/effect/protean_ability
	name = "Activate"
	desc = ""
	icon = 'modular_chomp/icons/mob/species/protean/protean_powers.dmi'
	var/ability_name
	var/to_call

/obj/effect/protean_ability/proc/atom_button_text()
	return src

/obj/effect/protean_ability/Click(var/location, var/control, var/params)
	var/list/clickprops = params2list(params)
	var/opts = clickprops["shift"]

	if(opts)
		to_chat(usr,"<span class='notice'><b>[ability_name]</b> - [desc]</span>")
	else
		//Humanform using it
		if(ishuman(usr))
			do_ability(usr)
		//Blobform using it
		else
			var/mob/living/simple_mob/protean_blob/blob = usr
			do_ability(blob.humanform)

/obj/effect/protean_ability/proc/do_ability(var/mob/living/L)
	if(istype(L))
		call(L,to_call)()
	return 0

/// The actual abilities
/obj/effect/protean_ability/into_blob
	ability_name = "Toggle Blobform"
	desc = "Discard your shape entirely, changing to a low-energy blob. You'll consume steel to repair yourself in this form."
	icon_state = "blob"
	to_call = /mob/living/carbon/human/proc/nano_blobform

/obj/effect/protean_ability/change_volume
	ability_name = "Change Volume"
	desc = "Alter your size between 25% and 200%."
	icon_state = "volume"
	to_call = /mob/living/proc/set_size

/obj/effect/protean_ability/reform_limb
	ability_name = "Ref - Single Limb"
	desc = "Rebuild or replace a single limb, assuming you have 2000 steel."
	icon_state = "limb"
	to_call = /mob/living/carbon/human/proc/nano_partswap

/obj/effect/protean_ability/reform_body
	ability_name = "Total Reassembly"
	desc = "Fully repair yourself or reload your appearance from whatever character slot you have loaded."
	icon_state = "body"
	to_call = /mob/living/carbon/human/proc/nano_regenerate

/obj/effect/protean_ability/metal_nom
	ability_name = "Ref - Store Metals"
	desc = "Store the metal you're holding. Your refactory can only store steel."
	icon_state = "metal"
	to_call = /mob/living/carbon/human/proc/nano_metalnom

/obj/effect/protean_ability/hardsuit
	ability_name = "Hardsuit Transform"
	desc = "Coalesce your nanite swarm into their control module, allowing others to wear you."
	icon_state = "rig"
	to_call = /mob/living/carbon/human/proc/nano_rig_transform

/obj/effect/protean_ability/appearance_switch
	ability_name = "Blob Appearance"
	desc = "Toggle your blob appearance. Also affects your worn appearance."
	icon_state = "switch"
	to_call = /mob/living/carbon/human/proc/appearance_switch

/obj/effect/protean_ability/latch_host
	ability_name = "Latch Host"
	desc = "Forcibly latch or unlatch your RIG from a host mob."
	icon_state = "latch"
	to_call = /mob/living/carbon/human/proc/nano_latch

#undef PER_LIMB_STEEL_COST

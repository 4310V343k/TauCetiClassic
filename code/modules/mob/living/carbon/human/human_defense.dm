#define PROTECTION_TO_MULTIPLE(p) ((100 - min(p, 100)) * 0.01)
/mob/living/carbon/proc/can_catch_item()
	if(!in_throw_mode)
		return
	if(incapacitated())
		return
	if(get_active_hand()) // yes, it returns thing in the hand, not the hand (#10051)
		return
	return TRUE

/mob/living/carbon/human/hitby(atom/movable/AM, datum/thrownthing/throwingdatum)
	if(isitem(AM) && throwingdatum.speed < 5 && can_catch_item())
		var/obj/item/I = AM
		do_attack_animation(I, has_effect = FALSE)
		put_in_active_hand(I)
		visible_message("<span class='notice'>[src] catches [I].</span>", "<span class='notice'>You catch [I] in mid-air!</span>")
		throw_mode_off()
		return TRUE // aborts throw_impact

	..()
	if(!ismob(AM))
		return

	//should be non-negative
	var/size_diff_calculate = AM.w_class - w_class
	if(size_diff_calculate < 0)
		return
	var/weight_diff_coef = 1 + sqrt(size_diff_calculate)
	if(shoes?.flags & AIR_FLOW_PROTECT || wear_suit?.flags & AIR_FLOW_PROTECT)
		adjustHalLoss(15 * weight_diff_coef)	//thicc landing
	else
		AdjustWeakened(2 * weight_diff_coef)	//4 seconds is default slip
	visible_message("<span class='warning'>[AM] falls on [src].</span>",
					"<span class='warning'>[AM] falls on you!</span>",
					"<span class='notice'>You hear something heavy fall.</span>")

/mob/living/carbon/human/prob_miss(obj/item/projectile/P)
	var/def_zone = get_zone_with_miss_chance(P.def_zone, src, P.get_miss_modifier())
	if(!def_zone)
		return TRUE
	def_zone = check_zone(def_zone)
	if(!has_bodypart(def_zone))
		return TRUE
	P.def_zone = def_zone // a bit junky, but it will either bump this one, or bump object
	return FALSE

/mob/living/carbon/human/mob_bullet_act(obj/item/projectile/P, def_zone)
	. = PROJECTILE_ALL_OK

	if(!(P.original == src && P.firer == src)) //can't block or reflect when shooting yourself
		if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam) || istype(P, /obj/item/projectile/pyrometer) || (istype(P, /obj/item/projectile/plasma) && P.damage <= 20))
			if(check_reflect(def_zone, dir, P.dir)) // Checks if you've passed a reflection% check
				visible_message("<span class='danger'>The [P.name] gets reflected by [src]!</span>", \
								"<span class='userdanger'>The [P.name] gets reflected by [src]!</span>")
				// Find a turf near or on the original location to bounce to
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.redirect(new_x, new_y, curloc, src)

				return PROJECTILE_FORCE_MISS // complete projectile permutation

	if(istype(P, /obj/item/projectile/bullet/weakbullet))
		var/armor = run_armor_check(def_zone, BULLET)
		apply_effect(P.agony, AGONY, armor)
		apply_damage(P.damage, P.damage_type, def_zone, (armor * P.armor_multiplier), P.flags, P)
		if(istype(wear_suit, /obj/item/clothing/suit))
			var/obj/item/clothing/suit/V = wear_suit
			V.attack_reaction(src, REACTION_HIT_BY_BULLET)
		return PROJECTILE_ACTED

	if(istype(P, /obj/item/projectile/energy/electrode) || istype(P, /obj/item/projectile/beam/stun) || istype(P, /obj/item/projectile/bullet/stunshot))
		var/obj/item/organ/external/BP = get_bodypart(def_zone) // We're checking the outside, buddy!
		P.agony *= get_siemens_coefficient_organ(BP) * P.armor_multiplier
		P.stun *=  get_siemens_coefficient_organ(BP) * P.armor_multiplier
		P.weaken *=  get_siemens_coefficient_organ(BP) * P.armor_multiplier
		P.stutter *=  get_siemens_coefficient_organ(BP) * P.armor_multiplier

		if(P.agony) // No effect against full protection.
			if(prob(max(P.agony, 20)))
				var/obj/item/hand = get_active_hand()
				if(hand && !(hand.flags & ABSTRACT))
					drop_item()
		P.on_hit(src)
		if(istype(wear_suit, /obj/item/clothing/suit))
			var/obj/item/clothing/suit/V = wear_suit
			V.attack_reaction(src, REACTION_HIT_BY_BULLET)
		return PROJECTILE_ACTED

	if(istype(P, /obj/item/projectile/energy/bolt))
		var/obj/item/organ/external/BP = get_bodypart(def_zone) // We're checking the outside, buddy!
		var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
		for(var/bp in body_parts) //Make an unregulated var to pass around.
			if(!bp)
				continue //Does this thing we're shooting even exist?
			if(bp && istype(bp ,/obj/item/clothing)) // If it exists, and it's clothed
				var/obj/item/clothing/C = bp // Then call an argument C to be that clothing!
				if(C.pierce_protection & BP.body_part) // Is that body part being targeted covered?
					visible_message("<span class='userdanger'>The [P.name] gets absorbed by [src]'s [C.name]!</span>")
					return PROJECTILE_ACTED

		BP = bodyparts_by_name[check_zone(def_zone)]
		var/armorblock = run_armor_check(BP, ENERGY)
		apply_damage(P.damage, P.damage_type, BP, armorblock, P.damage_flags(), P)
		apply_effects(P.stun,P.weaken,0,0,P.stutter,0,0,armorblock)
		to_chat(src, "<span class='userdanger'>You have been shot!</span>")
		if(istype(wear_suit, /obj/item/clothing/suit))
			var/obj/item/clothing/suit/V = wear_suit
			V.attack_reaction(src, REACTION_HIT_BY_BULLET)
		return PROJECTILE_ACTED

	if(istype(P, /obj/item/projectile/bullet))
		var/obj/item/projectile/bullet/B = P

		var/obj/item/organ/external/BP = bodyparts_by_name[check_zone(def_zone)]
		var/armor  = 100 - get_protection_multiple_organ(BP, BULLET) * 100

		var/delta = max(0, P.damage - P.damage * armor)
		if(delta)
			apply_effect(delta,AGONY,armor)
			//return Nope! ~Zve
		if(delta < 10)
			P.sharp = 0
			P.embed = 0

		if(B.stoping_power)
			var/force =  (armor/P.damage)*100
			if (force <= 60 && force > 40)
				apply_effects(B.stoping_power/2,B.stoping_power/2,0,0,B.stoping_power/2,0,0,armor)
			else if(force <= 40)
				apply_effects(B.stoping_power,B.stoping_power,0,0,B.stoping_power,0,0,armor)

		if(!HAS_TRAIT(src, TRAIT_NO_EMBED) && P.embed && prob(20 + max(P.damage - armor, -20)) && P.damage_type == BRUTE)
			var/obj/item/weapon/shard/shrapnel/SP = new()
			SP.name = "[P.name] shrapnel"
			SP.desc = "[SP.desc] It looks like it was fired from [P.shot_from]."
			SP.loc = BP
			BP.embed(SP)

	if(istype(wear_suit, /obj/item/clothing/suit))
		var/obj/item/clothing/suit/V = wear_suit
		V.attack_reaction(src, REACTION_HIT_BY_BULLET)

/mob/living/carbon/human/proc/check_reflect(def_zone, hol_dir, hit_dir) //Reflection checks for anything in your l_hand, r_hand, or wear_suit based on the reflection chance of the object
	if(head && head.IsReflect(def_zone, hol_dir, hit_dir))
		return TRUE
	if(wear_suit && wear_suit.IsReflect(def_zone, hol_dir, hit_dir))
		return TRUE
	if(l_hand && l_hand.IsReflect(def_zone, hol_dir, hit_dir))
		return TRUE
	if(r_hand && r_hand.IsReflect(def_zone, hol_dir, hit_dir))
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/is_in_space_suit(only_helmet = FALSE) //Wearing human full space suit (or only space helmet)?
	if(!head || !(only_helmet || wear_suit))
		return FALSE
	if(istype(head, /obj/item/clothing/head/helmet/space) && (only_helmet || istype(wear_suit, /obj/item/clothing/suit/space)))
		return TRUE
	return FALSE

/mob/living/carbon/human/getarmor(def_zone, type)
	var/armorval = 0
	var/organnum = 0

	if(def_zone)
		if(isbodypart(def_zone))
			return 100 - get_protection_multiple_organ(def_zone, type) * 100
		var/obj/item/organ/external/BP = get_bodypart(def_zone)
		return 100 - get_protection_multiple_organ(BP, type) * 100
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/obj/item/organ/external/BP in bodyparts)
		armorval += 100 - get_protection_multiple_organ(BP, type) * 100
		organnum++
	return (armorval/max(organnum, 1))

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/carbon/human/proc/get_siemens_coefficient_organ(obj/item/organ/external/BP)
	var/siemens_coefficient = 1.0

	if(!BP)
		if(HAS_TRAIT(src, TRAIT_CONDUCT))
			siemens_coefficient++
		return siemens_coefficient

	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
	for(var/obj/item/clothing/C in clothing_items)
		if(!istype(C))	//is this necessary?
			continue
		else if(C.body_parts_covered & BP.body_part) // Is that body part being targeted covered?
			if(C.wet)
				siemens_coefficient = 3.0
				var/turf/T = get_turf(src)
				var/obj/effect/fluid/F = locate() in T
				if(F)
					F.electrocute_act(60)
			siemens_coefficient *= C.siemens_coefficient
	if(HAS_TRAIT(src, TRAIT_CONDUCT))
		siemens_coefficient++
	return siemens_coefficient

//this proc returns the armour value for a particular external organ.
/mob/living/carbon/human/proc/get_protection_multiple_organ(obj/item/organ/external/BP, type)
	if(!type || !BP)
		return 0
	var/protection = 1
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	protection *= PROTECTION_TO_MULTIPLE(BP.pumped * 0.3)
	for(var/obj/item/clothing/C in protective_gear)
		if(C.body_parts_covered & BP.body_part)
			protection *= PROTECTION_TO_MULTIPLE(C.armor[type])

	return protection

/mob/living/carbon/human/proc/check_head_coverage()

	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & HEAD)
				return 1
	return 0

/mob/living/carbon/human/check_shields(atom/attacker, damage = 0, attack_text = "the attack", hit_dir = 0)
	. = ..()
	if(.)
		return

	if(l_hand && istype(l_hand, /obj/item/weapon))//Current base is the prob(50-d/3)
		var/obj/item/weapon/I = l_hand
		if( (!hit_dir || is_the_opposite_dir(dir, hit_dir)) && prob(I.Get_shield_chance() - round(damage / 3) ))
			visible_message("<span class='userdanger'>[src] blocks [attack_text] with the [l_hand.name]!</span>")
			return 1
	if(r_hand && istype(r_hand, /obj/item/weapon))
		var/obj/item/weapon/I = r_hand
		if( (!hit_dir || is_the_opposite_dir(dir, hit_dir)) && prob(I.Get_shield_chance() - round(damage / 3) ))
			visible_message("<span class='userdanger'>[src] blocks [attack_text] with the [r_hand.name]!</span>")
			return 1
	if(wear_suit && isitem(wear_suit))
		var/obj/item/clothing/suit/armor/vest/reactive/R = wear_suit
		if(prob(R.Get_shield_chance() - round(damage / 3) ))
			R.teleport_user(6, src, attack_text)

/mob/living/carbon/human/emp_act(severity)
	for(var/obj/O in src)
		if(!O)
			continue
		O.emplode(severity)
	for(var/obj/item/organ/external/BP in bodyparts)
		if(BP.is_stump)
			continue
		BP.emplode(severity)
		for(var/obj/item/organ/internal/IO in BP.bodypart_organs)
			if(IO.robotic == 0)
				continue
			IO.emplode(severity)
	..()


/mob/living/carbon/human/attacked_by(obj/item/I, mob/living/user, def_zone)
	if(!I || !user)
		return FALSE

	var/obj/item/organ/external/BP = get_bodypart(def_zone)
	if(!BP || BP.is_stump)
		to_chat(user, "What [parse_zone(def_zone)]?")
		return FALSE
	var/hit_area = BP.name

	if(istype(I,/obj/item/weapon/card/emag))
		if(!BP.is_robotic())
			to_chat(user, "<span class='userdanger'>That limb isn't robotic.</span>")
			return
		if(BP.sabotaged)
			to_chat(user, "<span class='userdanger'>[src]'s [BP.name] is already sabotaged!</span>")
		else
			to_chat(user, "<span class='userdanger'>You sneakily slide [I] into the dataport on [src]'s [BP.name] and short out the safeties.</span>")
			var/obj/item/weapon/card/emag/emag = I
			emag.uses--
			BP.sabotaged = 1
		return TRUE

	var/list/alt_alpperances_vieawers
	if(I.alternate_appearances)
		for(var/key in I.alternate_appearances)
			var/datum/atom_hud/alternate_appearance/AA = I.alternate_appearances[key]
			if(!AA.alternate_obj || !istype(AA.alternate_obj, /obj))
				continue
			var/obj/alternate_obj = AA.alternate_obj
			alt_alpperances_vieawers = list()
			for(var/mob/alt_viewer in viewers(src))
				if(!alt_viewer.client || !(alt_viewer in AA.hudusers))
					continue
				alt_alpperances_vieawers += alt_viewer
				alt_viewer.show_message("<span class='userdanger'>[src] has been attacked in the [hit_area] with [alternate_obj.name] by [user]!</span>", SHOWMSG_VISUAL)

	if(I.attack_verb.len)
		visible_message("<span class='userdanger'>[src] has been [pick(I.attack_verb)] in the [hit_area] with [I.name] by [user]!</span>", ignored_mobs = alt_alpperances_vieawers)
	else
		visible_message("<span class='userdanger'>[src] has been attacked in the [hit_area] with [I.name] by [user]!</span>", ignored_mobs = alt_alpperances_vieawers)

	var/armor = run_armor_check(BP, MELEE, "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].")
	if(armor >= 100)
		return FALSE
	if(!I.force)
		return TRUE

	//Apply weapon damage
	var/force_with_melee_skill = apply_skill_bonus(user, I.force, list(/datum/skill/melee = SKILL_LEVEL_NOVICE), 0.15) // +15% for each melee level
	var/damage_flags = I.damage_flags()
	if(prob(armor))
		damage_flags &= ~(DAM_SHARP | DAM_EDGE)

	var/datum/wound/created_wound = apply_damage(force_with_melee_skill, I.damtype, BP, armor, damage_flags, I)

	//Melee weapon embedded object code.
	if(I.damtype == BRUTE && !I.anchored && I.can_embed && !I.is_robot_module())
		var/weapon_sharp = (damage_flags & DAM_SHARP)
		var/damage = force_with_melee_skill // just the effective damage used for sorting out embedding, no further damage is applied here
		if (armor)
			damage *= blocked_mult(armor)

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = weapon_sharp ? (damage / (I.w_class / 2)) : (damage / (I.w_class * 3))
		var/embed_threshold = weapon_sharp ? (5 * I.w_class) : (15 * I.w_class)

		//Sharp objects will always embed if they do enough damage.
		if((weapon_sharp && damage > (10 * I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
			BP.embed(I, null, null, created_wound)

	var/bloody = 0
	if(((I.damtype == BRUTE) || (I.damtype == HALLOSS)) && prob(25 + (force_with_melee_skill * 2)))
		I.add_blood(src)	//Make the weapon bloody, not the person.
		if(prob(33))
			bloody = 1
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
					H.bloody_body(src)
					H.bloody_hands(src)

		switch(hit_area)
			if(BP_HEAD)//Harder to score a stun but if you do it lasts a bit longer
				if(prob(force_with_melee_skill * (100 - armor) / 100))
					apply_effect(20, PARALYZE, armor)
					visible_message("<span class='userdanger'>[src] has been knocked unconscious!</span>")

				if(bloody)//Apply blood
					if(wear_mask)
						wear_mask.add_blood(src)
					if(head)
						head.add_blood(src)
					if(glasses && prob(33))
						glasses.add_blood(src)

			if(BP_CHEST)//Easier to score a stun but lasts less time
				if(prob((10 + force_with_melee_skill) * (100 - armor) / 100))
					apply_effect(5, WEAKEN, armor)
					visible_message("<span class='userdanger'>[src] has been knocked down!</span>")

				if(!(damage_flags & (DAM_SHARP|DAM_EDGE)) && prob(I.force + 10)) // A chance to force puke with a blunt hit.
					for(var/obj/item/weapon/grab/G in grabbed_by)
						if(G.state >= GRAB_AGGRESSIVE && G.assailant == user)
							vomit(punched=TRUE)
							return

				if(bloody)
					bloody_body(src)
	return TRUE

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/resolve_thrown_attack(obj/O, throw_damage, dtype, zone)

	var/hit_area = parse_zone(zone)
	visible_message("<span class='warning'>[src] has been hit in the [hit_area] by [O].</span>")

	var/armor = run_armor_check(zone, MELEE, "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].") //I guess MELEE is the best fit here
	..(O, throw_damage, dtype, zone, armor)

/mob/living/carbon/human/embed(obj/item/I, zone, created_wound)
	if(HAS_TRAIT(src, TRAIT_NO_EMBED))
		return

	if(!zone)
		return ..()

	var/obj/item/organ/external/BP = get_bodypart(zone)

	BP.embed(I, null, null, created_wound)

/mob/living/carbon/human/bloody_hands(mob/living/carbon/human/source, amount = 2)
	if (gloves)
		if(istype(gloves, /obj/item/clothing/gloves))
			var/obj/item/clothing/gloves/GL = gloves
			GL.add_blood(source)
			GL.dirt_transfers += amount
	else
		add_blood(source)
		dirty_hands_transfers += amount

/mob/living/carbon/human/bloody_body(mob/living/carbon/human/source)
	if(wear_suit)
		wear_suit.add_blood(source)
	if(w_uniform)
		w_uniform.add_blood(source)

/mob/living/carbon/human/crawl_in_blood(datum/dirt_cover/dirt_cover)
	if(wear_suit)
		wear_suit.add_dirt_cover(dirt_cover)
	if(w_uniform)
		w_uniform.add_dirt_cover(dirt_cover)
	if (gloves)
		gloves.add_dirt_cover(dirt_cover)
	else
		add_dirt_cover(dirt_cover)

/mob/living/carbon/proc/check_pierce_protection(obj/item/organ/external/BP, target_zone)
	return 0

/mob/living/carbon/human/check_pierce_protection(obj/item/organ/external/BP, target_zone)
	if(target_zone)
		BP = get_bodypart(target_zone)

	if(!BP || (BP.is_stump))
		return NOLIMB

	var/list/items = get_equipped_items() - list(l_hand, r_hand)
	for(var/obj/item/clothing/C in items)
		if(C.pierce_protection & BP.body_part)
			if(C.flags & PHORONGUARD) // this means, clothes has injection port or smthing like that.
				return PHORONGUARD // space suits and so on. (well, PHORONGUARD does not provide good readability, but i don't want to implement whole new define as this one is good, or maybe rename?)
			else
				return (NOPIERCE) // armors and so on.
	return 0 // could be without pierce_protection or smth, but zero is OK too.

/mob/living/carbon/human/proc/handle_suit_punctures(damtype, damage)

	if(!wear_suit) return
	if(!istype(wear_suit,/obj/item/clothing/suit/space)) return
	if(damtype != BURN && damtype != BRUTE) return

	var/obj/item/clothing/suit/space/SS = wear_suit
	var/reduction_dam = (100 - SS.breach_threshold) / 100
	var/penetrated_dam = max(0, min(50, (damage * reduction_dam) / 1.5)) // - SS.damage)) - Consider uncommenting this if suits seem too hardy on dev.

	if(istype(SS, /obj/item/clothing/suit/space/rig))
		var/obj/item/clothing/suit/space/rig/rig = SS
		rig.take_hit(damage)

	if(penetrated_dam) SS.create_breaches(damtype, penetrated_dam)

// Does not check whether a targetzone's bodypart is actually a head :shrug:
// Make var/is_head for external bodyparts when such stuff would be required.
/mob/living/carbon/human/is_usable_head(targetzone = null)
	if(isnull(targetzone))
		var/obj/item/organ/external/head = get_bodypart(BP_HEAD)
		if(head && head.is_usable())
			return TRUE
	var/obj/item/organ/external/BP = get_bodypart(targetzone)
	if(BP)
		return BP.is_usable()
	return FALSE

// Does not check whether a targetzone's bodypart is actually an arm :shrug:
// Make var/is_arm for external bodyparts when such stuff would be required.
/mob/living/carbon/human/is_usable_arm(targetzone = null)
	if(isnull(targetzone))
		var/list/pos_arms = list(get_bodypart(BP_L_ARM), get_bodypart(BP_R_ARM))
		for(var/obj/item/organ/external/arm in pos_arms)
			if(arm && arm.is_usable())
				return TRUE
	var/obj/item/organ/external/BP = get_bodypart(targetzone)
	if(BP)
		return BP.is_usable()
	return FALSE

// Does not check whether a targetzone's bodypart is actually a leg :shrug:
// Make var/is_leg for external bodyparts when such stuff would be required.
/mob/living/carbon/human/is_usable_leg(targetzone = null)
	if(isnull(targetzone))
		var/list/pos_legs = list(get_bodypart(BP_L_LEG), get_bodypart(BP_R_LEG))
		for(var/obj/item/organ/external/leg in pos_legs)
			if(leg && leg.is_usable())
				return TRUE
	var/obj/item/organ/external/BP = get_bodypart(targetzone)
	if(BP)
		return BP.is_usable()
	return FALSE

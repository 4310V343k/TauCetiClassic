
/mob
	var/last_pain_message = ""
	var/next_pain_time = 0

// partname is the name of a body part
// amount is a num from 1 to 100

/mob/living/carbon/proc/pain(partname, amount, force, burning = 0)
	if(stat >= DEAD)
		return
	if(get_painkiller_effect() <= PAINKILLERS_EFFECT_MEDIUM)
		return
	if(world.time < next_pain_time && !force)
		return
	if(amount > 10 && ishuman(src))
		if(paralysis)
			SetParalysis(AmountParalyzed() - amount / 10)
	if(amount > 50 && prob(amount / 5))
		drop_item()
	var/msg
	if(burning)
		switch(amount)
			if(1 to 10)
				msg = "<span class='warning'><b>Your [partname] burns.</b></span>"
			if(11 to 90)
				msg = "<span class='warning'><b><font size=2>Your [partname] burns badly!</font></b></span>"
			if(91 to 10000)
				msg = "<span class='warning'><b><font size=3>OH GOD! Your [partname] is on fire!</font></b></span>"
	else
		switch(amount)
			if(1 to 10)
				msg = "<b>Your [partname] hurts.</b>"
			if(11 to 90)
				msg = "<b><font size=2>Your [partname] hurts badly.</font></b>"
			if(91 to 10000)
				msg = "<b><font size=3>OH GOD! Your [partname] is hurting terribly!</font></b>"
	if(msg && (msg != last_pain_message || prob(10)))
		last_pain_message = msg
		to_chat(src, msg)
	next_pain_time = world.time + (100 - amount)


// message is the custom message to be displayed
// flash_strength is 0 for weak pain flash, 1 for strong pain flash
/mob/living/carbon/human/proc/custom_pain(message, flash_strength)
	if(stat != CONSCIOUS)
		return
	if(HAS_TRAIT(src, TRAIT_NO_PAIN))
		return
	if(get_painkiller_effect() <= PAINKILLERS_EFFECT_HEAVY)
		return
	var/msg = "<span class='warning'><b>[message]</b></span>"
	if(flash_strength >= 1)
		msg = "<span class='warning'><font size=3><b>[message]</b></font></span>"

	// Anti message spam checks
	if(msg && ((msg != last_pain_message) || (world.time >= next_pain_time)))
		last_pain_message = msg
		to_chat(src, msg)
	next_pain_time = world.time + 100

/mob/living/carbon/human/proc/handle_pain()
	// not when sleeping
	if(HAS_TRAIT(src, TRAIT_NO_PAIN))
		return
	if(stat >= DEAD)
		return
	if(get_painkiller_effect() <= PAINKILLERS_EFFECT_HEAVY)
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/BP in bodyparts)
		if(BP.status & ORGAN_DEAD || BP.is_robotic())
			continue
		var/dam = BP.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = BP
			maxdam = dam
	if(damaged_organ)
		pain(damaged_organ.name, maxdam, 0)

	// Damage to organs hurts a lot.
	for(var/obj/item/organ/internal/IO in organs)
		if(IO.damage > 2 && prob(2))
			var/obj/item/organ/external/BP = bodyparts_by_name[IO.parent_bodypart]
			custom_pain("You feel a sharp pain in your [BP.name]", 1)

	var/toxDamageMessage = null
	var/toxMessageProb = 1
	switch(getToxLoss())
		if(1 to 5)
			toxMessageProb = 1
			toxDamageMessage = "Your body stings slightly."
		if(6 to 10)
			toxMessageProb = 2
			toxDamageMessage = "Your whole body hurts a little."
		if(11 to 15)
			toxMessageProb = 2
			toxDamageMessage = "Your whole body hurts."
		if(15 to 25)
			toxMessageProb = 3
			toxDamageMessage = "Your whole body hurts badly."
		if(26 to INFINITY)
			toxMessageProb = 5
			toxDamageMessage = "Your body aches all over, it's driving you mad."

	if(toxDamageMessage && prob(toxMessageProb))
		custom_pain(toxDamageMessage, getToxLoss() >= 15)

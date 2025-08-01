/obj/effect/proc_holder/spell/targeted/mind_transfer
	name = "Обмен Разумом"
	desc = "Позволяет поменяться телом с целью."

	school = "transmutation"
	charge_max = 1800
	clothes_req = 0
	invocation = "GIN'YU CAPAN"
	invocation_type = "whisper"
	sound = 'sound/magic/MandSwap.ogg'
	range = 1
	action_icon_state = "mindswap"
	var/list/protected_roles = list(WIZARD, CHANGELING, CULTIST) //which roles are immune to the spell
	var/list/compatible_mobs = list(/mob/living/carbon/human,/mob/living/carbon/monkey) //which types of mobs are affected by the spell. NOTE: change at your own risk
	var/base_spell_loss_chance = 20 //base probability of the wizard losing a spell in the process
	var/spell_loss_chance_modifier = 7 //amount of probability of losing a spell added per spell (mind_transfer included)
	var/spell_loss_amount = 1 //the maximum amount of spells possible to lose during a single transfer
	var/msg_wait = 500 //how long in deciseconds it waits before telling that body doesn't feel right or mind swap robbed of a spell
	var/paralysis_amount_caster = 20 //how much the caster is paralysed for after the spell
	var/paralysis_amount_victim = 20 //how much the victim is paralysed for after the spell

/*
Urist: I don't feel like figuring out how you store object spells so I'm leaving this for you to do.
Make sure spells that are removed from spell_list are actually removed and deleted when mind transfering.
Also, you never added distance checking after target is selected. I've went ahead and did that.
*/
/obj/effect/proc_holder/spell/targeted/mind_transfer/cast(list/targets,mob/user = usr)
	if(!targets.len)
		to_chat(user, "No mind found.")
		return

	if(targets.len > 1)
		to_chat(user, "Too many minds! You're not a hive damnit!")//Whaa...aat?
		return

	var/mob/living/target = targets[1]

	if(!(target in oview(range)))//If they are not in overview after selection. Do note that !() is necessary for in to work because ! takes precedence over it.
		to_chat(user, "They are too far away!")
		return

	if(!(target.type in compatible_mobs))
		to_chat(user, "Their mind isn't compatible with yours.")
		return

	if(target.stat == DEAD)
		to_chat(user, "You didn't study necromancy back at the Space Wizard Federation academy.")
		return

	if(!target.key || !target.mind)
		to_chat(user, "They appear to be catatonic. Not even magic can affect their vacant mind.")
		return

	for(var/role in protected_roles)
		if(isrole(role, target))
			to_chat(user, "Their mind is resisting your spell.")
			return

	//If target has mindshield/loyalty implant we break it, adding some brainloss
	if(ismindprotect(target))
		to_chat(user, "Their mind seems to be protected, so you only manage to break it")
		for(var/obj/item/weapon/implant/mind_protect/L in target.implants)
			L.meltdown()
		user.Paralyse(paralysis_amount_caster)
		target.Paralyse(paralysis_amount_victim)
		return

	var/mob/living/victim = target//The target of the spell whos body will be transferred to.
	var/mob/caster = user//The wizard/whomever doing the body transferring.

	//SPELL LOSS BEGIN
	//NOTE: The caster must ALWAYS keep mind transfer, even when other spells are lost.
	var/obj/effect/proc_holder/spell/targeted/mind_transfer/m_transfer = locate() in user.spell_list//Find mind transfer directly.
	var/list/checked_spells = user.spell_list
	checked_spells -= m_transfer //Remove Mind Transfer from the list.

	if(caster.spell_list.len)//If they have any spells left over after mind transfer is taken out. If they don't, we don't need this.
		for(var/i=spell_loss_amount,(i>0&&checked_spells.len),i--)//While spell loss amount is greater than zero and checked_spells has spells in it, run this proc.
			for(var/j=checked_spells.len,(j>0&&checked_spells.len),j--)//While the spell list to check is greater than zero and has spells in it, run this proc.
				if(prob(base_spell_loss_chance))
					checked_spells -= pick(checked_spells)//Pick a random spell to remove.
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), victim, "<span class='danger'>The mind transfer has robbed you of a spell.</span>"), msg_wait)
					break//Spell lost. Break loop, going back to the previous for() statement.
				else//Or keep checking, adding spell chance modifier to increase chance of losing a spell.
					base_spell_loss_chance += spell_loss_chance_modifier

	checked_spells += m_transfer//Add back Mind Transfer.
	user.spell_list = checked_spells//Set user spell list to whatever the new list is.
	user.mind.spell_list = checked_spells//Set user mind list to the same spells
	//SPELL LOSS END

	//MIND TRANSFER BEGIN
	victim.logout_reason = LOGOUT_SWAP
	caster.logout_reason = LOGOUT_SWAP
	var/mob/dead/observer/ghost = victim.ghostize(can_reenter_corpse = FALSE)
	ghost.spell_list = victim.spell_list//If they have spells, transfer them. Now we basically have a backup mob.

	caster.mind.transfer_to(victim)
	victim.spell_list = caster.spell_list//Now they are inside the victim's body.

	ghost.mind.transfer_to(caster)
	caster.key = ghost.key	//have to transfer the key since the mind was not active
	caster.spell_list = ghost.spell_list

	//MIND TRANSFER END

	//Here we paralyze both mobs and knock them out for a time.
	caster.Paralyse(paralysis_amount_caster)
	victim.Paralyse(paralysis_amount_victim)

	//After a certain amount of time the victim gets a message about being in a different body.
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(to_chat), caster, "<span class='warning'>You feel woozy and lightheaded. <b>Your body doesn't seem like your own.</b></span>"), msg_wait)

/mob/dead/observer/LateLogin()
	..()

	if(check_rights(R_ADMIN, 0))
		has_unlimited_silicon_privilege = 1

	updateghostimages()

	client.media?.stop_music()

	if(is_alien_whitelisted(src, "ian") || (client.supporter && !is_alien_whitelisted_banned(src, "ian")))
		verbs += /mob/dead/observer/proc/ianize

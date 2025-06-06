
//Cook
/obj/item/clothing/head/chefhat
	name = "chef's hat"
	desc = "It's a hat used by chefs to keep hair out of your food. Judging by the food in the mess, they don't work."
	icon_state = "chefhat"
	item_state = "chefhat"
	siemens_coefficient = 0.9

//Cook-alt
/obj/item/clothing/head/sushi_band
	name = "sushi master headband"
	desc = "Beautiful minimalistic headband."
	icon_state = "sushiband"
	item_state = "sushiband"

//Captain: This probably shouldn't be space-worthy
/obj/item/clothing/head/caphat
	name = "captain's hat"
	icon_state = "captain"
	desc = "It's good being the king."
	item_state = "caphat"
	siemens_coefficient = 0.9

//Captain: This probably shouldn't be space-worthy
/obj/item/clothing/head/helmet/cap
	name = "captain's cap"
	desc = "You fear to wear it for the negligence it brings."
	icon_state = "capcap"
	flags_inv = 0
	body_parts_covered = HEAD
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	force = 0
	hitsound = list()

//Chaplain
/obj/item/clothing/head/chaplain_hood
	name = "chaplain's hood"
	desc = "It's hood that covers the head. It keeps you warm during the space winters."
	icon_state = "chaplain_hood"
	flags = HEADCOVERSEYES
	render_flags = parent_type::render_flags | HIDE_ALL_HAIR
	siemens_coefficient = 0.9
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/skhima_hood
	name = "skhima hood"
	desc = "That's a religion skhima hood decorated with white runes and symbols. Commonly worn by monks."
	icon_state = "skhima_hood"
	item_state = "skhima_hood"
	flags = HEADCOVERSEYES
	siemens_coefficient = 0.9

/obj/item/clothing/head/nun_hood
	name = "nun hood"
	desc = "A religious female hood commonly worn by monastery sisters."
	icon_state = "nun_hood"
	render_flags = parent_type::render_flags | HIDE_ALL_HAIR
	siemens_coefficient = 0.9

//HoS
/obj/item/clothing/head/hos_peakedcap
	name = "head of security's peaked cap"
	desc = "The peaked cap of the Head of Security. I heard you, criminal scum. Now go to GOOLAG. Also has some space for special armor plate."
	icon_state = "hos_peakedcap"
	item_state = "hos_peakedcap"
	w_class = SIZE_TINY
	siemens_coefficient = 0.9
	body_parts_covered = 0
	valid_accessory_slots = list("dermal")
	restricted_accessory_slots = list("dermal")

/obj/item/clothing/head/hos_hat
	name = "head of security's hat"
	desc = "The hat of the Head of Security. For showing the officers who's in charge."
	icon_state = "hoshat"
	item_state = "hoshat"
	w_class = SIZE_TINY
	siemens_coefficient = 0.9
	body_parts_covered = 0
	valid_accessory_slots = list("dermal")
	restricted_accessory_slots = list("dermal")

//Medical
/obj/item/clothing/head/surgery
	name = "surgical cap"
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs."
	icon_state = "surgcap_blue"
	render_flags = parent_type::render_flags | HIDE_TOP_HAIR

/obj/item/clothing/head/surgery/purple
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is deep purple."
	icon_state = "surgcap_purple"

/obj/item/clothing/head/surgery/blue
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is baby blue."
	icon_state = "surgcap_blue"

/obj/item/clothing/head/surgery/green
	desc = "A cap surgeons wear during operations. Keeps their hair from tickling your internal organs. This one is dark green."
	icon_state = "surgcap_green"

//Detective

/obj/item/clothing/head/det_hat
	name = "detective's brown hat"
	desc = "Someone who wears this will look very smart."
	icon_state = "detective_hat_brown"
	allowed = list(/obj/item/weapon/reagent_containers/food/snacks/candy_corn, /obj/item/weapon/pen)
	armor = list(melee = 50, bullet = 5, laser = 25,energy = 10, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	body_parts_covered = HEAD

/obj/item/clothing/head/det_hat/gray
	name = "detective's gray hat"
	icon_state = "detective_hat_gray"

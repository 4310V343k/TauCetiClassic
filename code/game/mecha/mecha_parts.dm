/////////////////////////
////// Mecha Parts //////
/////////////////////////

/obj/item/mecha_parts
	name = "mecha part"
	icon = 'icons/mecha/mech_construct.dmi'
	icon_state = "blank"
	w_class = SIZE_BIG
	flags = CONDUCT
	origin_tech = "programming=2;materials=2"


/obj/item/mecha_parts/chassis
	name="Mecha Chassis"
	icon_state = "backbone"
	var/datum/construction/construct
	flags = CONDUCT

/obj/item/mecha_parts/chassis/attackby(obj/item/I, mob/user, params)
	if(!construct || !construct.action(I, user))
		return ..()

/obj/item/mecha_parts/chassis/attack_hand()
	return


/obj/item/mecha_parts/dna_scanner
	name = "Exosuit DNA scanner"
	desc = "Device that allows locking exosuits by DNA."
	icon = 'icons/obj/device.dmi'
	icon_state = "motion2"
	origin_tech = "programming=3;biotech=3"

/////////// Ripley

/obj/item/mecha_parts/chassis/ripley
	name = "Ripley Chassis"

/obj/item/mecha_parts/chassis/ripley/atom_init()
	. = ..()
	construct = new /datum/construction/mecha/ripley_chassis(src)

/obj/item/mecha_parts/part/ripley_torso
	name="Ripley Torso"
	desc="A torso part of Ripley APLU. Contains power unit, processing core and life support systems."
	icon_state = "ripley_harness"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"

/obj/item/mecha_parts/part/ripley_left_arm
	name="Ripley Left Arm"
	desc="A Ripley APLU left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_l_arm"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/ripley_right_arm
	name="Ripley Right Arm"
	desc="A Ripley APLU right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "ripley_r_arm"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/ripley_left_leg
	name="Ripley Left Leg"
	desc="A Ripley APLU left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_l_leg"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/ripley_right_leg
	name="Ripley Right Leg"
	desc="A Ripley APLU right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "ripley_r_leg"
	origin_tech = "programming=2;materials=2;engineering=2"

///////// Gygax

/obj/item/mecha_parts/chassis/gygax
	name = "Gygax Chassis"

/obj/item/mecha_parts/chassis/gygax/atom_init()
	. = ..()
	construct = new /datum/construction/mecha/gygax_chassis(src)

/obj/item/mecha_parts/part/gygax_torso
	name="Gygax Torso"
	desc="A torso part of Gygax. Contains power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "gygax_harness"
	origin_tech = "programming=2;materials=2;biotech=3;engineering=3"

/obj/item/mecha_parts/part/gygax_head
	name="Gygax Head"
	desc="A Gygax head. Houses advanced surveilance and targeting sensors."
	icon_state = "gygax_head"
	origin_tech = "programming=2;materials=2;magnets=3;engineering=3"

/obj/item/mecha_parts/part/gygax_left_arm
	name="Gygax Left Arm"
	desc="A Gygax left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_l_arm"
	origin_tech = "programming=2;materials=2;engineering=3"

/obj/item/mecha_parts/part/gygax_right_arm
	name="Gygax Right Arm"
	desc="A Gygax right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "gygax_r_arm"
	origin_tech = "programming=2;materials=2;engineering=3"

/obj/item/mecha_parts/part/gygax_left_leg
	name="Gygax Left Leg"
	icon_state = "gygax_l_leg"
	origin_tech = "programming=2;materials=2;engineering=3"

/obj/item/mecha_parts/part/gygax_right_leg
	name="Gygax Right Leg"
	icon_state = "gygax_r_leg"
	origin_tech = "programming=2;materials=2;engineering=3"

/obj/item/mecha_parts/part/gygax_armour
	name="Gygax Armour Plates"
	icon_state = "gygax_armour"
	origin_tech = "materials=6;combat=4;engineering=5"


//////////// Durand

/obj/item/mecha_parts/chassis/durand
	name = "Durand Chassis"

/obj/item/mecha_parts/chassis/durand/atom_init()
	. = ..()
	construct = new /datum/construction/mecha/durand_chassis(src)

/obj/item/mecha_parts/part/durand_torso
	name="Durand Torso"
	icon_state = "durand_harness"
	origin_tech = "programming=2;materials=3;biotech=3;engineering=3"

/obj/item/mecha_parts/part/durand_head
	name="Durand Head"
	icon_state = "durand_head"
	origin_tech = "programming=2;materials=3;magnets=3;engineering=3"

/obj/item/mecha_parts/part/durand_left_arm
	name="Durand Left Arm"
	icon_state = "durand_l_arm"
	origin_tech = "programming=2;materials=3;engineering=3"

/obj/item/mecha_parts/part/durand_right_arm
	name="Durand Right Arm"
	icon_state = "durand_r_arm"
	origin_tech = "programming=2;materials=3;engineering=3"

/obj/item/mecha_parts/part/durand_left_leg
	name="Durand Left Leg"
	icon_state = "durand_l_leg"
	origin_tech = "programming=2;materials=3;engineering=3"

/obj/item/mecha_parts/part/durand_right_leg
	name="Durand Right Leg"
	icon_state = "durand_r_leg"
	origin_tech = "programming=2;materials=3;engineering=3"

/obj/item/mecha_parts/part/durand_armour
	name="Durand Armour Plates"
	icon_state = "durand_armour"
	origin_tech = "materials=5;combat=4;engineering=5"



////////// Firefighter

/obj/item/mecha_parts/chassis/firefighter
	name = "Firefighter Chassis"

/obj/item/mecha_parts/chassis/firefighter/atom_init()
	. = ..()
	construct = new /datum/construction/mecha/firefighter_chassis(src)
/*
/obj/item/mecha_parts/part/firefighter_torso
	name="Ripley-on-Fire Torso"
	icon_state = "ripley_harness"

/obj/item/mecha_parts/part/firefighter_left_arm
	name="Ripley-on-Fire Left Arm"
	icon_state = "ripley_l_arm"

/obj/item/mecha_parts/part/firefighter_right_arm
	name="Ripley-on-Fire Right Arm"
	icon_state = "ripley_r_arm"

/obj/item/mecha_parts/part/firefighter_left_leg
	name="Ripley-on-Fire Left Leg"
	icon_state = "ripley_l_leg"

/obj/item/mecha_parts/part/firefighter_right_leg
	name="Ripley-on-Fire Right Leg"
	icon_state = "ripley_r_leg"
*/

////////// HONK

/obj/item/mecha_parts/chassis/honker
	name = "H.O.N.K Chassis"

/obj/item/mecha_parts/chassis/honker/atom_init()
	. = ..()
	construct = new /datum/construction/mecha/honker_chassis(src)

/obj/item/mecha_parts/part/honker_torso
	name="H.O.N.K Torso"
	icon_state = "honker_harness"

/obj/item/mecha_parts/part/honker_head
	name="H.O.N.K Head"
	icon_state = "honker_head"

/obj/item/mecha_parts/part/honker_left_arm
	name="H.O.N.K Left Arm"
	icon_state = "honker_l_arm"

/obj/item/mecha_parts/part/honker_right_arm
	name="H.O.N.K Right Arm"
	icon_state = "honker_r_arm"

/obj/item/mecha_parts/part/honker_left_leg
	name="H.O.N.K Left Leg"
	icon_state = "honker_l_leg"

/obj/item/mecha_parts/part/honker_right_leg
	name="H.O.N.K Right Leg"
	icon_state = "honker_r_leg"


////////// Phazon

/obj/item/mecha_parts/chassis/phazon
	name = "Phazon Chassis"
	origin_tech = "materials=7"

/obj/item/mecha_parts/chassis/phazon/atom_init()
	. = ..()
	construct = new /datum/construction/mecha/phazon_chassis(src)

/obj/item/mecha_parts/part/phazon_torso
	name="Phazon Torso"
	icon_state = "phazon_harness"
	origin_tech = "programming=5;materials=7;bluespace=6;powerstorage=6"

/obj/item/mecha_parts/part/phazon_head
	name="Phazon Head"
	icon_state = "phazon_head"
	origin_tech = "programming=4;materials=5;magnets=6"

/obj/item/mecha_parts/part/phazon_left_arm
	name="Phazon Left Arm"
	icon_state = "phazon_l_arm"
	origin_tech = "materials=5;bluespace=2;magnets=2"

/obj/item/mecha_parts/part/phazon_right_arm
	name="Phazon Right Arm"
	icon_state = "phazon_r_arm"
	origin_tech = "materials=5;bluespace=2;magnets=2"

/obj/item/mecha_parts/part/phazon_left_leg
	name="Phazon Left Leg"
	icon_state = "phazon_l_leg"
	origin_tech = "materials=5;bluespace=3;magnets=3"

/obj/item/mecha_parts/part/phazon_right_leg
	name="Phazon Right Leg"
	icon_state = "phazon_r_leg"
	origin_tech = "materials=5;bluespace=3;magnets=3"

///////// Odysseus


/obj/item/mecha_parts/chassis/odysseus
	name = "Odysseus Chassis"

/obj/item/mecha_parts/chassis/odysseus/atom_init()
	. = ..()
	construct = new /datum/construction/mecha/odysseus_chassis(src)

/obj/item/mecha_parts/part/odysseus_head
	name="Odysseus Head"
	icon_state = "odysseus_head"
	origin_tech = "programming=3;materials=2"

/obj/item/mecha_parts/part/odysseus_torso
	name="Odysseus Torso"
	desc="A torso part of Odysseus. Contains power unit, processing core and life support systems."
	icon_state = "odysseus_torso"
	origin_tech = "programming=2;materials=2;biotech=2;engineering=2"

/obj/item/mecha_parts/part/odysseus_left_arm
	name="Odysseus Left Arm"
	desc="An Odysseus left arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_l_arm"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/odysseus_right_arm
	name="Odysseus Right Arm"
	desc="An Odysseus right arm. Data and power sockets are compatible with most exosuit tools."
	icon_state = "odysseus_r_arm"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/odysseus_left_leg
	name="Odysseus Left Leg"
	desc="An Odysseus left leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_l_leg"
	origin_tech = "programming=2;materials=2;engineering=2"

/obj/item/mecha_parts/part/odysseus_right_leg
	name="Odysseus Right Leg"
	desc="A Odysseus right leg. Contains somewhat complex servodrives and balance maintaining systems."
	icon_state = "odysseus_r_leg"
	origin_tech = "programming=2;materials=2;engineering=2"

/*/obj/item/mecha_parts/part/odysseus_armour
	name="Odysseus Carapace"
	icon_state = "odysseus_armour"
	origin_tech = "materials=3;engineering=3"*/


///////// Circuitboards

/obj/item/weapon/circuitboard/mecha
	name = "Exosuit Circuit board"
	icon = 'icons/obj/module.dmi'
	icon_state = "exo_mod"
	item_state_world = "exo_mod_w"
	item_state = "electronic"
	board_type = "other"
	flags = CONDUCT
	force = 5.0
	w_class = SIZE_TINY
	throwforce = 5.0
	throw_speed = 3
	throw_range = 15

/obj/item/weapon/circuitboard/mecha/ripley
	origin_tech = "programming=3"

/obj/item/weapon/circuitboard/mecha/ripley/peripherals
	name = "Circuit board (Ripley Peripherals Control module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/ripley/main
	name = "Circuit board (Ripley Central Control module)"
	icon_state = "mainboard"
	item_state_world = "mainboard_w"

/obj/item/weapon/circuitboard/mecha/gygax
	origin_tech = "programming=4"

/obj/item/weapon/circuitboard/mecha/gygax/peripherals
	name = "Circuit board (Gygax Peripherals Control module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/gygax/targeting
	name = "Circuit board (Gygax Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"
	origin_tech = "programming=4;combat=4"

/obj/item/weapon/circuitboard/mecha/gygax/main
	name = "Circuit board (Gygax Central Control module)"
	icon_state = "mainboard"
	item_state_world = "mainboard_w"

/obj/item/weapon/circuitboard/mecha/ultra
	origin_tech = "programming=4;combat=4"

/obj/item/weapon/circuitboard/mecha/ultra/peripherals
	name = "Circuit board (Gygax Ultra Peripherals Control module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/ultra/targeting
	name = "Circuit board (Gygax Ultra Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/ultra/main
	name = "Circuit board (Gygax Ultra Central Control module)"
	icon_state = "mainboard"
	item_state_world = "mainboard_w"

/obj/item/weapon/circuitboard/mecha/durand
	origin_tech = "programming=4"

/obj/item/weapon/circuitboard/mecha/durand/peripherals
	name = "Circuit board (Durand Peripherals Control module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/durand/targeting
	name = "Circuit board (Durand Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"
	origin_tech = "programming=4;combat=4"

/obj/item/weapon/circuitboard/mecha/durand/main
	name = "Circuit board (Durand Central Control module)"
	icon_state = "mainboard"
	item_state_world = "mainboard_w"

/obj/item/weapon/circuitboard/mecha/vindicator
	origin_tech = "programming=4;combat=4"

/obj/item/weapon/circuitboard/mecha/vindicator/peripherals
	name = "Circuit board (Vindicator Peripherals Control module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/vindicator/targeting
	name = "Circuit board (Vindicator Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/vindicator/main
	name = "Circuit board (Vindicator Central Control module)"
	icon_state = "mainboard"
	item_state_world = "mainboard_w"

/obj/item/weapon/circuitboard/mecha/honker
	origin_tech = "programming=4"

/obj/item/weapon/circuitboard/mecha/honker/peripherals
	name = "Circuit board (H.O.N.K Peripherals Control module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/honker/targeting
	name = "Circuit board (H.O.N.K Weapon Control and Targeting module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/honker/main
	name = "Circuit board (H.O.N.K Central Control module)"
	icon_state = "mainboard"
	item_state_world = "mainboard_w"

/obj/item/weapon/circuitboard/mecha/odysseus
	origin_tech = "programming=3"

/obj/item/weapon/circuitboard/mecha/odysseus/peripherals
	name = "Circuit board (Odysseus Peripherals Control module)"
	icon_state = "mcontroller"
	item_state_world = "mcontroller_w"

/obj/item/weapon/circuitboard/mecha/odysseus/main
	name = "Circuit board (Odysseus Central Control module)"
	icon_state = "mainboard"
	item_state_world = "mainboard_w"

////////////Vindicator

/obj/item/mecha_parts/chassis/vindicator
	name = "Vindicator Chassis"

/obj/item/mecha_parts/chassis/vindicator/atom_init()
	. = ..()
	construct = new /datum/construction/mecha/vindicator_chassis(src)

/obj/item/mecha_parts/part/vindicator_torso
	name="Vindicator Torso"
	icon_state = "vindicator_harness"
	origin_tech = "programming=2;materials=4;biotech=3;engineering=4;powerstorage=4"

/obj/item/mecha_parts/part/vindicator_head
	name="Vindicator Head"
	icon_state = "vindicator_head"
	origin_tech = "programming=2;materials=4;magnets=3;engineering=4"

/obj/item/mecha_parts/part/vindicator_left_arm
	name="Vindicator Left Arm"
	icon_state = "vindicator_l_arm"
	origin_tech = "programming=2;materials=4;engineering=4"

/obj/item/mecha_parts/part/vindicator_right_arm
	name="Vindicator Right Arm"
	icon_state = "vindicator_r_arm"
	origin_tech = "programming=2;materials=4;engineering=4"

/obj/item/mecha_parts/part/vindicator_left_leg
	name="Vindicator Left Leg"
	icon_state = "vindicator_l_leg"
	origin_tech = "programming=2;materials=4;engineering=4"

/obj/item/mecha_parts/part/vindicator_right_leg
	name="Vindicator Right Leg"
	icon_state = "vindicator_r_leg"
	origin_tech = "programming=2;materials=4;engineering=4"

/obj/item/mecha_parts/part/vindicator_armour
	name="Vindicator Armour Plates"
	icon_state = "vindicator_armour"
	origin_tech = "materials=5;combat=4;engineering=5"

///////// Gygax Ultra

/obj/item/mecha_parts/chassis/ultra
	name = "Gygax Ultra Chassis"

/obj/item/mecha_parts/chassis/ultra/atom_init()
	. = ..()
	construct = new /datum/construction/mecha/ultra_chassis(src)

/obj/item/mecha_parts/part/ultra_torso
	name="Gygax Ultra Torso"
	desc="A torso part of Gygax Ultra. Contains power unit, processing core and life support systems. Has an additional equipment slot."
	icon_state = "ultra_harness"
	origin_tech = "programming=3;materials=3;biotech=3;engineering=4"

/obj/item/mecha_parts/part/ultra_head
	name="Gygax Ultra Head"
	desc="A Gygax Ultra head. Houses advanced surveilance and targeting sensors."
	icon_state = "ultra_head"
	origin_tech = "programming=2;materials=4;magnets=3;engineering=4"

/obj/item/mecha_parts/part/ultra_left_arm
	name="Gygax Ultra Left Arm"
	desc="A Gygax Ultra left arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "ultra_l_arm"
	origin_tech = "programming=2;materials=3;engineering=4"

/obj/item/mecha_parts/part/ultra_right_arm
	name="Gygax Ultra Right Arm"
	desc="A Gygax Ultra right arm. Data and power sockets are compatible with most exosuit tools and weapons."
	icon_state = "ultra_r_arm"
	origin_tech = "programming=2;materials=3;engineering=4"

/obj/item/mecha_parts/part/ultra_left_leg
	name="Gygax Ultra Left Leg"
	icon_state = "ultra_l_leg"
	origin_tech = "programming=2;materials=3;engineering=4"

/obj/item/mecha_parts/part/ultra_right_leg
	name="Gygax Ultra Right Leg"
	icon_state = "ultra_r_leg"
	origin_tech = "programming=2;materials=3;engineering=4"

/obj/item/mecha_parts/part/ultra_armour
	name="Gygax Ultra Armour Plates"
	icon_state = "ultra_armour"
	origin_tech = "materials=6;combat=5;engineering=5"

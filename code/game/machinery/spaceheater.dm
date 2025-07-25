#define HEATER_MODE_STANDBY	"standby"
#define HEATER_MODE_HEAT	"heat"
#define HEATER_MODE_COOL	"cool"
#define HEATER_MODE_AUTO	"auto"

/obj/machinery/space_heater
	anchored = FALSE
	density = TRUE
	icon = 'icons/obj/atmos.dmi'
	icon_state = "sheater-off"
	name = "space heater"
	desc = "Made by Space Amish using traditional space techniques, this heater/cooler is guaranteed not to set the station on fire."
	interact_offline = TRUE
	interact_open = TRUE
	var/obj/item/weapon/stock_parts/cell/cell
	var/on = FALSE
	var/mode = HEATER_MODE_STANDBY
	var/setMode = HEATER_MODE_AUTO // Anything other than "heat" or "cool" is considered auto.
	var/targetTemperature = T20C
	var/heatingPower = 40000
	var/efficiency = 20000
	var/settableTemperatureMedian = 30 + T0C
	var/settableTemperatureRange = 30

/obj/machinery/space_heater/atom_init()
	. = ..()
	cell = new(src)
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/space_heater(null)
	component_parts += new /obj/item/weapon/stock_parts/capacitor(null)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(null)
	component_parts += new /obj/item/stack/cable_coil/red(null, 3)
	RefreshParts()
	update_icon()

/obj/machinery/space_heater/construction()
	qdel(cell)
	cell = null
	panel_open = TRUE
	update_icon()
	return ..()

/obj/machinery/space_heater/deconstruction()
	if(cell)
		component_parts += cell
		cell = null
	return ..()

/obj/machinery/space_heater/update_icon()
	if(on)
		icon_state = "sheater-[mode]"
	else
		icon_state = "sheater-off"

	cut_overlays()
	if(panel_open)
		add_overlay("sheater-open")

/obj/machinery/space_heater/examine(mob/user)
	..()
	to_chat(user, "\The [src] is [on ? "on" : "off"], and the hatch is [panel_open ? "open" : "closed"].")
	if(cell)
		to_chat(user, "The charge meter reads [cell ? round(cell.percent(), 1) : 0]%.")
	else
		to_chat(user, "There is no power cell installed.")

/obj/machinery/space_heater/RefreshParts()
	..()

	var/laser = 0
	var/cap = 0
	for(var/obj/item/weapon/stock_parts/micro_laser/M in component_parts)
		laser += M.rating
	for(var/obj/item/weapon/stock_parts/capacitor/M in component_parts)
		cap += M.rating

	heatingPower = laser * 40000

	settableTemperatureRange = cap * 30
	efficiency = (cap + 1) * 10000

	var/minTemp = max(settableTemperatureMedian - settableTemperatureRange, TCMB)
	var/maxTemp = settableTemperatureMedian + settableTemperatureRange
	targetTemperature = clamp(targetTemperature, minTemp, maxTemp)

/obj/machinery/space_heater/emp_act(severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return
	if(cell)
		cell.emplode(severity)
	..(severity)

/obj/machinery/space_heater/attackby(obj/item/I, mob/user)
	add_fingerprint(user)
	if(istype(I, /obj/item/weapon/stock_parts/cell))
		if(panel_open)
			if(cell)
				to_chat(user, "There is already a power cell inside.")
				return
			else
				// insert cell
				var/obj/item/weapon/stock_parts/cell/C = usr.get_active_hand()
				if(istype(C))
					user.drop_from_inventory(C, src)
					cell = C
					C.add_fingerprint(usr)
					user.visible_message("\The [user] inserts a power cell into \the [src].", "<span class='notice'>You insert the power cell into \the [src].</span>")
		else
			to_chat(user, "The hatch must be open to insert a power cell.")
			return
	else if(isscrewing(I))
		panel_open = !panel_open
		user.visible_message("\The [user] [panel_open ? "opens" : "closes"] the hatch on \the [src].", "<span class='notice'>You [panel_open ? "open" : "close"] the hatch on \the [src].</span>")
		update_icon()
		if(panel_open)
			interact(user)
	else if(exchange_parts(user, I) || default_deconstruction_crowbar(I))
		return
	else
		..()

/obj/machinery/space_heater/ui_interact(mob/user)
	tgui_interact(user)

/obj/machinery/space_heater/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceHeater", name)
		ui.open()

/obj/machinery/space_heater/tgui_data()
	var/data = list()
	data["open"] = panel_open
	data["on"] = on
	data["mode"] = capitalize(setMode)
	data["hasPowercell"] = !!cell
	data["powercellName"] = isnull(cell) ? "" : cell.name
	data["powerLevel"] = isnull(cell) ? 0 : round(cell.percent(), 1)
	data["targetTemp"] = round(targetTemperature - T0C, 1)
	data["minTemp"] = max(settableTemperatureMedian - settableTemperatureRange - T0C, TCMB - T0C)
	data["maxTemp"] = settableTemperatureMedian + settableTemperatureRange - T0C

	var/turf/simulated/L = get_turf(loc)
	var/curTemp
	if(istype(L))
		var/datum/gas_mixture/env = L.return_air()
		curTemp = env.temperature
	else if(isturf(L))
		curTemp = L.temperature

	if(isnull(curTemp))
		data["currentTemp"] = "N/A"
	else
		data["currentTemp"] = round(curTemp - T0C, 1)

	return data

/obj/machinery/space_heater/tgui_act(action, params)
	. = ..()
	if(.)
		return

	switch(action)
		if("power")
			on = !on
			mode = HEATER_MODE_STANDBY
			usr.visible_message("[usr] switches [on ? "on" : "off"] \the [src].", "<span class='notice'>You switch [on ? "on" : "off"] \the [src].</span>")
			update_icon()
		if("mode")
			switch(setMode)
				if(HEATER_MODE_AUTO)
					setMode = HEATER_MODE_HEAT
				if(HEATER_MODE_HEAT)
					setMode = HEATER_MODE_COOL
				if(HEATER_MODE_COOL)
					setMode = HEATER_MODE_AUTO
		if("setTemp")
			var/value = params["temperature"]
			if(isnull(value))
				return
			value += T0C
			var/minTemp = max(settableTemperatureMedian - settableTemperatureRange, TCMB)
			var/maxTemp = settableTemperatureMedian + settableTemperatureRange
			targetTemperature = clamp(round(value, 1), minTemp, maxTemp)

	if(!panel_open)
		return
	if(action == "operateCell")
		if(cell)
			if(usr.get_active_hand())
				to_chat(usr, "<span class='warning'>You need an empty hand to remove \the [cell]!</span>")
				return
			cell.updateicon()
			usr.put_in_hands(cell)
			cell.add_fingerprint(usr)
			usr.visible_message("\The [usr] removes \the [cell] from \the [src].", "<span class='notice'>You remove \the [cell] from \the [src].</span>")
			cell = null
		else
			var/obj/item/weapon/stock_parts/cell/C = usr.get_active_hand()
			if(istype(C))
				if(!usr.drop_from_inventory(C, src))
					return
				cell = C
				C.add_fingerprint(usr)
				usr.visible_message("\The [usr] inserts \a [C] into \the [src].", "<span class='notice'>You insert \the [C] into \the [src].</span>")


/obj/machinery/space_heater/is_operational()
	return !(stat & BROKEN)

/obj/machinery/space_heater/process()
	if(!on || (stat & BROKEN))
		return
	if(!powered() && (isnull(cell) || cell.charge <= 0))
		on = FALSE
		mode = HEATER_MODE_STANDBY
		power_change()
		update_icon()
		return

	var/datum/gas_mixture/env = loc.return_air()
	var/tempDif = isnull(env) ? 0 : (env.temperature - targetTemperature)
	if(abs(tempDif) <= 0.1 || (tempDif > 0 && setMode == HEATER_MODE_HEAT) || (tempDif < 0 && setMode == HEATER_MODE_COOL)) //Standby if dif is too small or if restricted by target mode, e.g. env. temp. is higher than target temp. and mode is heating
		mode = HEATER_MODE_STANDBY
	else
		var/transfer_moles = 0.25 * env.total_moles
		var/datum/gas_mixture/removed = env.remove(transfer_moles)

		if(removed)
			var/heat_transfer = removed.get_thermal_energy_change(targetTemperature)
			var/power_draw
			if(heat_transfer > 0)	//heating air
				heat_transfer = min( heat_transfer , heatingPower ) //limit by the power rating of the heater

				removed.add_thermal_energy(heat_transfer)
				power_draw = heat_transfer
			else	//cooling air
				heat_transfer = abs(heat_transfer)

				//Assume the heat is being pumped into the hull which is fixed at 20 C
				var/cop = removed.temperature / T20C	//coefficient of performance from thermodynamics -> power used = heat_transfer/cop
				heat_transfer = min(heat_transfer, cop * heatingPower)	//limit heat transfer by available power

				heat_transfer = removed.add_thermal_energy(-heat_transfer)	//get the actual heat transfer

				power_draw = abs(heat_transfer) / cop
			if(!powered())
				cell.use(power_draw * CELLRATE)
			else
				use_power(power_draw TAUCETI_POWER_DRAW_MOD)

			if(heat_transfer > 0)
				mode = HEATER_MODE_HEAT
			else if(heat_transfer < 0)
				mode = HEATER_MODE_COOL
			else
				mode = HEATER_MODE_STANDBY

		env.merge(removed)

	update_icon()

#undef HEATER_MODE_STANDBY
#undef HEATER_MODE_HEAT
#undef HEATER_MODE_COOL
#undef HEATER_MODE_AUTO

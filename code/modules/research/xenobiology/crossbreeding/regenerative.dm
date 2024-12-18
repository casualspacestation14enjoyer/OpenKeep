/*
Regenerative extracts:
	Work like a legion regenerative core.
	Has a unique additional effect.
*/
/obj/item/slimecross/regenerative
	name = "regenerative extract"
	desc = ""
	effect = "regenerative"
	icon_state = "regenerative"

/obj/item/slimecross/regenerative/proc/core_effect(mob/living/carbon/human/target, mob/user)
	return
/obj/item/slimecross/regenerative/proc/core_effect_before(mob/living/carbon/human/target, mob/user)
	return

/obj/item/slimecross/regenerative/afterattack(atom/target,mob/user,prox)
	. = ..()
	if(!prox || !isliving(target))
		return
	var/mob/living/H = target
	if(H.stat == DEAD)
		to_chat(user, "<span class='warning'>[src] will not work on the dead!</span>")
		return
	if(H != user)
		user.visible_message("<span class='notice'>[user] crushes the [src] over [H], the milky goo quickly regenerating all of [H.p_their()] injuries!</span>",
			"<span class='notice'>I squeeze the [src], and it bursts over [H], the milky goo regenerating [H.p_their()] injuries.</span>")
	else
		user.visible_message("<span class='notice'>[user] crushes the [src] over [user.p_them()]self, the milky goo quickly regenerating all of [user.p_their()] injuries!</span>",
			"<span class='notice'>I squeeze the [src], and it bursts in your hand, splashing you with milky goo which quickly regenerates your injuries!</span>")
	core_effect_before(H, user)
	H.revive(full_heal = TRUE, admin_revive = FALSE)
	core_effect(H, user)
	playsound(target, 'sound/blank.ogg', 40, TRUE)
	qdel(src)

/obj/item/slimecross/regenerative/grey
	colour = "grey" //Has no bonus effect.
	effect_desc = ""

/obj/item/slimecross/regenerative/orange
	colour = "orange"

/obj/item/slimecross/regenerative/orange/core_effect_before(mob/living/target, mob/user)
	target.visible_message("<span class='warning'>The [src] boils over!</span>")
	for(var/turf/turf in range(1,target))
		if(!locate(/obj/effect/hotspot) in turf)
			new /obj/effect/hotspot(turf)

/obj/item/slimecross/regenerative/purple
	colour = "purple"
	effect_desc = ""

/obj/item/slimecross/regenerative/purple/core_effect(mob/living/target, mob/user)
	target.reagents.add_reagent(/datum/reagent/medicine/regen_jelly,10)

/obj/item/slimecross/regenerative/blue
	colour = "blue"
	effect_desc = ""

/obj/item/slimecross/regenerative/blue/core_effect(mob/living/target, mob/user)
	if(isturf(target.loc))
		var/turf/open/T = get_turf(target)
		T.MakeSlippery(TURF_WET_WATER, min_wet_time = 10, wet_time_to_add = 5)
		target.visible_message("<span class='warning'>The milky goo in the extract gets all over the floor!</span>")

/obj/item/slimecross/regenerative/metal
	colour = "metal"
	effect_desc = ""

/obj/item/slimecross/regenerative/metal/core_effect(mob/living/target, mob/user)
	target.visible_message("<span class='warning'>The milky goo hardens and reshapes itself, encasing [target]!</span>")
	var/obj/structure/closet/C = new /obj/structure/closet(target.loc)
	C.name = "slimy closet"
	C.desc = ""
	target.forceMove(C)

/obj/item/slimecross/regenerative/darkpurple
	colour = "dark purple"
	effect_desc = ""

/obj/item/slimecross/regenerative/darkpurple/core_effect(mob/living/target, mob/user)
	var/equipped = 0
	equipped += target.equip_to_slot_or_del(new /obj/item/clothing/shoes/sneakers/purple(null), SLOT_SHOES)
	equipped += target.equip_to_slot_or_del(new /obj/item/clothing/under/color/lightpurple(null), SLOT_PANTS)
	equipped += target.equip_to_slot_or_del(new /obj/item/clothing/gloves/color/purple(null), SLOT_GLOVES)
	equipped += target.equip_to_slot_or_del(new /obj/item/clothing/head/soft/purple(null), SLOT_HEAD)
	if(equipped > 0)
		target.visible_message("<span class='notice'>The milky goo congeals into clothing!</span>")

/obj/item/slimecross/regenerative/darkblue
	colour = "dark blue"
	effect_desc = ""

/obj/item/slimecross/regenerative/darkblue/core_effect(mob/living/target, mob/user)
	if(!ishuman(target))
		return
	var/mob/living/carbon/human/H = target
	var/fireproofed = FALSE
	if(H.get_item_by_slot(SLOT_ARMOR))
		fireproofed = TRUE
		var/obj/item/clothing/C = H.get_item_by_slot(SLOT_ARMOR)
		fireproof(C)
	if(H.get_item_by_slot(SLOT_HEAD))
		fireproofed = TRUE
		var/obj/item/clothing/C = H.get_item_by_slot(SLOT_HEAD)
		fireproof(C)
	if(fireproofed)
		target.visible_message("<span class='notice'>Some of [target]'s clothing gets coated in the goo, and turns blue!</span>")

/obj/item/slimecross/regenerative/darkblue/proc/fireproof(obj/item/clothing/C)
	C.name = "fireproofed [C.name]"
	C.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
	C.add_atom_colour("#000080", FIXED_COLOUR_PRIORITY)
	C.max_heat_protection_temperature = FIRE_IMMUNITY_MAX_TEMP_PROTECT
	C.heat_protection = C.body_parts_covered
	C.resistance_flags |= FIRE_PROOF

/obj/item/slimecross/regenerative/silver
	colour = "silver"
	effect_desc = ""

/obj/item/slimecross/regenerative/silver/core_effect(mob/living/target, mob/user)
	target.set_nutrition(NUTRITION_LEVEL_FULL - 1)
	to_chat(target, "<span class='notice'>I feel satiated.</span>")

/obj/item/slimecross/regenerative/bluespace
	colour = "bluespace"
	effect_desc = ""
	var/turf/open/T

/obj/item/slimecross/regenerative/bluespace/core_effect(mob/living/target, mob/user)
	target.visible_message("<span class='warning'>[src] disappears in a shower of sparks!</span>","<span class='danger'>The milky goo teleports you somewhere it remembers!</span>")
	do_sparks(5,FALSE,target)
	target.forceMove(T)
	do_sparks(5,FALSE,target)

/obj/item/slimecross/regenerative/bluespace/Initialize()
	. = ..()
	T = get_turf(src)

/obj/item/slimecross/regenerative/sepia
	colour = "sepia"
	effect_desc = ""

/obj/item/slimecross/regenerative/sepia/core_effect_before(mob/living/target, mob/user)
	to_chat(target, "<span class=notice>I try to forget how you feel.</span>")
	target.AddComponent(/datum/component/dejavu)

/obj/item/slimecross/regenerative/cerulean
	colour = "cerulean"
	effect_desc = ""

/obj/item/slimecross/regenerative/cerulean/core_effect(mob/living/target, mob/user)
	src.forceMove(user.loc)
	var/obj/item/slimecross/X = new /obj/item/slimecross/regenerative(user.loc)
	X.name = name
	X.desc = desc
	user.put_in_active_hand(X)
	to_chat(user, "<span class='notice'>Some of the milky goo congeals in your hand!</span>")

/obj/item/slimecross/regenerative/pyrite
	colour = "pyrite"
	effect_desc = ""

/obj/item/slimecross/regenerative/pyrite/core_effect(mob/living/target, mob/user)
	target.visible_message("<span class='warning'>The milky goo coating [target] leaves [target.p_them()] a different color!</span>")
	target.add_atom_colour(rgb(rand(0,255),rand(0,255),rand(0,255)),WASHABLE_COLOUR_PRIORITY)

/obj/item/slimecross/regenerative/red
	colour = "red"
	effect_desc = ""

/obj/item/slimecross/regenerative/red/core_effect(mob/living/target, mob/user)
	to_chat(target, "<span class='notice'>I feel... <i>faster.</i></span>")
	target.reagents.add_reagent(/datum/reagent/medicine/ephedrine,3)

/obj/item/slimecross/regenerative/green
	colour = "green"
	effect_desc = ""

/obj/item/slimecross/regenerative/green/core_effect(mob/living/target, mob/user)
	if(isslime(target))
		target.visible_message("<span class='warning'>The [target] suddenly changes color!</span>")
		var/mob/living/simple_animal/slime/S = target
		S.random_colour()
	if(isjellyperson(target))
		target.reagents.add_reagent(/datum/reagent/mutationtoxin/jelly,5)


/obj/item/slimecross/regenerative/pink
	colour = "pink"
	effect_desc = ""

/obj/item/slimecross/regenerative/pink/core_effect(mob/living/target, mob/user)
	to_chat(target, "<span class='notice'>I feel more calm.</span>")
	target.reagents.add_reagent(/datum/reagent/drug/krokodil,4)

/obj/item/slimecross/regenerative/gold
	colour = "gold"
	effect_desc = ""

/obj/item/slimecross/regenerative/gold/core_effect(mob/living/target, mob/user)
	var/newcoin = pick(/obj/item/coin/silver, /obj/item/coin/iron, /obj/item/coin/gold, /obj/item/coin/diamond, /obj/item/coin/plasma, /obj/item/coin/uranium)
	var/obj/item/coin/C = new newcoin(target.loc)
	playsound(C, 'sound/blank.ogg', 50, TRUE)
	target.put_in_hand(C)

/obj/item/slimecross/regenerative/oil
	colour = "oil"
	effect_desc = ""

/obj/item/slimecross/regenerative/oil/core_effect(mob/living/target, mob/user)
	playsound(src, 'sound/blank.ogg', 100, TRUE)
	for(var/mob/living/L in view(user,7))
		L.flash_act()

/obj/item/slimecross/regenerative/black
	colour = "black"
	effect_desc = ""

/obj/item/slimecross/regenerative/black/core_effect_before(mob/living/target, mob/user)
	var/dummytype = target.type
	var/mob/living/dummy = new dummytype(target.loc)
	to_chat(target, "<span class='notice'>The milky goo flows from your skin, forming an imperfect copy of you.</span>")
	if(iscarbon(target))
		var/mob/living/carbon/T = target
		var/mob/living/carbon/D = dummy
		T.dna.transfer_identity(D)
		D.updateappearance(mutcolor_update=1)
		D.real_name = T.real_name
	dummy.adjustBruteLoss(target.getBruteLoss())
	dummy.adjustFireLoss(target.getFireLoss())
	dummy.adjustToxLoss(target.getToxLoss())
	dummy.adjustOxyLoss(200)

/obj/item/slimecross/regenerative/lightpink
	colour = "light pink"
	effect_desc = ""

/obj/item/slimecross/regenerative/lightpink/core_effect(mob/living/target, mob/user)
	if(!isliving(user))
		return
	if(target == user)
		return
	var/mob/living/U = user
	U.revive(full_heal = TRUE, admin_revive = FALSE)
	to_chat(U, "<span class='notice'>Some of the milky goo sprays onto you, as well!</span>")

/obj/item/slimecross/regenerative/adamantine
	colour = "adamantine"
	effect_desc = ""

/obj/item/slimecross/regenerative/adamantine/core_effect(mob/living/target, mob/user) //WIP - Find out why this doesn't work.
	target.apply_status_effect(STATUS_EFFECT_SLIMESKIN)

/obj/item/slimecross/regenerative/rainbow
	colour = "rainbow"
	effect_desc = ""

/obj/item/slimecross/regenerative/rainbow/core_effect(mob/living/target, mob/user)
	target.apply_status_effect(STATUS_EFFECT_RAINBOWPROTECTION)

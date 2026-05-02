// ==================== SCP-093 AI HOLDER ====================
/datum/ai_holder/simple_animal/melee/scp093
    mauling = TRUE
    vision_range = 14

/datum/say_list/scp093
    emote_hear = list("groans", "growls lowly", "makes a wet gurgling sound")
    emote_see = list("twitches unnaturally", "tilts its head", "lurches forward")

// ==================== SCP-093 MONSTER ====================
/mob/living/simple_animal/hostile/scp093
    name = "Yellow Giant"
    desc = "A towering, thin creature with pale skin and elongated limbs. Its hollow eyes stare through you."
    icon = 'icons/SCP/scp-093.dmi'
    icon_state = "monster"
    icon_living = "monster"
    icon_dead = "monster_dead"
    pixel_x = -48

    maxHealth = 3000
    health = 3000
    attack_delay = 6

    faction = "scp"
    response_help = "touches"
    response_disarm = "pushes"
    response_harm = "strikes"
    attacktext = "smashes"
    mob_size = MOB_LARGE

    status_flags = CANPUSH
    density = TRUE
    anchored = FALSE
    can_pull_size = 5
    a_intent = "harm"

    ai_holder_type = /datum/ai_holder/simple_animal/melee/scp093
    say_list_type = /datum/say_list/scp093

    // Регенерация — только когда рядом враги (реже срабатывает)
    var/heal_rate = 50
    var/heal_timer
    var/regen_interval = 15 SECONDS  // Увеличен интервал
    var/last_combat_time = 0

    // Бой
    var/attack_cooldown_time = 4 SECONDS
    var/attack_cooldown

    // Двери
    var/door_break_cooldown = 3 SECONDS  // Увеличен кулдаун

    // Звуки
    var/step_sound = 'sounds/scp/093/093_step.ogg'
    var/scp093_attack_sound = 'sounds/scp/093/093_attack.ogg'
    var/door_sound = 'sounds/effects/bang.ogg'

/mob/living/simple_animal/hostile/scp093/Initialize()
    . = ..()
    // Регенерация запускается только при необходимости
    heal_timer = addtimer(CALLBACK(src, PROC_REF(regen)), regen_interval, TIMER_STOPPABLE | TIMER_LOOP)

/mob/living/simple_animal/hostile/scp093/Destroy()
    if(heal_timer)
        deltimer(heal_timer)
    return ..()

/mob/living/simple_animal/hostile/scp093/proc/regen()
    if(stat == DEAD)
        return
    // Регенерирует только если был в бою за последние 5 минут
    if(world.time - last_combat_time < 5 MINUTES && health < maxHealth)
        health = min(health + heal_rate, maxHealth)

// ==================== ШАГИ (звук тише) ====================
/mob/living/simple_animal/hostile/scp093/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0)
    . = ..()
    if(. && stat == CONSCIOUS && isturf(loc) && prob(25))  // Звук шагов только с 25% шансом
        playsound(loc, step_sound, 20, 1)  // Тише (20 вместо 30)

// ==================== БОЙ ====================
/mob/living/simple_animal/hostile/scp093/do_attack(atom/A, turf/T)
    if(..())
        UnarmedAttack(A)

/mob/living/simple_animal/hostile/scp093/IAttack(atom/A)
    if(attack_cooldown > world.time)
        return ATTACK_ON_COOLDOWN
    return ..()

/mob/living/simple_animal/hostile/scp093/UnarmedAttack(atom/A)
    if(isliving(A))
        var/mob/living/L = A
        if(L.stat == DEAD)
            return
        if(attack_cooldown > world.time)
            return
        var/damage_amount = rand(60, 100)
        L.apply_damage(damage_amount, BRUTE)
        visible_message(SPAN_DANGER("[src] slashes [L] with tremendous force!"))
        playsound(get_turf(src), scp093_attack_sound, 50, 1)
        attack_cooldown = world.time + attack_cooldown_time
        last_combat_time = world.time  // Запоминаем время боя
        if(prob(20) && ishuman(L))
            var/mob/living/carbon/human/H = L
            var/limb_name = pick(BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
            var/obj/item/organ/external/limb = H.get_organ(limb_name)
            if(limb)
                limb.fracture()
                visible_message(SPAN_DANGER("[src] crushes [H]'s [limb.name] with tremendous force!"))
        return

    // Только взлом дверей
    if(istype(A, /obj/machinery/door))
        DestroyDoor(A)
        return

// ==================== ВЗЛОМ ДВЕРЕЙ ====================
/mob/living/simple_animal/hostile/scp093/proc/DestroyDoor(obj/machinery/door/A)
    if((world.time - door_break_cooldown) < door_break_cooldown)
        return
    if(!istype(A) || !A.density || !A.Adjacent(src))
        return

    var/open_time = 3 SECONDS
    if(istype(A, /obj/machinery/door/blast))
        open_time = 5 SECONDS

    if(istype(A, /obj/machinery/door/airlock))
        var/obj/machinery/door/airlock/AR = A
        if(AR.locked)
            open_time += 2 SECONDS
        if(AR.welded)
            open_time += 3 SECONDS
        if(AR.secured_wires)
            open_time += 3 SECONDS

    A.visible_message(SPAN_WARNING("[src] begins to pry open [A]..."))
    playsound(get_turf(A), door_sound, 30, 1)

    if(!do_after(src, open_time, A))
        return

    A.visible_message(SPAN_DANGER("[src] forcefully opens [A]!"))
    if(istype(A, /obj/machinery/door/blast))
        var/obj/machinery/door/blast/DB = A
        DB.open(TRUE)
        return

    if(istype(A, /obj/machinery/door/airlock))
        var/obj/machinery/door/airlock/AR = A
        AR.unlock(TRUE)
        AR.welded = FALSE
    A.set_broken(TRUE)
    A.open(TRUE)

// ==================== СМЕРТЬ (ОПТИМИЗИРОВАНО — БЕЗ ГИБСПАВНЕРОВ) ====================
/mob/living/simple_animal/hostile/scp093/death(gibbed, deathmessage, show_dead_message)
    ..()
    icon_state = icon_dead
    visible_message(SPAN_DANGER("[src] lets out a horrible screech and explodes into a shower of black viscera and blood!"))
    playsound(src, 'sounds/effects/splat.ogg', 100, 1)
    // Только один декал вместо спавнеров
    var/obj/effect/decal/cleanable/blood/gibs/G = new /obj/effect/decal/cleanable/blood/gibs(get_turf(src))
    G.basecolor = "#000000"
    G.update_icon()
    // Удаляем декал через 5 минут
    QDEL_IN(G, 5 MINUTES)

/mob/living/simple_animal/hostile/scp093/CanPass(atom/movable/mover, turf/target)
    return TRUE

/mob/living/simple_animal/hostile/scp093/Bump(atom/A)
    . = ..()
    if(istype(A, /obj/machinery/door))
        DestroyDoor(A)
    if(isliving(A) && canClick())
        UnarmedAttack(A)

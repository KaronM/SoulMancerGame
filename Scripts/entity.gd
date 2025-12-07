extends CharacterBody2D


@onready var spawnX = global_position.x
var maxHealth
var currentHealth

var level

var initialized: = false

var moveQueues = []
var states
var currentState
@onready var rayCast = $EntityDetection
@onready var healthBar = $HealthBar

var statusEffect: GameManager.statuses


var roundStarted

var Stun
var hurtbox


var had_moves_this_round = false


var knockedback = false
var wasKnocked = false

var lastState


var going_home = false


var hasAttacks = false


var home = false
var wasHome = true
var is_hurt = false
var is_blocking = false


var processed_index = 0

var defeated = false


var speed: int
var attack: int
var defense: int


var movesetRoundUsed = {}


func setHealth(health: int, healthBar: ProgressBar):

    if healthBar.has_method("init_health"):
        healthBar.init_health(health)
        healthBar._set_health(health)



func initialize(parent: CharacterBody2D) -> void :

    defeated = false

    GameManager.activeCharacters += 1





    $HitBoxContainer.position = Vector2.ZERO
    $HitBoxContainer.scale = Vector2.ONE
    $HitBoxContainer.rotation = 0

    for hitbox in $HitBoxContainer.get_children():
        hitbox.position = hitbox.position
        hitbox.global_position = hitbox.global_position
        hitbox.damage += (10 * attack / 100)

    if parent.is_in_group("Player"):
        parent.addMoveOptions()
        $Sprite2D.flip_h = false
    else:
        $Sprite2D.flip_h = true
        $HitBoxContainer.scale.x = -1







    Stun = $Stun
    hurtbox = $HurtBox
    hurtbox.connect("hit", Callable(self, "hurt"))
    hurtbox.connect("blocked", Callable(self, "block"))





    states = {
        "idle": $StateMachine / Idle, 
        "walk": $StateMachine / Walk, 
        "retreat": $StateMachine / Retreat, 
        "lightattack": $StateMachine / Attack1, 
        "heavyattack": $StateMachine / Attack2, 
        "block": $StateMachine / Block, 
        "uniqueattack": $StateMachine / Attack3, 
        "jump": $StateMachine / Jump, 
        "hurt": $StateMachine / Hurt, 
        "dead": $StateMachine / Dead, 
    }
    change_state(states["idle"])

    if rayCast:


        if parent.is_in_group("Player") and rayCast:
            rayCast.set_collision_mask_value(2, false)
            rayCast.set_collision_mask_value(3, true)
        else:
            rayCast.set_collision_mask_value(3, false)
            rayCast.set_collision_mask_value(2, true)



func process(parent: CharacterBody2D, delta: float) -> void :






    if parent.moveQueue.size() > 0:
        while processed_index < parent.moveQueue.size():
            var move_entry = parent.moveQueue[processed_index]

            var parts = move_entry.split(",")
            var char_name = parts[0]
            var move_name = parts[1]

            if char_name == self.name:
                moveQueues.append(move_name)
                print(name, "added move:", move_name)

            processed_index += 1


    if parent.is_in_group("Opponent"):

        if is_hurt:
            if self.global_position.x > spawnX + 1 and !knockedback and !wasKnocked:
                wasKnocked = true
                knockedback = true
                going_home = true
                home = false
                GameManager.charsAtSpawn -= 1
                print("knocked")


        if knockedback:

            if currentState != states["hurt"]:
                change_state(states["walk"], null)

                knockedback = false



        if wasKnocked and global_position.x <= spawnX + 1 and global_position.x >= spawnX - 1 and currentState == states["walk"]:

            wasKnocked = false
            going_home = false
            GameManager.charsAtSpawn += 1
            print(name, "returned home")
            change_state(states["idle"], null)

        else:
            pass

        print(moveQueues)




    elif parent.is_in_group("Player"):

        if is_hurt:
            if global_position.x < spawnX - 1 and !knockedback and !wasKnocked:
                wasKnocked = true
                knockedback = true
                going_home = true
                home = false
                GameManager.charsAtSpawn -= 1
                print("knocked")


        if knockedback:

            if currentState != states["hurt"]:
                change_state(states["walk"], null)
                print("Opponent State", wasKnocked)
                knockedback = false



        if wasKnocked and global_position.x <= spawnX + 1 and global_position.x >= spawnX - 1 and currentState == states["walk"]:

            wasKnocked = false
            going_home = false
            GameManager.charsAtSpawn += 1
            print(name, "returned home")
            change_state(states["idle"], null)

        else:
            pass





func main(delta: float, parent: CharacterBody2D, moveRanges: Dictionary) -> void :
    if !defeated:

        if statusEffect == GameManager.statuses.Shield:
            $StatusEffects.scale = Vector2(0.5, 0.5)
            $StatusIcon.scale = Vector2(0.3, 0.3)
            if self is Golem:
                $StatusEffects.scale = Vector2(0.75, 0.75)

        if statusEffect == GameManager.statuses.None:
            $StatusEffects.texture = null
            $StatusIcon.texture = null



        if rayCast.is_colliding():
            print(name, " encountered!")
            _on_entity_detection_raycast_hit()


        if currentState:
            currentState._on_physics_process(delta)

        Movement.apply_gravity(self, delta)
        move_and_slide()


        if moveQueues.size() > 0:
            if parent.is_in_group("Player"):
                rayCast.target_position = Vector2(moveRanges[moveQueues[0]], 0)
            else:
                rayCast.target_position = Vector2(-1 * moveRanges[moveQueues[0]], 0)



        if GameManager.roundStart and not roundStarted:
            roundStarted = true
            home = false
            wasHome = true





            print("raycast", rayCast.target_position)

            if currentState != states["walk"] and moveQueues.size() > 0:

                hasAttacks = true

                had_moves_this_round = true

                if moveQueues[0] == "block":
                    hurtbox.isBlocking = true
                else:
                    hurtbox.isBlocking = false



                var index = parent.characterOrder.find(self.name)
                if index > 0:
                    await get_tree().create_timer(index * 0.5).timeout



                change_state(states["walk"])


            elif moveQueues.size() == 0 and wasHome:
                rayCast.target_position = Vector2(0, 0)
                home = true
                wasHome = false
                hasAttacks = false

        elif not GameManager.roundStart:
            roundStarted = false






func change_state(new_state: State, data = null) -> State:
    if !defeated:
        if currentState:
            currentState._on_exit()
        currentState = new_state

        if currentState != states["hurt"]:
            lastState = currentState

        if currentState != states["block"]:
            is_blocking == false

        currentState._on_enter(self)
        return currentState
    else:
        return





func remove_move(move_name: String) -> void :
    if moveQueues.has(move_name):
        moveQueues.erase(move_name)


func _on_entity_detection_raycast_hit():

    if !defeated:
        print("encountered")
        if moveQueues.size() > 0:
            var move = moveQueues[0]
            if move == "LightAttack":
                change_state(states["lightattack"])
            if move == "HeavyAttack":
                change_state(states["heavyattack"])
            if move == "UniqueAttack":
                change_state(states["uniqueattack"])
            if move == "Block":
                block(null)
        else:

            change_state(states["retreat"])
            going_home = true

func dead():
    change_state(states["dead"])


func hurt(area: Area2D):
    if !is_blocking and !defeated and statusEffect != GameManager.statuses.Shield:
        var stun_duration = area.hitStun
        var damage
        if area.damage:
            damage = area.damage

        if is_hurt and currentState == states["hurt"]:
            currentState.stagger(stun_duration)
            $HealthBar.damage(area.damage)
            Movement.apply_knockback(self, area.knockback)
            return


        if !is_hurt:
            Movement.apply_knockback(self, area.knockback)
            $HealthBar.damage(area.damage)
            change_state(states["hurt"], stun_duration)
            is_hurt == true
    elif statusEffect == GameManager.statuses.Shield:
        statusEffect = GameManager.statuses.None




func block(area: Area2D):
    hurtbox.isBlocking = true

    if !defeated:
        var block_duration = 0.5
        if area:
            block_duration = area.blockStun


        if is_blocking and area and currentState == states["block"]:
            currentState.guard(area.blockStun)


        if !is_blocking and (currentState == states["block"] or currentState == states["walk"]):
            change_state(states["block"], block_duration)
            is_blocking = true

extends CharacterBody2D

var direction: Vector2 = Vector2.ZERO
var speed: float = 100.0
var enemy
var enemyInteractable
var scenetransitioned = false
var money: int = 0

var characterReserve = []
@export var startingCharacters: Array[CharacterData]


var firstStarted = false

func _ready() -> void :
    if GameManager.exitingDetected:
        GameManager.characterTeam.clear()
        global_position = GameManager.globalpos
        $Area2D.monitorable = false
        $Area2D.monitoring = false
    else:
        $Area2D.monitorable = true
        $Area2D.monitoring = true
    scenetransitioned = false
    money += GameManager.moneyGained

    $Area2D.area_entered.connect(interact)
    enemy = get_node("../OverworldEnemy")
    if GameManager.addCharacters:
        for child in get_parent().get_children():

            if "OverworldEnemy" in child.name:

                var area = child.get_node_or_null("Area2D")
                if area:
                    if not area.body_entered.is_connected(interact):
                        area.body_entered.connect(interact)

    GameManager.characterTeam.append_array(startingCharacters)




func addCharacterToTeam(characterData: CharacterData, team = []):
    var characterId = characterData.character_id

func _physics_process(delta: float) -> void :
    print(money, " money")
    if get_parent().menu.visible == false:
        direction = Vector2.ZERO


        if Input.is_action_pressed("Up"):
            direction.y -= 1
        if Input.is_action_pressed("Down"):
            direction.y += 1
        if Input.is_action_pressed("Left"):
            direction.x -= 1
        if Input.is_action_pressed("Right"):
            direction.x += 1

        direction = direction.normalized()


        velocity = direction * speed
        move_and_slide()


        if direction == Vector2.ZERO:
            $AnimatedSprite2D.play("Idle_Front")
        else:
            if direction.y < 0:
                $AnimatedSprite2D.play("Walk_Back")
            elif direction.y > 0:
                $AnimatedSprite2D.play("Walk_Front")

            if direction.x != 0:
                $AnimatedSprite2D.play("Walk_Right")
                $AnimatedSprite2D.flip_h = direction.x < 0


        if GameManager.exitingDetected:
            await get_tree().create_timer(3).timeout
            GameManager.exitingDetected = false
            $Area2D.monitorable = true
            $Area2D.monitoring = true






func createStartingCharacters():
    GameManager.characterTeam.append_array(startingCharacters)



func interact(area: Area2D):

    if area.get_parent().is_in_group("OverworldEnemy") and scenetransitioned == false:
        enemy = area.get_parent()
        $Area2D.monitorable = false
        $Area2D.monitoring = false
        print("Transitioning to new scene...")
        GameManager.enemyTeam.clear()
        GameManager.enemyTeam.append_array(enemy.characters)
        GameManager.moneyGained = enemy.moneyValue
        GameManager.experienceGained = enemy.experienceValue
        var transition = get_node("../BattleTransition")
        transition.close()
        await get_tree().create_timer(2).timeout
        get_tree().change_scene_to_file("res://Scenes/Maps/grass_plains.tscn")
        scenetransitioned = true
        GameManager.startMatch()
        GameManager.globalpos = global_position

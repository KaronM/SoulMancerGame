extends CharacterBody2D

var direction : Vector2 = Vector2.ZERO
var speed : float = 100.0
var enemy
var enemyInteractable
var scenetransitioned = false
var money : int = 0
#storing characters not in team
var characterReserve = []
@export var startingCharacters: Array[CharacterData]

#create starting characters at first
var firstStarted = false

func _ready() -> void:
	money += GameManager.moneyGained 
	$Area2D.monitorable = true
	$Area2D.monitoring = true
	$Area2D.area_entered.connect(interact)
	enemy = get_node("../OverworldEnemy")
	if GameManager.addCharacters:
		createStartingCharacters()
	
	#GameManager.characterTeam.append_array(startingCharacters)	

func addCharacterToTeam(characterData: CharacterData, team = []):
	var characterId = characterData.character_id
	
func _physics_process(delta: float) -> void:
	print(money, " money")
	if get_parent().menu.visible == false:
		direction = Vector2.ZERO
		
		# Input
		if Input.is_action_pressed("Up"):
			direction.y -= 1
		if Input.is_action_pressed("Down"):
			direction.y += 1
		if Input.is_action_pressed("Left"):
			direction.x -= 1
		if Input.is_action_pressed("Right"):
			direction.x += 1

		direction = direction.normalized()
		
		# Movement
		velocity = direction * speed
		move_and_slide()

		# Animation
		if direction == Vector2.ZERO:
			$AnimatedSprite2D.play("Idle_Front")  # default idle
		else:
			if direction.y < 0:
				$AnimatedSprite2D.play("Walk_Back")
			elif direction.y > 0:
				$AnimatedSprite2D.play("Walk_Front")

			if direction.x != 0:
				$AnimatedSprite2D.play("Walk_Right")
				$AnimatedSprite2D.flip_h = direction.x < 0


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

#create random starting characters to team 
func createStartingCharacters():
	GameManager.characterTeam.append_array(startingCharacters)	



func interact(area:Area2D):
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
		scenetransitioned=true
		GameManager.startMatch()
 		#GameManager.arenaTransitioned = false

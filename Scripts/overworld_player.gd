extends CharacterBody2D

var direction : Vector2 = Vector2.ZERO
var speed : float = 100.0
var enemy
var enemyInteractable
var scenetransitioned = false
var characterReserve = []
var firstStarted = false
func _ready() -> void:
	for child in get_parent().get_children():
		
		if "OverworldEnemy" in child.name:
			
			var area = child.get_node_or_null("Area2D")
			
			if area:
				if not area.body_entered.is_connected(interact):
					area.body_entered.connect(interact)
	
	if !firstStarted:
		createStartingCharacters()
		firstStarted = true

func addCharacterToTeam(characterData: CharacterData, team = []):
	var characterId = characterData.character_id
	
func _physics_process(delta: float) -> void:
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
	#knight
	var knight = CharacterData.new()
	#insert information
	knight.createCharacterData({"characterType": GameManager.characters.Knight, 
	"characterName": str(knight.characterType) + str(knight.characterId), 
	"level" : 5})
	#slime
	var slime = CharacterData.new()
	#insert information
	slime.createCharacterData({"characterType": GameManager.characters.Slime, 
	"characterName": str(slime.characterType) + str(slime.characterId), 
	"level" : 5})
	
	var manEater = CharacterData.new()
	#insert information
	manEater.createCharacterData({"characterType": GameManager.characters.ManEater, 
	"characterName": str(manEater.characterType) + str(manEater.characterId), 
	"level" : 5})
	
	GameManager.characterTeam.append_array([knight,slime,manEater])


func interact(body):
	if body.name == "OverworldPlayer" and scenetransitioned == false:  # Optional check, if needed
		print("Transitioning to new scene...")
		get_tree().change_scene_to_file("res://Scenes/Maps/grass_plains.tscn")  
		scenetransitioned=true
		GameManager.startMatch()
 		#GameManager.arenaTransitioned = false

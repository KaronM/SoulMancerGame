extends CharacterBody2D

var direction : Vector2 = Vector2.ZERO
var speed : float = 100.0
var enemy
var enemyInteractable
var scenetransitioned = false

func _ready() -> void:
	enemy = get_node("../OverworldEnemy")
	enemyInteractable = get_node("../OverworldEnemy/Area2D")
	
	enemyInteractable.body_entered.connect(interact)

	
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

	
func interact(body):
	if body.name == "OverworldPlayer" and scenetransitioned == false:  # Optional check, if needed
		print("Transitioning to new scene...")
		get_tree().change_scene_to_file("res://Scenes/Maps/grass_plains.tscn")  
		scenetransitioned=true
		GameManager.arenaTransitioned = false

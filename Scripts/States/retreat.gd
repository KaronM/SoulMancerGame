extends State

@onready var entity: CharacterBody2D
@onready var animationPlayer: AnimationPlayer

#parent node (Player or opponent
var parent :Node2D
var direction: int

#trigger for stopping at spawn only once at a time
var backHome = false


func _on_physics_process(delta: float) -> void:
	# Apply movement
	
	#if GameManager.roundStart:
	Movement.apply_movement(entity, delta, direction,entity.speed)
	animationPlayer.play("WalkBackward")
	# Play correct animation

	# If going home, check if we’ve reached spawn
	if entity.going_home:
			
		if (entity.global_position.x >= entity.spawnX - 1 and entity.global_position.x <= entity.spawnX + 1) and !backHome:
				_stop_at_spawn()
				backHome = true
				
	#print("Walking")
	print("retreating")

func _on_enter(owner: CharacterBody2D) -> void:
	backHome = false
	entity = owner
	parent = entity.get_parent()
	animationPlayer = entity.get_node("AnimationPlayer")
	entity.going_home = true  # start by walking away from spawn
	# Decide initial walk direction
	if parent.is_in_group("Player"):
		direction = -1  # walk left first
		entity.rayCast.target_position = Vector2(0, 0)
	else:
		direction = 1 # walk right first
		entity.rayCast.target_position = Vector2(0, 0)

func _on_exit() -> void:
	Movement.stop_movement(entity)
	animationPlayer.stop()

func _stop_at_spawn():
	print("stopped")
	Movement.stop_movement(entity)
	animationPlayer.stop()
	entity.going_home = false  # character going spawn
	entity.home = true
	entity.change_state(entity.states["idle"])

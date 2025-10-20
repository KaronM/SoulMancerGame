extends State

@onready var entity: CharacterBody2D
@onready var animationPlayer: AnimationPlayer

#parent node (Player or opponent
var parent :Node2D
var direction: int
#walking back home


func _on_physics_process(delta: float) -> void:
	# Apply movement
	
	#if GameManager.roundStart:
	Movement.apply_movement(entity, delta, direction)
	animationPlayer.play("WalkBackward")
	# Play correct animation
	'''
	if parent.is_in_group("Player") and direction == 1:
		animationPlayer.play("WalkForward")
	elif parent.is_in_group("Player") and direction == -1:
		animationPlayer.play("WalkBackward")

		
	if parent.is_in_group("Opponent") and direction == -1:
		animationPlayer.play("WalkForward")
	elif parent.is_in_group("Opponent") and direction == 1:
		animationPlayer.play("WalkBackward")
	'''	
	# If going home, check if we’ve reached spawn
	if entity.going_home:
		'''
		if parent.is_in_group("Player") and entity.global_position.x <= entity.spawnX:
			_stop_at_spawn()
		elif parent.is_in_group("Opponent") '''
		
	if (entity.global_position.x >= entity.spawnX - 1 and entity.global_position.x <= entity.spawnX + 1):
			_stop_at_spawn()
	#print("Walking")
	print("retreating")

func _on_enter(owner: CharacterBody2D) -> void:
	
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

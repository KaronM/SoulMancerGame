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
	animationPlayer.play("WalkForward")
		
	#for if behind spawn and going
	'''
	if entity.going_home:
		if entity.global_position.x == entity.spawnX:
			_stop_at_spawn()
	'''
			
	#print("Walking")
	

func _on_enter(owner: CharacterBody2D) -> void:
	entity = owner
	parent = entity.get_parent()
	animationPlayer = entity.get_node("AnimationPlayer")  # start by walking away from spawn
	# decide initial walk direction
	if parent.is_in_group("Player"):
		direction = 1  # walk left first
	else:
		direction = -1 # walk right first
		'''
	if entity.has_node("EntityDetection"):
		if parent.is_in_group("Player"):
			entity.rayCast.target_position = Vector2(10.0, -1.0)
		else:
			entity.rayCast.target_position = Vector2(-10.0, 1.0)
		'''

func _on_exit() -> void:
	Movement.stop_movement(entity)
	animationPlayer.stop()
	

#for when knocked behind spawn
func _stop_at_spawn():
	print("stopped")
	Movement.stop_movement(entity)
	animationPlayer.stop()
	entity.going_home = false  # character has reached spawn
	entity.home = true
	#see if character has been knocked back
	entity.change_state(entity.states["idle"])

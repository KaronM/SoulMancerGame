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

	Movement.apply_movement(entity, delta, direction, entity.speed)
	animationPlayer.play("WalkForward")
		
	
	#if match ended mid way
	if GameManager.matchEnd:
		entity.change_state(entity.states["idle"])
	

#entering state
func _on_enter(owner: CharacterBody2D) -> void:
	entity = owner
	parent = entity.get_parent()
	animationPlayer = entity.get_node("AnimationPlayer") 

	if parent.is_in_group("Player"):
		direction = 1  
	else:
		direction = -1 


#exiting state
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

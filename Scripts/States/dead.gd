extends State

@onready var entity : CharacterBody2D
@onready var animationPlayer : AnimationPlayer
# Called when the node enters the scene tree for the first time.
var direction : int
#Do action
func _on_process(_delta : float) -> void:
	pass

#Take Input and do action
func _on_physics_process(_delta : float) -> void:
	print("Defeated")
	Movement.apply_gravity(entity,_delta)

#
func _on_next_transitions() -> void:
	emit_signal("Defeated")

#initial state
func _on_enter(owner: CharacterBody2D) -> void:
	entity = owner
	entity.going_home = false
	animationPlayer = entity.get_node("AnimationPlayer")
	animationPlayer.play("Defeated")
	entity.velocity = Vector2.ZERO
	entity.defeated = false
	entity.moveQueues.clear()
	
	#make it undetectable to raycasts and untouchable to other bodies
	#entity.set_collision_mask_value(1, false)  # stop detecting layer 1 (ground)
	entity.set_collision_mask_value(2, false)  # stop detecting enemies
	entity.set_collision_mask_value(3, false)  # stop detecting player
	entity.set_collision_layer_value(2, false) 
	entity.set_collision_layer_value(3, false) 

	entity.set_collision_mask_value(1, false)
	entity.set_collision_layer_value(1, false)
	
	
	
	
	
	var hurtBox = entity.get_node("HurtBox")
	if hurtBox:
		hurtBox.set_collision_mask_value(5, false)
		hurtBox.set_collision_layer_value(4, false)
	GameManager.activeCharacters -= 1


#finish state
func _on_exit() -> void:
	animationPlayer.stop()

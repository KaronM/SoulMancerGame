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
	if animationPlayer.current_animation != "UniqueAttack":
		animationPlayer.play("UniqueAttack")

	
	
	
func _on_animation_finished_unique(anim_name: String) -> void:
	print("Animation finished:", anim_name)
	if anim_name == "UniqueAttack":
	
		entity.remove_move(anim_name) 
		if entity.moveQueues.size() > 0:
			entity.change_state(entity.states["walk"])
		else:
			entity.change_state(entity.states["retreat"])


#
func _on_unhandled_input(_event: InputEvent) -> void:
	pass

#
func _on_next_transitions() -> void:
	emit_signal("UniqueAttack")

#initial state
func _on_enter(owner: CharacterBody2D) -> void:
	entity = owner
	animationPlayer = entity.get_node("AnimationPlayer")
	animationPlayer.play("UniqueAttack")
	animationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished_unique"))

#finish state
func _on_exit() -> void:
	pass
	#animationPlayer.stop()

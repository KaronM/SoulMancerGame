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
	if animationPlayer.current_animation != "LightAttack":
		animationPlayer.play("LightAttack")
		print("hiya")
	
	
func _on_animation_finished_light(anim_name: String) -> void:
	if anim_name == "LightAttack":
		entity.change_state(entity.states["walk"])
		entity.remove_move(anim_name) 


#
func _on_unhandled_input(_event: InputEvent) -> void:
	pass

#
func _on_next_transitions() -> void:
	emit_signal("LightAttack")

#initial state
func _on_enter(owner: CharacterBody2D) -> void:
	entity = owner
	animationPlayer = entity.get_node("AnimationPlayer")
	animationPlayer.play("LightAttack")
	animationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished_light"))

#finish state
func _on_exit() -> void:
	pass
	#animationPlayer.stop()

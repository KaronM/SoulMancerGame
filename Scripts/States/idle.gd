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
	if animationPlayer.current_animation != "Idle":
		animationPlayer.play("Idle")
	print("Idle")

#
func _on_next_transitions() -> void:
	emit_signal("Idle")

#initial state
func _on_enter(owner: CharacterBody2D) -> void:
	entity = owner
	entity.going_home = false
	animationPlayer = entity.get_node("AnimationPlayer")
	animationPlayer.play("Idle")
	entity.velocity = Vector2.ZERO


#finish state
func _on_exit() -> void:
	animationPlayer.stop()

extends State

@onready var entity : CharacterBody2D
@onready var animationPlayer : AnimationPlayer

# Called when the node enters the scene tree for the first time.
var direction : int
const JUMP_VELOCITY = -200.0
const SPEED = 100
var jumped = false
#Do action
func _on_process(_delta : float) -> void:
	pass

#Take Input and do action
func _on_physics_process(_delta : float) -> void:
# Play jump animation
	if animationPlayer.current_animation != "Jump":
		animationPlayer.play("Jump")

# Apply jump only once
	if !jumped and entity.is_on_floor():
		entity.velocity.y = JUMP_VELOCITY
		entity.velocity.x += SPEED 
		jumped = true
# Horizontal movement
	
# Apply gravity and move
	entity.move_and_slide()

# Check landing
	if jumped and entity.is_on_floor():
		#entity.remove_move(entity.get_parent().moveQueue[0])
		entity.change_state(entity.states["walk"])
		#jumped = false
		
#
func _on_unhandled_input(_event: InputEvent) -> void:
	pass

#
func _on_next_transitions() -> void:
	emit_signal("Jump")

#initial state
func _on_enter(owner: CharacterBody2D) -> void:
	entity = owner
	animationPlayer = entity.get_node("AnimationPlayer")
	animationPlayer.play("Jump")

#finish state

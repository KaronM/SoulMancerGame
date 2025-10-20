extends State

@onready var entity : CharacterBody2D
@onready var animationPlayer : AnimationPlayer
var block = false
var blockTimerFinished = false

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:

	if !blockTimerFinished and animationPlayer.current_animation != "Block":
		animationPlayer.play("Block")

func _on_enter(owner: CharacterBody2D, stun_duration: float = 0.5) -> void:
	entity = owner
	entity.is_blocking = true
	animationPlayer = entity.get_node("AnimationPlayer")

	var anim_name = "Block"
	var base_duration = animationPlayer.get_animation(anim_name).length
	
	# Calculate how much faster or slower to play to fit the stun duration

	animationPlayer.play(anim_name)

	# Start the stun timer using the given stun duration
	if entity.has_node("Stun"):
	
		var stun_timer = entity.get_node("Stun")
		stun_timer.wait_time = stun_duration
		stun_timer.start()
		blockTimerFinished = false
	
		stun_timer.connect("timeout", Callable(self, "_on_stun_timeout"), CONNECT_ONE_SHOT)



#for when hit again within hitstunned
func guard(new_stun_duration: float) -> void:
	print("guard! extending stun...")
	animationPlayer.stop()
	# Reset timer with new stun duration
	if entity.has_node("Stun"):
		var stun_timer = entity.get_node("Stun")
		stun_timer.stop()
		stun_timer.wait_time = new_stun_duration
		stun_timer.start()
	
	# Restart animation
	animationPlayer.play("Hurt")
	
	blockTimerFinished = false
	
func _on_stun_timeout(anim_name: String) -> void:
	blockTimerFinished = true
	entity.is_blocking = false
	entity.change_state(entity.states["walk"])
	entity.remove_move(anim_name) 


func _on_exit() -> void:
	animationPlayer.speed_scale = 1.0
	entity.velocity.x = 0
	animationPlayer.stop()

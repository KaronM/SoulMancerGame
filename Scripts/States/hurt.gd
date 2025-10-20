extends State

@onready var entity : CharacterBody2D
@onready var animationPlayer : AnimationPlayer
var hurt = false
var stunTimerFinished = false

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:

	if !stunTimerFinished and animationPlayer.current_animation != "Hurt":
		animationPlayer.play("Hurt")

func _on_enter(owner: CharacterBody2D, stun_duration: float = 0.5) -> void:
	entity = owner
	entity.is_hurt = true
	animationPlayer = entity.get_node("AnimationPlayer")

	var anim_name = "Hurt"
	var base_duration = animationPlayer.get_animation(anim_name).length
	
	# Calculate how much faster or slower to play to fit the stun duration
	var speed_scale = base_duration / stun_duration
	animationPlayer.play(anim_name)
	animationPlayer.speed_scale = speed_scale

	# Start the stun timer using the given stun duration
	if entity.has_node("Stun"):
	
		var stun_timer = entity.get_node("Stun")
		stun_timer.wait_time = stun_duration
		stun_timer.start()
		stunTimerFinished = false
	
		stun_timer.connect("timeout", Callable(self, "_on_stun_timeout"), CONNECT_ONE_SHOT)

#for when hit again within hitstunned
func stagger(new_stun_duration: float) -> void:
	print("Staggered! extending stun...")
	animationPlayer.stop()
	# Reset timer with new stun duration
	if entity.has_node("Stun"):
		var stun_timer = entity.get_node("Stun")
		stun_timer.stop()
		stun_timer.wait_time = new_stun_duration
		stun_timer.start()
	
	# Restart animation
	animationPlayer.play("Hurt")
	
	# Optionally reapply animation speed scaling
	var anim_name = "Hurt"
	var base_duration = animationPlayer.get_animation(anim_name).length
	var speed_scale = base_duration / new_stun_duration
	animationPlayer.speed_scale = speed_scale
	
	stunTimerFinished = false
	
func _on_stun_timeout() -> void:
	stunTimerFinished = true
	entity.is_hurt = false
	entity.change_state(entity.lastState)

func _on_exit() -> void:
	animationPlayer.speed_scale = 1.0
	entity.velocity.x = 0
	animationPlayer.stop()

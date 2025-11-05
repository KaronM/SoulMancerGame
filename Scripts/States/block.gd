extends State
@onready var entity : CharacterBody2D
@onready var animationPlayer : AnimationPlayer
var block = false
var blockTimerFinished = false
var block_timer

func _on_process(_delta : float) -> void:
	pass

func _on_physics_process(_delta : float) -> void:
	if !blockTimerFinished and animationPlayer.current_animation != "Block":
		animationPlayer.play("Block")

func _on_enter(owner: CharacterBody2D, block_duration: float = 0.5) -> void:
	entity = owner
	entity.is_blocking = true
	animationPlayer = entity.get_node("AnimationPlayer")
	
	# disconnect any existing connections first
	if block_timer:
		if block_timer.is_connected("timeout", Callable(self, "_on_block_timeout")):
			block_timer.disconnect("timeout", Callable(self, "_on_block_timeout"))
	
	if animationPlayer.is_connected("animation_finished", Callable(self, "_on_animation_finished_block")):
		animationPlayer.disconnect("animation_finished", Callable(self, "_on_animation_finished_block"))
	
	#set up the timer
	if entity.has_node("Block"):
		block_timer = entity.get_node("Block")
		block_timer.wait_time = block_duration
		block_timer.start()
		blockTimerFinished = false
		
		#connect signals (only once!)
		block_timer.connect("timeout", Callable(self, "_on_block_timeout"), CONNECT_DEFERRED)
	
	#connect animation finished
	animationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished_block"))
	animationPlayer.play("Block")

func _on_animation_finished_block(anim_name: String) -> void:
	print("Animation finished:", anim_name)
	if anim_name == "Block":
		entity.remove_move(anim_name) 
		blockTimerFinished = true
		entity.get_node("HurtBox").isBlocking = false

func guard(new_stun_duration: float = 0.5) -> void:
	print("guard! extending stun...")
	#reset timer with new stun duration

	if block_timer:
		block_timer.stop()
		block_timer.wait_time = new_stun_duration
		block_timer.start()
		
	blockTimerFinished = false

func _on_block_timeout() -> void:  #remove anim_name parameter - timeout doesn't pass it
	print("Block timeout!")
	blockTimerFinished = true
	entity.is_blocking = false
	entity.get_node("HurtBox").isBlocking = false


	if entity.moveQueues.size() > 0:
		entity.remove_move(entity.moveQueues[0])
		entity.change_state(entity.states["walk"])

func _on_exit() -> void:
	# Disconnect signals on exit
	if block_timer and block_timer.is_connected("timeout", Callable(self, "_on_block_timeout")):
		block_timer.disconnect("timeout", Callable(self, "_on_block_timeout"))
	
	if animationPlayer and animationPlayer.is_connected("animation_finished", Callable(self, "_on_animation_finished_block")):
		animationPlayer.disconnect("animation_finished", Callable(self, "_on_animation_finished_block"))
	
	animationPlayer.speed_scale = 1.0
	entity.get_node("HurtBox").isBlocking = false
	entity.velocity.x = 0
	animationPlayer.stop()
	entity.is_blocking = false

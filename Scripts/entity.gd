extends CharacterBody2D


@onready var spawnX = global_position.x
var maxHealth
var currentHealth

var level

var initialized := false

var moveQueues = []
var states
var currentState 
@onready var rayCast = $EntityDetection
@onready var healthBar = $HealthBar
var roundStarted

var Stun
var hurtbox

#to see if it was knocked behind spawn
var knockedback = false
var wasKnocked = false
#for when coming back from hurt state
var lastState

#check if entity is going home
var going_home = false

#for checking if at spawn, False before round start
var home = false
var wasHome = true
var is_hurt = false 
var is_blocking = false
var processed_index = 0	

var defeated = false

#initialize variables of children and roots
func initialize(parent: CharacterBody2D) -> void:

	defeated = false
	#let gamemanager know character is still alive
	GameManager.activeCharacters += 1
	#hit boxes
	#parent = get_parent()
	
	#enable detections for raycasts, disable if not 

	
	$HitBoxContainer.position = Vector2.ZERO
	$HitBoxContainer.scale = Vector2.ONE
	$HitBoxContainer.rotation = 0
	
	for hitbox in $HitBoxContainer.get_children():
		hitbox.position = hitbox.position # Force refresh
		hitbox.global_position = hitbox.global_position 
	#sets orientation
	if parent.is_in_group("Player"):
		parent.addMoveOptions()
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
		$HitBoxContainer.scale.x = -1
		#flip hitboxes


	#get hurtbox and stun stuff and connect hit signal
	Stun = $Stun
	hurtbox = $HurtBox
	hurtbox.connect("hit", Callable(self, "hurt"))
	hurtbox.connect("blocked", Callable(self, "block"))
	#states
	#print(get_tree().get_root().name)
	
	
	#sets states
	states = {
		"idle": $StateMachine/Idle,
		"walk": $StateMachine/Walk,
		"retreat": $StateMachine/Retreat,
		"lightattack":$StateMachine/Attack1,
		"heavyattack":$StateMachine/Attack2,
		"block":$StateMachine/Block,
		"jumpattack":$StateMachine/Attack3,
		"jump": $StateMachine/Jump,
		"hurt": $StateMachine/Hurt,
		"dead": $StateMachine/Dead,
	}
	change_state(states["idle"])

	if rayCast:
		#rayCast.connect("raycast_hit", _on_entity_detection_raycast_hit)
		#sett collisions
		if parent.is_in_group("Player") and rayCast:
			rayCast.set_collision_mask_value(2,false) 
			rayCast.set_collision_mask_value(3,true)
		else:
			rayCast.set_collision_mask_value(3,false) 
			rayCast.set_collision_mask_value(2,true)
			


func process(parent: CharacterBody2D, delta: float) -> void:
	
	#for taking moves from parent queue to self
	if parent.moveQueue.size() > 0:
		while processed_index < parent.moveQueue.size():
			var move_entry = parent.moveQueue[processed_index]
			
			var parts = move_entry.split(",")
			var char_name = parts[0]
			var move_name = parts[1]
			
			if char_name == self.name:
				moveQueues.append(move_name)
				print(name, "added move:", move_name)
			
			processed_index += 1
	
	
	
	# if characters are knocked back behind their spawns
	if parent.is_in_group("Opponent"):
		
		if is_hurt:
			if self.global_position.x > spawnX + 1 and !knockedback and !wasKnocked:
				wasKnocked = true
				knockedback = true
				going_home = true
				home = false
				GameManager.charsAtSpawn -= 1
				print("knocked")
				
		#if activately knocked behind spawn		
		if knockedback:
			#once knocked start moving again
			if currentState != states["hurt"]:
				change_state(states["walk"], null)
				print("Opponent State", wasKnocked)
				knockedback = false
			
			
		#check if made it back home
		if wasKnocked and self.global_position.x <= spawnX + 1 and self.global_position.x >=  spawnX - 1 and currentState == states["walk"] :
			#currentState._stop_at_spawn()
			wasKnocked = false
			going_home = false
			GameManager.charsAtSpawn += 1  # only add once when arriving back
			print(name, "returned home")
			change_state(states["idle"], null)
				
		else:
			pass
			
		print(moveQueues)
		#check if defeated
		

	#player side
	elif parent.is_in_group("Player"):
		
		if is_hurt:
			if global_position.x < spawnX - 1 and !knockedback and !wasKnocked:
				wasKnocked = true
				knockedback = true
				going_home = true
				home = false
				GameManager.charsAtSpawn -= 1
				print("knocked")
				
		#if activately knocked behind spawn		
		if knockedback:
			#once knocked start moving again
			if currentState != states["hurt"]:
				change_state(states["walk"], null)
				print("Opponent State", wasKnocked)
				knockedback = false
			
			
		#check if made it back home
		if wasKnocked and global_position.x <= spawnX + 1 and global_position.x >=  spawnX - 1 and currentState == states["walk"] :
			#currentState._stop_at_spawn()
			wasKnocked = false
			going_home = false
			GameManager.charsAtSpawn += 1  # only add once when arriving back
			print(name, "returned home")
			change_state(states["idle"], null)
				
		else:
			pass
		

#Main process


func main(delta: float, parent: CharacterBody2D) -> void:
	if !defeated:
		#run current state	
		if currentState:
			currentState._on_physics_process(delta)
		#apply gravity and movement
		Movement.apply_gravity(self,delta)
		move_and_slide()
		
		
		print("Spawn is " + str(spawnX))
			
		#if knocked back too far
		
				
		if parent.is_in_group("Player") and global_position.x < spawnX-50:
			going_home = true
			change_state(states["walk"])
		#change states when round starts
		
		if GameManager.roundStart and not roundStarted:
			roundStarted = true
			home = false
			wasHome = true
			
			# move first until raycast hit
			if currentState != states["walk"] and moveQueues.size() > 0:
				change_state(states["walk"])
				if parent.is_in_group("Player"):
					rayCast.target_position = Vector2(9.9, -1.0)
				else:
					rayCast.target_position = Vector2(-9.9, -1.0)
					
				if moveQueues.size() == 1 and moveQueues[0] == "JumpAttack":
					rayCast.target_position = Vector2(10.0, -1.0)
			
			#if run out of moves
			if moveQueues.size() == 0:
				change_state(states["retreat"])
		
			#if no moves dont move
			elif moveQueues.size() <= 0 and wasHome:
				rayCast.target_position = Vector2(0, 0)
				home = true
				wasHome = false
				
		elif not GameManager.roundStart:
			roundStarted = false

		
	
#Walk first	

#serve as transitions to changing states
func change_state(new_state: State, data = null) -> State:
	if !defeated:
		if currentState:
			currentState._on_exit()
		currentState = new_state
		
		if currentState != states["hurt"]:
			lastState = currentState
		
		currentState._on_enter(self)
		return currentState
	else:
		return
	


	
#Remove Move from move queue
func remove_move(move_name: String) -> void:
	if moveQueues.has(move_name):
		moveQueues.erase(move_name)
		
#connection to raycast hit signal
func _on_entity_detection_raycast_hit():
	if !defeated:
		if moveQueues.size() > 0:
			var move = moveQueues[0]
			if move == "LightAttack":
				change_state(states["lightattack"])
			if move == "HeavyAttack":
				change_state(states["heavyattack"])
			if move == "JumpAttack":
				change_state(states["jump"])
			if move == "Block":
				change_state(states["block"])
		else:
		
			change_state(states["retreat"])
			going_home = true

func dead():
	change_state(states["dead"])

func hurt(area: Area2D):
	if !is_blocking and !defeated:
		var stun_duration = area.hitStun
		var damage
		if area.damage:
			damage = area.damage
		#when hit during stun
		if is_hurt and currentState == states["hurt"]:
			currentState.stagger(stun_duration)
			$HealthBar.damage(area.damage)
			Movement.apply_knockback(self, area.knockback)
			return

		# Otherwise, enter the hurt state normally
		if !is_hurt:
			Movement.apply_knockback(self, area.knockback)
			$HealthBar.damage(area.damage)
			change_state(states["hurt"], stun_duration)
			is_hurt == true

func block(area: Area2D):
	if !defeated:
		var block_duration
		
		var damage
		if area.damage:
			damage = area.damage

		#enter the block state 
		if !is_blocking :
			change_state(states["block"], block_duration)
			is_blocking == true

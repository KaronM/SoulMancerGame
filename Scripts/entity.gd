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

#detect if round has started, make sure round start is not activated multiple times 
var roundStarted

var Stun
var hurtbox

#for Opponent when it doesnt move
var had_moves_this_round = false

#to see if it was knocked behind spawn
var knockedback = false
var wasKnocked = false
#for when coming back from hurt state
var lastState

#check if entity is going home
var going_home = false

#detect if entity has an attacks left in move queue left
var hasAttacks = false

#for checking if at spawn, False before round start
var home = false
var wasHome = true
var is_hurt = false 
var is_blocking = false

#index when move is added to local queue from parent queue
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

	#
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
	#set_collision_mask_value(1, false)
	
	#sets states
	states = {
		"idle": $StateMachine/Idle,
		"walk": $StateMachine/Walk,
		"retreat": $StateMachine/Retreat,
		"lightattack":$StateMachine/Attack1,
		"heavyattack":$StateMachine/Attack2,
		"block":$StateMachine/Block,
		"uniqueattack":$StateMachine/Attack3,
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
	#parent generates move with character name , move. This parses it and adds the move part to local queue
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
				#print("Opponent State", wasKnocked)
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


func main(delta: float, parent: CharacterBody2D, moveRanges: Dictionary) -> void:
	if !defeated:
		
		#check if raycast is colliding
		if rayCast.is_colliding():
			print(name, " encountered!")
			_on_entity_detection_raycast_hit()
		
		#run current state	
		if currentState:
			currentState._on_physics_process(delta)
		#apply gravity and movement
		Movement.apply_gravity(self,delta)
		move_and_slide()
		
		#print(self.name, " is home ", home)
		#print("Spawn is " + str(spawnX))
		#change states when round starts


		if moveQueues.size() > 0:
			if parent.is_in_group("Player"):
				rayCast.target_position = Vector2(moveRanges[moveQueues[0]], 0)
			else:
				rayCast.target_position = Vector2(-1 * moveRanges[moveQueues[0]], 0)

	#For characters that dont move

		if GameManager.roundStart and not roundStarted:
			roundStarted = true
			home = false
			wasHome = true

			#check if first move is blocking
			
			#Actively change raycast detection for moves

			print("raycast", rayCast.target_position)
		
			if currentState != states["walk"] and moveQueues.size() > 0:
				#has attacks left
				hasAttacks = true
				
				had_moves_this_round = true
				
				if moveQueues[0] == "block":
					hurtbox.isBlocking = true
				else:
					hurtbox.isBlocking = false
				
				if parent.is_in_group("Player"):
					rayCast.target_position = Vector2(20, 0)
				else:
					rayCast.target_position = Vector2(-20, 0)
				
				#depending on order add delay between walking:
				
			
				var index = parent.characterOrder.find(self.name)
				if index > 0:  # Only if not the first character
					await get_tree().create_timer(index * 0.5).timeout
					
				#await get_tree().create_timer(characterOrder[char] * 0.5).timeout
				
				change_state(states["walk"])
				
			#if no moves dont move
			elif moveQueues.size() == 0 and wasHome:
				rayCast.target_position = Vector2(0, 0)
				home = true
				wasHome = false
				hasAttacks = false
				
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
		
		if currentState != states["block"]:
			is_blocking == false
	
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
		print("encountered")
		if moveQueues.size() > 0:
			var move = moveQueues[0]
			if move == "LightAttack":
				change_state(states["lightattack"])
			if move == "HeavyAttack":
				change_state(states["heavyattack"])
			if move == "UniqueAttack":
				change_state(states["uniqueattack"])
			if move == "Block" :
				block(null)
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
	hurtbox.isBlocking = true
	
	if !defeated:
		var block_duration = 0.5
		if area:
			block_duration = area.blockStun
		
		#if hit while blocking
		if is_blocking and area and currentState == states["block"]:
			currentState.guard(area.blockStun)
			
		#enter the block state 
		if !is_blocking and (currentState == states["block"] or currentState == states["walk"]):
			change_state(states["block"], block_duration)
			is_blocking = true
	

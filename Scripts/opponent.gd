extends CharacterBody2D

var team =[GameManager.characters.Slime,GameManager.characters.ManEater,GameManager.characters.Slime]
var actionTokens : int = 5
var currentCharacter
var currentCharacterPath : String 
var character_instance
var moveQueue = []
var characterInstances = []
var currentMoveset = {}
var usedTokens = 0
var player
var selectedCharacter
var characterOrder = []

#make sure that moves made are 
var movesGenerated = false
#when the round actually starts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("../Player")
	
	var currentCharacter = team[0]  # this is 1 (Slime)

	print(currentCharacterPath)
	
	for i in range(team.size()):
		var char = team[i]
		var currentCharacterPath = GameManager.characterPaths.get(char)
		var scene : PackedScene = load(currentCharacterPath)
	
		if scene:
			var instance = scene.instantiate()
			instance.name = "Opponent_%d" % i
			add_child(instance)
			instance.set_collision_layer_value(3, true) 
			instance.set_collision_layer_value(1, false) 
			instance.set_collision_mask_value(2,true) 
			instance.set_collision_mask_value(1,true)
			characterInstances.append(instance)


			# Properly space them out so they don't overlap
			instance.position = Vector2(i * 25, 0)
			instance.spawnX = instance.global_position.x
				
			#set selected
			if i == 0:
				selectedCharacter = instance
			else:
				print("Failed to load character for ID:", char)
				

#add random moves for enemies to use
func generateMoves():
	characterOrder.clear()
	for char in characterInstances:
		characterOrder.append(str(char.name))

	while usedTokens <= actionTokens and characterInstances.size() > 0:
		# Choose random character out of team
		var randSelectIndex = randi() % characterInstances.size()
		selectedCharacter = characterInstances[randSelectIndex]

		# Pick random move out of moveset
		var randMove = randi() % selectedCharacter.moveset.size() 

		# Append move to movequeue
		var move = selectedCharacter.moveset.keys()[randMove]
		moveQueue.append(selectedCharacter.name + "," + move)

		# Subtract cost from remaining stars (ONLY ONCE!)
		usedTokens += selectedCharacter.moveset[move]

		print(selectedCharacter.name + " uses " + move)
		
func refreshActionTokens():
	usedTokens = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(characterOrder, " Order")
	
	if !GameManager.roundStart and !movesGenerated:
		characterInstances = characterInstances.filter(func(c): return not c.defeated)
		generateMoves()
		movesGenerated = true
		

	elif GameManager.roundStart and movesGenerated:
		#for when characters dont move
	
		movesGenerated = false
		moveQueue.clear()
		
		#reset processing of move queues in individual characters after clearing main queue
		for char in characterInstances:
			char.processed_index = 0
			
		
		refreshActionTokens()
		
		
		
	print("opponent queue ", moveQueue)	

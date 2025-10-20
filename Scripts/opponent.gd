extends CharacterBody2D

var team =[GameManager.characters.Slime, GameManager.characters.Slime]
var actionTokens : int = 5
var currentCharacter
var currentCharacterPath : String 
var character_instance
var moveQueue = []
var characterInstances = []
var currentMoveset = {}
var usedTokens = 0
var player
var roundStart = GameManager.roundStart
var roundInProgress = GameManager.roundInProgress
var selectedCharacter
#when the round actually starts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	roundStart = GameManager.roundStart
	roundInProgress = GameManager.roundInProgress
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
				



func refreshActionTokens():
	usedTokens = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(self.name)
	roundStart = GameManager.roundStart
	roundInProgress = GameManager.roundInProgress
	print("roundStarted", roundStart)

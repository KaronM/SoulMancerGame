extends Node2D


var entity: CharacterBody2D
var Player: CharacterBody2D
var Opponent: CharacterBody2D

# for characters going to spawn
var charsAtSpawn = 0

var matchEnd = false
var playersDefeated = false
var opponentsDefeated = false
var arenaTransitioned = false
var activeCharacters = 0
enum characters {
	None,
	Slime,
	Dummy,
}


enum gameStates{
	None,
	Overworld,
	InBattle,
}

var roundStart
var roundInProgress 

func go_home():
	pass


var characterPaths = {characters.Slime: "res://Scenes/Characters/slime.tscn",
characters.Dummy: "res://Scenes/Characters/training_dummy.tscn"}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#preload player
	#Opponent = root_scene.get_node("Opponent")
	roundStart = false
	roundInProgress = false # Replace with function body.
	#charsAtSpawn = 0

func endRound():
	roundStart = false
	roundInProgress = false


func _process(delta: float) -> void:
	# if player isn't loaded
	if not Player:
		var root = get_tree().current_scene
		if root:
			Player = root.get_node_or_null("Player")
			Opponent = root.get_node_or_null("Opponent")
		if not Player:
			return
	
	#if player is loaded and see if all characters go to spawn to end round
	if Player:
		var characters = []
		characters.append_array(Player.characterInstances)
		characters.append_array(Opponent.characterInstances)
		
		print("char = ", characters.size())
		
		print("active", activeCharacters)
		#detect if characters made it back to spawn to end round
		for character in characters:
			if character.defeated == false:
				print(character)
			if !character.defeated and character.home == true :
				charsAtSpawn += 1
				print("back at spawn = ", charsAtSpawn, " active = ", activeCharacters)
				character.home = false
				if charsAtSpawn >= activeCharacters:
					await get_tree().create_timer(0.5).timeout
					endRound()
					charsAtSpawn = 0
					
					
		
		if activeCharacters == 0 and !arenaTransitioned:
			arenaTransitioned = true
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://Scenes/overworld.tscn")  
		
	
	

extends Node2D


var entity: CharacterBody2D
var Player: CharacterBody2D
var Opponent: CharacterBody2D

#to pass to player and enemy for ingame instantiation
var characterTeam = []
var enemyTeam = []
var won = false
#array of all characters created for character data (for character Ids)
var characterCounter = 0

#for during match
var experienceGained:int = 0
var moneyGained:int = 0

# for characters going to spawn
var charsAtSpawn = 0

#for the starting and ending of matches
var matchStarted = false
var matchEnd = false
var matchStart = false

#transitioning from arena back to overworld
var arenaTransitioning = false
var activeCharacters = 0

#flag for determining when to add characters or not
var addCharacters = true

var rounds = 1

#types of characters
enum characters {
	None,
	Slime,
	Dummy,
	Knight,
	ManEater,
	Sentinel,
	Golem,
}


#statuses
enum statuses {
	None,
	Poison,
	Shield,
	Burn,
	Heal,

}

var statusIcons = { #on top of character to show what it has
	statuses.Shield: "res://Assets/Effects/shield.png",
}

var statusEffects = { # for display on or around character (poison drip, fire burn, shield bubble)
	statuses.Shield: "res://Assets/Effects/shielding.png",
}


enum gameStates{
	None,
	Overworld,
	InBattle,
}

var roundStart = false
#var roundInProgress = false

func go_home():
	pass


var characterPaths = {characters.Slime: "res://Scenes/Characters/slime.tscn",
characters.Dummy: "res://Scenes/Characters/training_dummy.tscn",
characters.Knight: "res://Scenes/Characters/knight.tscn",
characters.ManEater: "res://Scenes/Characters/man_eater.tscn",
characters.Sentinel: "res://Scenes/Characters/sentinel.tscn",
characters.Golem: "res://Scenes/Characters/golem.tscn"}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func endRound():
	rounds += 1
	roundStart = false
	
	Player.roundInProgress = false
	Player.resetMoves()
	
	
	#redraw selection on first character
	Player.selectIndex = 0
	
	if Player.characterInstances.size() > 0:
		Player.selectedCharacter = Player.characterInstances[0]
		Player.addMoveOptions()
	charsAtSpawn = 0
	
	#roundInProgress = false
	
func startMatch():
	arenaTransitioning = false
	matchStart = false
	matchEnd = false
	charsAtSpawn = 0    # Reset counter
	activeCharacters = 0 # This should be set when characters spawn
	set_process(true)
	
#show end match screen
func endMatch():

	
	var arena = get_node("/root/GrassPlains/Arena")
	arena.get_node("PlayerOptions/Control").hide()
	var roundEndLabel = arena.get_node("RoundEndLabel/NinePatchRect")
	var tween = get_tree().create_tween()
	tween.tween_property(roundEndLabel,"position",Vector2(350,150),0.3)
	var exitButton = roundEndLabel.get_node("Button")
	
	exitButton.connect("pressed", Callable(self, "exitMatch"))
	exitButton.call_deferred("grab_focus")
	
	if won:
		roundEndLabel.get_node("Experience").text = "Experience Earned: " + str(experienceGained)
		roundEndLabel.get_node("Money").text = "Experience Earned: " + str(moneyGained)
	else:
		roundEndLabel.get_node("Experience").text = "Experience Earned: 0"
		roundEndLabel.get_node("Money").text = "Experience Earned: 0"
	
	for character in characterTeam:
		character.currentExp += experienceGained
		
	
	#arena.createCharacterLevelLabels()
	
	#disable process
	set_process(false)
	
	matchEnd = true
	matchStart = false
	roundStart = false
	
#reset match and round vars for next match
func exitMatch():
	rounds = 1
	matchStart = false
	activeCharacters = 0
	matchEnd = false
	roundStart = false
	won = false
	enemyTeam.clear()
	await get_tree().process_frame
	
	#print("arenaTransitioned")
	var transition = get_node("/root/GrassPlains/BattleTransition")
	transition.close()
	
	
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scenes/overworld.tscn") 
	
	



func _process(delta: float) -> void:
	
	# if player isn't loaded (overworld)
	#print(enemyTeam, "enemy")
	
	
	
	if not Player:
		var root = get_tree().current_scene
		if root:
			Player = root.get_node_or_null("Player")
			Opponent = root.get_node_or_null("Opponent")
		if not Player:
			return
	
	
	
	#if match first started:

	#if player is loaded and see if all characters go to spawn to end round (in match)
	if Player:
		#add characters and opponents to groups
		for char in Player.characterInstances:
			char.add_to_group("character")
		
		for enemy in Opponent.characterInstances:
			enemy.add_to_group("enemy")
		
		#reset roundEnding
		var characters = []
		characters.append_array(Player.characterInstances)
		characters.append_array(Opponent.characterInstances)
		
		var charactersHome = []
		#print("char = ", characters.size())
		
	
		#detect if characters made it back to spawn to end round
		for character in characters:
			
		
			#if match ended midbattle, make sure match is
			if !character.defeated and character.home == true :
				charsAtSpawn += 1
				#print("back at spawn = ", charsAtSpawn, " active = ", activeCharacters)
				character.home = false
				if charsAtSpawn >= activeCharacters: #and !roundEnding:
					endRound()
		print("player team size: ", characterTeam.size(), " enemy team size: ", enemyTeam.size())
			
		print("active: ", activeCharacters," chars home: ", charsAtSpawn)	
			
		#count enemies who died
		var opponentsDefeated = 0
		for enemy in Opponent.characterInstances:
			if enemy.defeated:
				opponentsDefeated += 1
		
		#count players who died
		var playersDefeated = 0
		for player in Player.characterInstances:
			if player.defeated:
				playersDefeated += 1
				
		#if all players or opponents dead
		if playersDefeated == Player.characterInstances.size() and !matchEnd: #lose
			won = false
			experienceGained = 0
			moneyGained = 0
			endMatch()
		if opponentsDefeated == Opponent.characterInstances.size() and !matchEnd: #win
			won = true
			endMatch()
	
			
		

	

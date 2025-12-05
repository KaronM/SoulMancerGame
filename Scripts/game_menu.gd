extends CanvasLayer

var selectedChar: CharacterData = null
var selectedCharTex: AtlasTexture = null
var levelExpMultiplier :int = 40#for increase
var added

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 #Replace with function body.
	#await get_tree().create
	addCharactersToPartySelect()
	if GameManager.addCharacters:
		
		GameManager.addCharacters = false
		
	else:
		return
	
	


func addCharactersToPartySelect():
	var team = get_node_or_null("MarginContainer/HBoxContainer/VBoxContainer2/NinePatchRect/Party/Team")
	for i in range(GameManager.characterTeam.size()):
		#make sure it doesnt extend past it
		if i+1 <= 3:
			var box = team.get_node("MarginContainer" + str(i + 1))
			var button = box.get_node("Button")
			var char = GameManager.characterTeam[i]
			if button.has_method("loadCharacter"):
				button.loadCharacter(char)
		
	

func loadCharacterData():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var levelProgress = $MarginContainer/HBoxContainer/VBoxContainer2/NinePatchRect/Stats/VBoxContainer2/StatBox/LevelProgress
	var progressBar = levelProgress.get_node("ProgressBar")
	
	
	if selectedChar:
		print(selectedChar.characterName, "semi")
		
		
	if selectedCharTex:
		var statchar = $MarginContainer/HBoxContainer/VBoxContainer2/NinePatchRect/Stats/VBoxContainer2/NinePatchRect/TextureRect
		var stats = $MarginContainer/HBoxContainer/VBoxContainer2/NinePatchRect/Stats/VBoxContainer2/StatBox/Stat
		
		
		stats.get_node("Level").text = "Level: " + str(selectedChar.level)
		stats.get_node("Health").text = "Health: " + str(selectedChar.maxHealth)
		stats.get_node("Attack").text = "Attack: " + str(selectedChar.attack)
		stats.get_node("Speed").text = "Speed: " + str(selectedChar.speed)
		
		progressBar.value = selectedChar.currentExp 
		progressBar.max_value = selectedChar.level * 40
		
		if progressBar.value >= progressBar.max_value:
			selectedChar.level_up()
			progressBar.value -= progressBar.max_value
			
		levelProgress.get_node("Label").text = "Exp until Next Level: " + str( int(progressBar.max_value-progressBar.value)) 
		
		
		statchar.texture= selectedCharTex
			
		
	pass

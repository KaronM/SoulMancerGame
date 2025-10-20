extends CharacterBody2D

var team =[GameManager.characters.Slime,GameManager.characters.Slime]
var tokens = 7
var actionTokens : int = tokens
var usedTokens
#for character instantiation
var currentCharacter
var currentCharacterPath : String 
var moveQueue = []
var characterInstances = []
var currentMoveset = {}
var actionbar
var selectedCharacter
var playerOptions
var action
var selection 
var moveRecord 
var selectIndex
var font
var moveAdded = false
#toggle of startButton
@onready var roundStart: bool = GameManager.roundStart
#when the round actually starts
@onready var roundInProgress: bool= GameManager.roundInProgress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	font = load("res://Assets/Gui/ARCADECLASSIC.TTF")

	selectIndex = 0
	usedTokens = 0
	
	#access to player options 
	playerOptions = get_node("/root/GrassPlains/Arena/PlayerOptions/Control/Moves/NinePatchContainer/VBoxContainer/Moveset")
	
	#Access Move Record
	moveRecord = get_node("/root/GrassPlains/Arena/PlayerOptions/Control/MovesRecord/NinePatchContainer/VBoxContainer/ScrollContainer/MoveQueue")
	
	#get selection icon
	selection = $Selection
	 
	#create total action tokens
	actionbar = get_node("../Arena/ActionTokenBar/NinePatchRect/VBoxContainer")
	action = load("res://Scenes/action_token.tscn")
	for num in actionTokens:
		if action:
			var childtoken = action.instantiate()
			actionbar.add_child(childtoken)
			childtoken.position = Vector2(50 * num,39)
			childtoken.scale = Vector2(2.531,2.31)
			childtoken.offset.x = 25
			
	#instantiate characters
	for i in range(team.size()):
		var char = team[i]
		var currentCharacterPath = GameManager.characterPaths.get(char)
		var scene : PackedScene = load(currentCharacterPath)

		if scene:
			var instance = scene.instantiate()
			instance.name = "Character_%d" % i
			add_child(instance)
			instance.set_collision_layer_value(2, true) 
			instance.set_collision_layer_value(1, false) 
			instance.set_collision_mask_value(1,true) 
			instance.set_collision_mask_value(3,true)
			characterInstances.append(instance)

			# Properly space them out so they don't overlap
			instance.position = Vector2(i * -25, 0)
			instance.spawnX = instance.global_position.x
			# First instance is selected by default
			if i == 0:
				selectedCharacter = instance
			else:
				print("Failed to load character for ID:", char)
				
	changeSelection(0)
	addMoveOptions()

#Add move buttons to options window
func addMoveOptions():
	if selectedCharacter:
		var buttonHolder = playerOptions
		
		# Clear old buttons
		for child in buttonHolder.get_children():
			child.queue_free()
		
		# Loop through moves
		for move_name in selectedCharacter.moveset.keys():
			
			var first_button_set = false  # Track if we’ve focused the first button yet
			
			# Create a horizontal container for each row (button + star)
			var row = HBoxContainer.new()
			row.size_flags_vertical = Control.SIZE_EXPAND  # Stretch vertically
			row.alignment = BoxContainer.ALIGNMENT_BEGIN
			buttonHolder.add_child(row)

			
			# Create the move button
			var btn = Button.new()
			
			btn.text = str(move_name)
			btn.add_theme_font_override("font", font)
			btn.add_theme_font_size_override("font_size", 20)
			btn.pressed.connect(func():
				on_move_pressed(selectedCharacter.name + ',' + move_name)
			)
			if not first_button_set:
				btn.call_deferred("grab_focus")
				first_button_set = true
			
			btn.custom_minimum_size = Vector2(300, 50)
			row.add_child(btn)
			

			# Add the star next to the button
			var star
			for i in selectedCharacter.moveset[move_name]:
				star = action.instantiate()
				if star is AnimatedSprite2D:
					star.play('On')
					var tex: Texture2D = star.sprite_frames.get_frame_texture(
						star.animation,
						star.frame
					)
					if tex:
						var star_textrect = TextureRect.new()
						star_textrect.texture = tex
						star_textrect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
						star_textrect.custom_minimum_size = Vector2(48, 48)
						row.add_child(star_textrect)
				else:
					print("⚠️ No texture found for move:", star)

			
			
			

func changeSelection(selectIndex: int):
	selection.scale = Vector2(1.25,1.25)
	selectedCharacter = characterInstances[selectIndex]
	selection.position.x = selectedCharacter.position.x

	
#start round using button
func startRound():
	if !roundInProgress:
		GameManager.roundStart = true
		GameManager.roundInProgress = true
		#make it so that they are not home
		selection.visible = false

		print(moveQueue)
		resetMoves()
		



func on_move_pressed(move_name: String) -> void:
	
	print("Selected move:", move_name)
	var icons = selectedCharacter.get_node("AttackPreviewContainer")
	var remainingTokens = actionTokens - usedTokens
	
		#move part of move name
	var parts = move_name.split(",")
	var move = parts[1]
	if selectedCharacter.moveset[move] <= remainingTokens and GameManager.roundStart == false:
		
		var row = HBoxContainer.new()
		row.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		#add labels to move record
		var label = Label.new()
		label.text = "   " + str(move)
		label.add_theme_font_override("font", font)
		label.add_theme_font_size_override("font_size", 20)
		label.modulate = Color(1, 1, 1, 1)
		label.size_flags_horizontal = 0
		row.add_child(label)
		
		# get move icon 
		if icons.has_node(move):
			var icon_sprite = icons.get_node(move)
			if icon_sprite is AnimatedSprite2D:
				var tex: Texture2D = icon_sprite.sprite_frames.get_frame_texture(
					icon_sprite.animation,
					icon_sprite.frame
				)
				if tex:
					var icon_texrect = TextureRect.new()
					icon_texrect.texture = tex
					icon_texrect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
					icon_texrect.custom_minimum_size = Vector2(20, 20)
					row.add_child(icon_texrect)
				else:
					print("⚠️ No texture found for move:", move)
			else:
				print("⚠️ Node is not an AnimatedSprite2D:", move)
		else:
			print("⚠️ No icon found for move:", move)
		
		moveRecord.add_child(row)
		var scroll = moveRecord.get_parent()  # The ScrollContainer
		await get_tree().process_frame      # Wait a frame so layout updates
		scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value
		
	#Add cost to each move
		usedTokens += selectedCharacter.moveset[move]
	#Add move to movequeue
		moveQueue.append(move_name)

func refreshActionTokens():
	for i in actionTokens:
		actionbar.get_child(i).play("On")
	usedTokens = 0
	

func resetMoves():
	if !roundInProgress:
		refreshActionTokens()
		#selectedCharacter.moveQueues.clear()
		for child in  moveRecord.get_children():
			child.queue_free()

#remove move from queue
func remove_move(move_name: String) -> void:
	if moveQueue.has(move_name):
		moveQueue.erase(move_name)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#detect if all characters made it back to spawn
	
	#Set selection of current character, backwards because of new child instantiated left of old
	if Input.is_action_just_pressed("Left") and selectIndex < team.size()-1:
		selectIndex += 1 
		changeSelection(selectIndex)
		addMoveOptions()
	elif Input.is_action_just_pressed("Right") and  selectIndex > 0:
		selectIndex -= 1 
		changeSelection(selectIndex)
		addMoveOptions()
		
	if Input.is_action_just_pressed("Reset") and GameManager.roundStart == false:
		resetMoves()
		refreshActionTokens()
	if Input.is_action_just_pressed("Start") and GameManager.roundStart == false:
		startRound()
	
	#make it so that they are not home
	#Refresh When Round End
	print("selected:", selectIndex)
	if GameManager.roundStart == false:
		for i in usedTokens:
			if usedTokens <= actionTokens:
				actionbar.get_child(i).play("Off")
				
		#enable selection icon
		if selectedCharacter.is_on_floor():
			selection.visible = true
			selection.position = selectedCharacter.position + Vector2(0,-5)
			
	
		if !selectedCharacter:
			addMoveOptions()
	

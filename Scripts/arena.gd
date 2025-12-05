extends Node2D

@onready var playerNode = get_parent().get_node("Player")
@onready var player = playerNode.get_child(1)
@onready var enemyNode = get_parent().get_node("Opponent")
@onready var enemy = enemyNode.get_child(1)
@onready var cam = $Camera2D
@onready var actionBar = $ActionTokenBar/NinePatchRect/VBoxContainer
@onready var startButton = $StartButton/Control/TextureButton
var center
var Player

#add space between camera ends to fit characters
#for zooming both sides before match starts to check enemies
var inspect = false
func _ready() -> void:
	set_process(true)
	#cam.global_position.y = playerNode.global_position.y +2000
	#$PlayerOptions/Control.visible = false
	$PlayerOptions.hide()
# ensure all children hide
	$Start.show()
	$Control.hide()
	cam.offset.y = 30
	

	cam.zoom = calculate_zoom_for_players(playerNode.position, enemyNode.position)
	actionBar 

	var tween = get_tree().create_tween()
	tween.tween_property($Labels/HBoxContainer, "position", Vector2(0, 0), 0.2)
	
	center = (playerNode.position + enemyNode.position) / 2
	cam.global_position = center
	Player =  get_node("../Player")
	
	var transition = get_node("../BattleTransition")
	transition.open()
	

func _process(delta: float) -> void:
	
	#print("labes position", $Labels/HBoxContainer.position)
	
	if GameManager.matchStart:
		$Control.show()
		$PlayerOptions.show()
		$Start.hide()
		
		
		
		
		#reset in case of glitch
		
		
		
		if !GameManager.roundStart:
			
			#update round count
			$Control/Round/Label.text = "Round " + str(GameManager.rounds)  
			
			if(Input.is_action_just_pressed("Inspect")):
				toggleInspect()
			#print("inspect", inspect)
			
			var tween = get_tree().create_tween()
			
			if inspect: 
				center = (playerNode.position + enemyNode.position) / 2
				
				#move labels down
				tween.tween_property($Labels/HBoxContainer, "position", Vector2(0, 0), 0.2)
				#move stars down
				tween.tween_property($ActionTokenBar/NinePatchRect, "position", Vector2(0, 50), 0.05)
			else:
				center = Player.selectedCharacter.global_position
				
				#Move labels up
				tween.tween_property($Labels/HBoxContainer, "position", Vector2(0, -200), 0.2)
				#move stars up
				tween.tween_property($ActionTokenBar/NinePatchRect, "position", Vector2(0, 0), 0.05)
				
		
		else:
			var tween = get_tree().create_tween()
			center = (playerNode.position + enemyNode.position) / 2
			inspect = false
			tween.tween_property($Labels/HBoxContainer, "position", Vector2(0, 0), 0.2)
			#move stars down
			tween.tween_property($ActionTokenBar/NinePatchRect, "position", Vector2(0, 50), 0.05)
		
			
			
		cam.global_position = center
		cam.zoom = calculate_zoom_for_players(playerNode.global_position, enemyNode.global_position)
		
	#to reset in case of bug stuckage
	if Input.is_action_just_pressed("Menu"):
		GameManager.roundStart = false
		GameManager.matchStart = false
		GameManager.matchEnd = false
		GameManager.Player.roundInProgress = false 
		GameManager.charsAtSpawn = 0
		GameManager.activeCharacters = 0
		GameManager.rounds = 1
		set_process(false)
		get_parent().get_tree().reload_current_scene()
				
			
#for displaying levels in the end
func createCharacterLevelLabels():

	var RoundEndLevels = $RoundEndLabel/Levels

	#load character image in level displays
	for chars in GameManager.characterTeam:
		
		var currentCharacterPath = GameManager.characterPaths.get(chars.characterType)
		var char_scene = load(currentCharacterPath)
		var char = char_scene.instantiate()
		var scene_state = char_scene.get_state()
		var levelBar = ProgressBar.new()
		var currentExpLabel = Label.new()
		var sprite = TextureRect.new()  # CHANGED THIS LINE - was Sprite2D.new()
		var height 
		# Configure TextureRect
		sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		sprite.custom_minimum_size = Vector2(32, 32)  # Set appropriate size
		
		#look inside the scene for the node "AttackPreviewContainer/Idle"
		for k in range(scene_state.get_node_count()):
			var path = str(scene_state.get_node_path(k))
			if path.ends_with("AttackPreviewContainer/Idle"):
				
				var tex: Texture2D = null
				var region_enabled := false
				var region_rect := Rect2()
				for j in range(scene_state.get_node_property_count(k)):
					var prop_name = scene_state.get_node_property_name(k, j)
					match prop_name:
						"texture":
							tex = scene_state.get_node_property_value(k, j)
						"region_enabled":
							region_enabled = scene_state.get_node_property_value(k, j)
						"region_rect":
							region_rect = scene_state.get_node_property_value(k, j)
				#create cropped icon preview
				if tex:
					if region_enabled:
						# Create an atlas texture to show only the region
						var atlas := AtlasTexture.new()
						atlas.atlas = tex
						atlas.region = region_rect
						sprite.texture = atlas
						height = atlas.get_height()
					else:
						sprite.texture = tex
					
					print("added")
				else:
					print("⚠️ No texture found in", currentCharacterPath)
				break
			
	
		RoundEndLevels.add_child(sprite)
		RoundEndLevels.add_child(levelBar)
		sprite.position.y= 200
		levelBar.size = Vector2(500,15)
		


func toggleInspect():
	inspect = !inspect
	
# ----------------------------
func calculate_zoom_for_players(p1: Vector2, p2: Vector2) -> Vector2:
	var viewport_size = get_viewport_rect().size

	#distance between players
	var dist = abs(p2.x - p1.x)*2

	#add buffer space behind 
	var buffer = 5

# Calculate required zoom so both fit in viewport
# Zoom in Godot: smaller zoom → zoom out, bigger zoom → zoom in
# So zoom = viewport_size / world_units_to_fit
	var viewport_width = get_viewport_rect().size.x
	var zoom_x = viewport_width/(dist + buffer)   # this gives world units ratio
	var zoom_val = clamp(zoom_x, 2.85, 4.0)  # clamp to min/max zoom

	# Return uniform zoom vector for Camera2D
	return Vector2(zoom_val, zoom_val)


#sfx manager --------------------
func _input(event):
	if event.is_action_pressed("ui_up") or \
	   event.is_action_pressed("ui_down") or \
	   event.is_action_pressed("ui_left") or \
	   event.is_action_pressed("ui_right"):
		SoundManager.play_nav()
		
	if event.is_action_pressed("ui_accept"):
		SoundManager.play_sword()
 
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_TAB:
				SoundManager.play_ding()
			KEY_R:
				SoundManager.play_cancel()

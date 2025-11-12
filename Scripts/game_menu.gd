extends CanvasLayer





# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	 #Replace with function body.
	addCharactersToPartySelect()


func addCharactersToPartySelect():
	var team = get_node("MarginContainer/HBoxContainer/VBoxContainer2/NinePatchRect/Party/Team")

	for i in range(GameManager.characterTeam.size()):
		var box = team.get_node("MarginContainer" + str(i + 1))
		var button = box.get_node("Button")
		var char = GameManager.characterTeam[i]

		#load character scene (path is a string)
		var currentCharacterPath: String = GameManager.characterPaths.get(char.characterType)
		var character_scene: PackedScene = load(currentCharacterPath)
		var scene_state = character_scene.get_state()
		
		#look inside the scene for the node "AttackPreviewContainer/LightAttack"
		for k in range(scene_state.get_node_count()):
			var path = str(scene_state.get_node_path(k))
			if path.ends_with("AttackPreviewContainer/LightAttack"):
				print("Found LightAttack node at:", path)

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
					var texrect := TextureRect.new()
					texrect.texture = tex
					texrect.custom_minimum_size = Vector2(10, 10)
					texrect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

					if region_enabled:
						# Create an atlas texture to show only the region
						var atlas := AtlasTexture.new()
						atlas.atlas = tex
						atlas.region = region_rect
						texrect.texture = atlas

					# Replace button texture with cropped preview
					button.texture_normal = texrect.texture
				else:
					print("⚠️ No texture found in", currentCharacterPath)
				break
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

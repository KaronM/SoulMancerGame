extends TextureButton

@export var characterData: CharacterData = null
@export var characterTexture: AtlasTexture = null

func _ready() -> void :
    connect("pressed", pressed)
    pass


func loadCharacter(charData: CharacterData):
    if charData:

        characterData = charData



        var currentCharacterPath = GameManager.characterPaths.get(characterData.characterType)
        var char_scene = load(currentCharacterPath)
        var char = char_scene.instantiate()

        var scene_state = char_scene.get_state()


        for k in range(scene_state.get_node_count()):
            var path = str(scene_state.get_node_path(k))
            if path.ends_with("AttackPreviewContainer/Idle"):
                print("Found LightAttack node at:", path)

                var tex: Texture2D = null
                var region_enabled: = false
                var region_rect: = Rect2()


                for j in range(scene_state.get_node_property_count(k)):
                    var prop_name = scene_state.get_node_property_name(k, j)
                    match prop_name:
                        "texture":
                            tex = scene_state.get_node_property_value(k, j)
                        "region_enabled":
                            region_enabled = scene_state.get_node_property_value(k, j)
                        "region_rect":
                            region_rect = scene_state.get_node_property_value(k, j)


                if tex:
                    var texrect: = TextureRect.new()
                    texrect.texture = tex
                    texrect.custom_minimum_size = Vector2(10, 10)
                    texrect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

                    if region_enabled:

                        var atlas: = AtlasTexture.new()
                        atlas.atlas = tex
                        atlas.region = region_rect
                        texrect.texture = atlas


                    texture_normal = texrect.texture
                    characterTexture = texrect.texture
                else:
                    print("⚠️ No texture found in", currentCharacterPath)
                break





func _process(delta: float) -> void :
    print(characterData, "zeme")
    if has_focus():
        modulate = Color("000000ae")
    else:
        modulate = Color("ffffffae")


func pressed():
    get_owner().selectedChar = characterData
    get_owner().selectedCharTex = characterTexture
    print(get_owner().selectedChar.characterType, "zelle")
    pass

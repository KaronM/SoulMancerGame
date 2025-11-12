extends TextureButton

@export var characterData: CharacterData = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func loadCharacter(charData: CharacterData):
	#load character data
	characterData = charData
	
	#load character image
	
	var currentCharacterPath = GameManager.characterPaths.get(characterData.characterType)
	var sprite = currentCharacterPath.get_node("AttackPreviewContainer/LightAttack")
	texture_normal = sprite
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Resource
class_name CharacterData

@export var characterId: int 
@export var characterType:GameManager.characters
@export var characterName: String = ""
@export var level: int = 1
@export var currentExp: int = 0
@export var maxHealth: int = 100

# Level-based movesets
@export var movesetsLevel = {
	"LightAttack" : 1,
	"HeavyAttack" : 1,
	"Block" : 5,
	
}

# Equipment/items
@export var equippedItems: Array[String] = []
@export var inventory: Array[String] = []

# Stats that scale with level
@export var base_attack: int = 10
@export var base_defense: int = 5

# Get current moveset based on level
func get_current_moveset() -> Dictionary:
	var current_moveset = {}
	
	#build moveset from all unlocked levels
	for move in movesetsLevel.keys():
		var unlockLevel = movesetsLevel[move]
		if level >= unlockLevel:
			current_moveset.merge(movesetsLevel[unlockLevel])
	
	return current_moveset

#level up functionality
func level_up() -> void:
	level += 1
	maxHealth += 10
	base_attack += 2
	base_defense += 1

# Save/load helper
func from_dict() -> Dictionary:
	return {
		"characterId": characterId,
		"characterName": characterName,
		"level": level,
		"currentExp": currentExp,
		"maxHealth": maxHealth,
		"equipped_items": equippedItems,
		"inventory": inventory,
	}


#insert data when creating character
func createCharacterData(data: Dictionary) -> void:
	characterId = GameManager.characterCounter #generates id by looking at gamemanger character counter
	GameManager.characterCounter += 1  #adding 1 to character counter for next character id
	characterType = data.get("characterType", GameManager.characters.None)
	characterName = data.get("characterName", "")
	level = data.get("level", 1)
	currentExp = data.get("current_exp", 0)
	maxHealth = data.get("max_health", 100)
	'''
	equipped_items = data.get("equipped_items", [""])
	inventory = data.get("inventory", [""])
	'''

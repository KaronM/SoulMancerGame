extends Resource
class_name CharacterData

@export var character_id: GameManager.characters
@export var character_name: String = ""
@export var level: int = 1
@export var current_exp: int = 0
@export var max_health: int = 100

# Level-based movesets
@export var movesetsLevel = {
	"LightAttack" : 1,
	"HeavyAttack" : 1,
	"Block" : 5,
	
}

# Equipment/items
@export var equipped_items: Array[String] = []
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
	max_health += 10
	base_attack += 2
	base_defense += 1

# Save/load helper
func to_dict() -> Dictionary:
	return {
		"character_id": character_id,
		"character_name": character_name,
		"level": level,
		"current_exp": current_exp,
		"max_health": max_health,
		"equipped_items": equipped_items,
		"inventory": inventory,
	}

func from_dict(data: Dictionary) -> void:
	character_id = data.get("character_id", 0)
	character_name = data.get("character_name", "")
	level = data.get("level", 1)
	current_exp = data.get("current_exp", 0)
	max_health = data.get("max_health", 100)
	equipped_items = data.get("equipped_items", [])
	inventory = data.get("inventory", [])

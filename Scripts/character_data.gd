extends Resource
class_name CharacterData

@export var characterId: int
@export var characterType: GameManager.characters
@export var characterName: String = ""
@export var level: int = 1
@export var currentExp: int = 0
@export var maxHealth: int = 100
@export var attack: int = 20
@export var speed: int = 50


@export var experienceValue: int = 10


@export var movesetsLevel = {
    "LightAttack": 1, 
    "HeavyAttack": 1, 
    "Block": 5, 
}


@export var equippedItems: Array[String] = []
@export var inventory: Array[String] = []


@export var base_defense: int = 5


func get_current_moveset() -> Dictionary:
    var current_moveset = {}


    for move in movesetsLevel.keys():
        var unlockLevel = movesetsLevel[move]
        if level >= unlockLevel:
            current_moveset.merge(movesetsLevel[unlockLevel])

    return current_moveset


func level_up() -> void :
    level += 1
    maxHealth += 10
    attack += 5
    speed += 3



func from_dict() -> Dictionary:
    return {
        "characterId": characterId, 
        "characterName": characterName, 
        "level": level, 
        "currentExp": currentExp, 
        "maxHealth": maxHealth, 
        "equipped_items": equippedItems, 
        "inventory": inventory, 
        "attack": attack, 
        "speed": speed, 
        "experienceValue": experienceValue, 
    }



func createCharacterData(data: Dictionary) -> void :
    characterId = GameManager.characterCounter
    GameManager.characterCounter += 1
    characterType = data.get("characterType", GameManager.characters.None)
    characterName = data.get("characterName", "")
    level = data.get("level", 1)
    currentExp = data.get("currentExp", 0)
    maxHealth = data.get("maxHealth", 100)
    attack = data.get("attack", 20)
    speed = data.get("speed", 20)
    experienceValue = data.get("experienceValue", 10)
    "\n\tequipped_items = data.get(\"equipped_items\", [\"\"])\n\tinventory = data.get(\"inventory\", [\"\"])\n\t"

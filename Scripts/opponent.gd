extends CharacterBody2D

var team = [GameManager.characters.Slime]
var actionTokens: int = 5
var currentCharacter
var currentCharacterPath: String
var character_instance
var moveQueue = []
var characterInstances = []
var currentMoveset = {}
var usedTokens = 0
var player
var selectedCharacter
var characterOrder = []




var movesGenerated = false



func _ready() -> void :
    player = get_node("../Player")

    var currentCharacter = GameManager.enemyTeam[0]

    print(currentCharacterPath)

    for i in range(GameManager.enemyTeam.size()):
        var char = GameManager.enemyTeam[i]
        var currentCharacterPath = GameManager.characterPaths.get(char.characterType)
        var scene: PackedScene = load(currentCharacterPath)

        if scene:
            var instance = scene.instantiate()
            instance.setHealth(char.maxHealth, instance.get_node("HealthBar"))
            instance.speed = 100 + (10 * (char.speed / 100))
            instance.attack = char.attack
            instance.name = "Opponent_%d" % i
            add_child(instance)
            instance.set_collision_layer_value(3, true)
            instance.set_collision_layer_value(1, false)
            instance.set_collision_mask_value(2, true)
            instance.set_collision_mask_value(1, true)
            characterInstances.append(instance)



            instance.position = Vector2(i * 25, 0)
            instance.spawnX = instance.global_position.x


            if i == 0:
                selectedCharacter = instance
            else:
                print("Failed to load character for ID:", char)



func generateMoves():
    characterOrder.clear()
    for char in characterInstances:
        characterOrder.append(str(char.name))

    while usedTokens <= actionTokens and characterInstances.size() > 0:

        var randSelectIndex = randi() % characterInstances.size()
        selectedCharacter = characterInstances[randSelectIndex]


        var randMove = randi() % selectedCharacter.moveset.size()


        var move = selectedCharacter.moveset.keys()[randMove]
        moveQueue.append(selectedCharacter.name + "," + move)


        usedTokens += selectedCharacter.moveset[move]

        print(selectedCharacter.name + " uses " + move)

func refreshActionTokens():
    usedTokens = 0

func applyStatus(status: GameManager.statuses):
    for char in characterInstances:
        if char.defeated != true:
            var icon = load(GameManager.statusIcons[status])
            var effect = load(GameManager.statusEffects[status])
            char.statusEffect = status
            char.get_node("StatusIcon").texture = icon
            char.get_node("StatusEffects").texture = effect

func removeStatuses():
    for char in characterInstances:
        char.get_node("StatusIcon").texture = null
        char.get_node("StatusEffects").texture = null
        char.get_node("StatusEffects2").texture = null



func _process(delta: float) -> void :
    print(characterOrder, " Order")

    for char in characterInstances:
        if char is Sentinel and char.applyShielding == true:
            applyStatus(GameManager.statuses.Shield)



    if !GameManager.roundStart and !movesGenerated:
        characterInstances = characterInstances.filter( func(c): return not c.defeated)
        generateMoves()
        movesGenerated = true


    elif GameManager.roundStart and movesGenerated:


        movesGenerated = false
        moveQueue.clear()


        for char in characterInstances:
            char.processed_index = 0


        refreshActionTokens()



    print("opponent queue ", moveQueue)

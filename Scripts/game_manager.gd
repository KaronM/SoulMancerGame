extends Node2D


var entity: CharacterBody2D
var Player: CharacterBody2D
var Opponent: CharacterBody2D

var globalpos: Vector2
var exitingDetected: bool = false
var key_count: int = 0


var characterTeam = []
var enemyTeam = []
var won = false

var characterCounter = 0


var experienceGained: int = 0
var moneyGained: int = 0


var charsAtSpawn = 0


var matchStarted = false
var matchEnd = false
var matchStart = false


var arenaTransitioning = false
var activeCharacters = 0


var addCharacters = true

var rounds = 1


enum characters{
    None, 
    Slime, 
    Dummy, 
    Knight, 
    ManEater, 
    Sentinel, 
    Golem, 
}



enum statuses{
    None, 
    Poison, 
    Shield, 
    Burn, 
    Heal, 

}

var statusIcons = {
    statuses.Shield: "res://Assets/Effects/shield.png", 
}

var statusEffects = {
    statuses.Shield: "res://Assets/Effects/shielding.png", 
}


enum gameStates{
    None, 
    Overworld, 
    InBattle, 
}

var roundStart = false


func go_home():
    pass


var characterPaths = {characters.Slime: "res://Scenes/Characters/slime.tscn", 
characters.Dummy: "res://Scenes/Characters/training_dummy.tscn", 
characters.Knight: "res://Scenes/Characters/knight.tscn", 
characters.ManEater: "res://Scenes/Characters/man_eater.tscn", 
characters.Sentinel: "res://Scenes/Characters/sentinel.tscn", 
characters.Golem: "res://Scenes/Characters/golem.tscn"}


func _ready() -> void :
    pass

func endRound():
    rounds += 1
    roundStart = false

    Player.roundInProgress = false
    Player.resetMoves()



    Player.selectIndex = 0

    if Player.characterInstances.size() > 0:
        Player.selectedCharacter = Player.characterInstances[0]
        Player.addMoveOptions()
    charsAtSpawn = 0



func startMatch():
    arenaTransitioning = false
    matchStart = false
    matchEnd = false
    charsAtSpawn = 0
    activeCharacters = 0
    set_process(true)


func endMatch():


    var arena = get_node("/root/GrassPlains/Arena")
    arena.get_node("PlayerOptions/Control").hide()
    var roundEndLabel = arena.get_node("RoundEndLabel/NinePatchRect")
    var tween = get_tree().create_tween()
    tween.tween_property(roundEndLabel, "position", Vector2(350, 150), 0.3)
    var exitButton = roundEndLabel.get_node("Button")

    exitButton.connect("pressed", Callable(self, "exitMatch"))
    exitButton.call_deferred("grab_focus")

    if won:
        roundEndLabel.get_node("Experience").text = "Experience Earned: " + str(experienceGained)
        roundEndLabel.get_node("Money").text = "Experience Earned: " + str(moneyGained)
    else:
        roundEndLabel.get_node("Experience").text = "Experience Earned: 0"
        roundEndLabel.get_node("Money").text = "Experience Earned: 0"

    for character in characterTeam:
        character.currentExp += experienceGained





    set_process(false)

    matchEnd = true
    matchStart = false
    roundStart = false
    exitingDetected = true


func exitMatch():
    rounds = 1
    matchStart = false
    activeCharacters = 0
    matchEnd = false
    roundStart = false
    won = false
    enemyTeam.clear()
    await get_tree().process_frame




    var transition = get_node("/root/GrassPlains/BattleTransition")
    transition.close()


    await get_tree().create_timer(2).timeout
    get_tree().change_scene_to_file("res://Scenes/overworld_old.tscn")





func _process(delta: float) -> void :






    if not Player:
        var root = get_tree().current_scene
        if root:
            Player = root.get_node_or_null("Player")
            Opponent = root.get_node_or_null("Opponent")
        if not Player:
            return






    if Player:

        for char in Player.characterInstances:
            char.add_to_group("character")

        for enemy in Opponent.characterInstances:
            enemy.add_to_group("enemy")


        var characters = []
        characters.append_array(Player.characterInstances)
        characters.append_array(Opponent.characterInstances)

        var charactersHome = []




        for character in characters:



            if !character.defeated and character.home == true:
                charsAtSpawn += 1

                character.home = false
                if charsAtSpawn >= activeCharacters:
                    endRound()
        print("player team size: ", characterTeam.size(), " enemy team size: ", enemyTeam.size())

        print("active: ", activeCharacters, " chars home: ", charsAtSpawn)


        var opponentsDefeated = 0
        for enemy in Opponent.characterInstances:
            if enemy.defeated:
                opponentsDefeated += 1


        var playersDefeated = 0
        for player in Player.characterInstances:
            if player.defeated:
                playersDefeated += 1


        if playersDefeated == Player.characterInstances.size() and !matchEnd:
            won = false
            experienceGained = 0
            moneyGained = 0
            endMatch()
        if opponentsDefeated == Opponent.characterInstances.size() and !matchEnd:
            won = true
            endMatch()

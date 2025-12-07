extends CharacterBody2D


var team = []


var actionTokens: = 7


var usedTokens

var actionbar

var action


var currentCharacter


var currentCharacterPath: String


var moveQueue = []


var characterInstances = []


var selectedCharacter


var playerOptions


var moveRecord


var selection

var selectIndex


var font


var characterOrder = []


@onready var roundStart: bool = GameManager.roundStart

var roundInProgress = false


func _ready() -> void :
    font = load("res://Assets/Gui/ARCADECLASSIC.TTF")

    selectIndex = 0
    usedTokens = 0

    team.append_array(GameManager.characterTeam)



    actionbar = get_node("../Arena/ActionTokenBar/NinePatchRect/VBoxContainer")
    action = load("res://Scenes/action_token.tscn")

    playerOptions = get_node("/root/GrassPlains/Arena/PlayerOptions/Control/Moves/NinePatchContainer/VBoxContainer/Moveset")

    moveRecord = get_node("/root/GrassPlains/Arena/PlayerOptions/Control/MovesRecord/NinePatchContainer/VBoxContainer/ScrollContainer/MoveQueue")


    selection = $Selection
    selection.visible = false


    for num in actionTokens:
        if action:
            var childtoken = action.instantiate()
            actionbar.add_child(childtoken)
            childtoken.position = Vector2(50 * num, 39)
            childtoken.scale = Vector2(2.531, 2.31)
            childtoken.offset.x = 25


    for i in range(team.size()):

        var char = team[i]
        print(char)

        var currentCharacterPath = GameManager.characterPaths.get(char.characterType)

        var scene: PackedScene = load(currentCharacterPath)

        if scene:
            var instance = scene.instantiate()
            instance.setHealth(char.maxHealth, instance.get_node("HealthBar"))
            instance.speed = 100 + (10 * (char.speed / 100))
            instance.attack = char.attack
            instance.name = "Character_%d" % i
            add_child(instance)
            instance.set_collision_layer_value(2, true)
            instance.set_collision_layer_value(1, false)
            instance.set_collision_mask_value(1, true)
            instance.set_collision_mask_value(3, true)
            characterInstances.append(instance)


            instance.position = Vector2(i * -25, 0)
            instance.spawnX = instance.global_position.x

            if i == 0:
                selectedCharacter = instance
            else:
                print("Failed to load character for ID:", char)

    changeSelection(0)
    addMoveOptions()


func changeTeam():
    var overWorldPlayer



func addMoveOptions():
    if selectedCharacter:
        var buttonHolder = playerOptions


        for child in buttonHolder.get_children():
            child.queue_free()


        for move_name in selectedCharacter.moveset.keys():

            var first_button_set = false


            var row = HBoxContainer.new()
            row.size_flags_vertical = Control.SIZE_EXPAND
            row.alignment = BoxContainer.ALIGNMENT_BEGIN
            buttonHolder.add_child(row)



            var btn = Button.new()

            btn.text = str(selectedCharacter.movesetNames[str(move_name)])
            btn.add_theme_font_override("font", font)
            btn.add_theme_font_size_override("font_size", 20)
            btn.pressed.connect( func():
                on_move_pressed(selectedCharacter.name + "," + move_name)
            )
            if not first_button_set:
                btn.call_deferred("grab_focus")
                first_button_set = true

            btn.custom_minimum_size = Vector2(300, 50)
            row.add_child(btn)



            var star
            var starbox = HBoxContainer.new()
            var label = Label.new()
            label.text = str(selectedCharacter.moveset[str(move_name)])
            label.add_theme_color_override("font_color", Color.YELLOW)
            label.add_theme_font_override("font", font)
            label.add_theme_font_size_override("font_size", 45)

            star = action.instantiate()
            if star is AnimatedSprite2D:

                star.play("On")
                var tex: Texture2D = star.sprite_frames.get_frame_texture(
                    star.animation, 
                    star.frame
                )
                if tex:
                    var star_textrect = TextureRect.new()
                    star_textrect.texture = tex
                    star_textrect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
                    star_textrect.custom_minimum_size = Vector2(48, 48)
                    row.add_child(starbox)
                    starbox.add_child(label)
                    starbox.add_child(star_textrect)


                    if selectedCharacter.statBoosters.has(str(move_name)):
                        var cooldowntex = load("res://Assets/Gui/Upgrade.png")
                        var round_textrect = TextureRect.new()
                        round_textrect.texture = cooldowntex
                        round_textrect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
                        round_textrect.custom_minimum_size = Vector2(32, 32)
                        starbox.add_child(round_textrect)


            else:
                print("⚠️ No texture found for move:", star)





func changeSelection(selectIndex: int):
    if GameManager.matchStart and !roundInProgress:
        selection.scale = Vector2(1.25, 1.25)
        selectedCharacter = characterInstances[selectIndex]
        selection.position.x = selectedCharacter.position.x



func startRound():
    if GameManager.matchStart:
        if !roundInProgress:
            GameManager.roundStart = true
            roundInProgress = true

            selection.visible = false
            print(moveQueue)


            "\n\t\t\tfor character in characterInstances:\n\t\t\t\tif character.moveQueues.size() == 0:\n\t\t\t\t\tcharacter.home = true\n\t\t\t"






func on_move_pressed(move_name: String) -> void :
    if GameManager.matchStart:


        print(selectedCharacter.movesetRoundUsed, "rounds")

        var icons = selectedCharacter.get_node("AttackPreviewContainer")
        var remainingTokens = actionTokens - usedTokens


        var parts = move_name.split(",")
        var move = parts[1]




        if selectedCharacter.moveset[move] <= remainingTokens and !GameManager.roundStart:

            if ( !selectedCharacter.movesetRoundUsed.has(move) or (GameManager.rounds - selectedCharacter.movesetRoundUsed[move]) >= selectedCharacter.movesetCooldowns[move]):

                if selectedCharacter.movesetCooldowns[move] > 0:
                    print("heckler")
                    selectedCharacter.movesetRoundUsed[move] = GameManager.rounds

                    print(GameManager.rounds - selectedCharacter.movesetRoundUsed[move], "rounds")

                var row = HBoxContainer.new()
                row.size_flags_horizontal = Control.SIZE_SHRINK_CENTER



                var currentCharIndex
                if characterOrder.has(selectedCharacter.name):
                    currentCharIndex = characterOrder.find(selectedCharacter.name) + 1
                else:
                    currentCharIndex = characterOrder.size() + 1


                var label = Label.new()
                label.text = str(currentCharIndex) + "   " + str(move)
                label.add_theme_font_override("font", font)
                label.add_theme_font_size_override("font_size", 18)
                label.modulate = Color(1, 1, 1, 1)
                label.size_flags_horizontal = 0
                row.add_child(label)


                if icons.has_node(move):
                    var icon_sprite = icons.get_node(move)
                    if icon_sprite is Sprite2D:
                        var tex: Texture2D = icon_sprite.texture
                        if tex:
                            var icon_texrect = TextureRect.new()
                            var region_enabled = icon_sprite.region_enabled
                            if region_enabled:
                                var region = icon_sprite.region_rect

                                var atlas_tex: = AtlasTexture.new()
                                atlas_tex.atlas = tex
                                atlas_tex.region = region
                                icon_texrect.texture = atlas_tex
                            else:
                                icon_texrect.texture = tex

                            icon_texrect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
                            icon_texrect.custom_minimum_size = Vector2(48, 48)
                            icon_texrect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
                            row.add_child(icon_texrect)
                        else:
                            print("⚠️ No texture found for move:", move)
                    else:
                        print("⚠️ Node is not an AnimatedSprite2D:", move)
                else:
                    print("⚠️ No icon found for move:", move)


                moveRecord.add_child(row)
                var scroll = moveRecord.get_parent()
                await get_tree().process_frame
                scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value


                usedTokens += selectedCharacter.moveset[move]

                moveQueue.append(move_name)


                if characterOrder.size() <= characterInstances.size():
                    if !characterOrder.has(str(selectedCharacter.name)):
                        characterOrder.append(str(selectedCharacter.name))
                        drawOrderLabels(selectedCharacter)



func refreshActionTokens():
    for i in actionTokens:
        actionbar.get_child(i).play("On")
    usedTokens = 0


func drawOrderLabels(char: CharacterBody2D):
    var label = Label.new()
    label.text = str(characterOrder.find(char.name) + 1)
    label.add_theme_font_override("font", font)
    label.add_theme_font_size_override("font_size", 200)
    label.modulate = Color(0, 0, characterOrder.size() * 100, 1)
    char.get_node("HealthBar").add_child(label)
    label.position = Vector2(0, -200)


func resetMoves():
    if !roundInProgress:
        refreshActionTokens()

        for child in moveRecord.get_children():
            child.queue_free()


        characterOrder.clear()


        for child in characterInstances:
            child.movesetRoundUsed.clear()
            var health_bar = child.get_node("HealthBar")
            for node in health_bar.get_children():
                if node is Label:
                    node.queue_free()



func remove_move(move_name: String) -> void :
    if moveQueue.has(move_name):
        moveQueue.erase(move_name)


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
    print("order of", characterOrder)

    print(GameManager.matchStart, " started and ", GameManager.roundStart, " Round Started ")
    print("instances ", characterInstances)


    characterInstances = characterInstances.filter( func(c): return not c.defeated)


    for char in characterInstances:
        if char is Sentinel and char.applyShielding == true:
            applyStatus(GameManager.statuses.Shield)


    if Input.is_action_just_pressed("Left") and selectIndex < characterInstances.size() - 1:
        selectIndex += 1
        changeSelection(selectIndex)
        addMoveOptions()
    elif Input.is_action_just_pressed("Right") and selectIndex > 0:
        selectIndex -= 1
        changeSelection(selectIndex)
        addMoveOptions()

    if Input.is_action_just_pressed("Reset") and !GameManager.roundStart:
        resetMoves()

    if !GameManager.matchStart and Input.is_action_just_pressed("Start") and !GameManager.roundStart:
        GameManager.matchStart = true
    elif GameManager.matchStart and Input.is_action_just_pressed("Start") and !GameManager.roundStart:
        startRound()




    print("round in progres: ", roundInProgress)
    if !GameManager.roundStart:
        for i in usedTokens:
            if usedTokens <= actionTokens:
                actionbar.get_child(i).play("Off")


        if selectedCharacter.is_on_floor():

            if GameManager.matchStart:
                selection.visible = true
                selection.position = selectedCharacter.position + Vector2(0, -5)


        if !selectedCharacter:
            addMoveOptions()

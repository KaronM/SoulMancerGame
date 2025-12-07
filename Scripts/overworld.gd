extends Node2D

var menu
var menuFirstOption
var partyMenu

func _ready() -> void :

    menu = $GameMenu
    menuFirstOption = $GameMenu / MarginContainer / HBoxContainer / VBoxContainer / NinePatchRect / Menu / Options / MarginContainer / PartyBtn
    menu.visible = false
    partyMenu = false
    menuFirstOption.connect("pressed", Callable(self, "togglePartyMenu"))
    $BattleTransition.show()
    $BattleTransition.open()



func toggleMenu():
    if menu.visible:
        menuFirstOption.release_focus()
    else:
        menuFirstOption.grab_focus()
    menu.visible = !menu.visible

func togglePartyMenu():
    if !partyMenu:
        var tween = get_tree().create_tween()
        tween.tween_property($GameMenu / MarginContainer, "position", Vector2(250, 0), 0.2)
        partyMenu = true
    else:
        var tween = get_tree().create_tween()
        tween.tween_property($GameMenu / MarginContainer, "position", Vector2(850, 0), 0.2)
        partyMenu = false




func _process(delta: float) -> void :
    if Input.is_action_just_pressed("Menu"):
        toggleMenu()

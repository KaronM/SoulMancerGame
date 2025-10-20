extends Node2D

var menu
var menuFirstOption
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#menu
	menu = $GameMenu
	menuFirstOption = $GameMenu/MarginContainer/HBoxContainer/VBoxContainer/NinePatchRect/Menu/Options/MarginContainer/PartyBtn
	menu.visible = false
	
 # Replace with function body.

func toggleMenu():
	if menu.visible:
		menuFirstOption.release_focus()
	else:
		menuFirstOption.grab_focus()
	menu.visible = !menu.visible




		
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Menu"):
		toggleMenu()

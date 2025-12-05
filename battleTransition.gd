extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#$Options/VBoxContainer/Attack1.pressed.connect() # Replace with function body.

func open():
	var tween = create_tween()
	tween.tween_property($ScreenHolder1, "position", Vector2(-1152,0), 0.2)
	tween.tween_property($ScreenHolder2, "position",Vector2(1152,0), 0.2)

func close():
	var tween = create_tween()
	tween.tween_property($ScreenHolder1, "position", Vector2.ZERO, 0.2)
	tween.tween_property($ScreenHolder2, "position",Vector2.ZERO, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

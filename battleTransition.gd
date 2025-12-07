extends CanvasLayer



func _ready() -> void :
    pass


func open():
    var tween = create_tween()
    tween.tween_property($ScreenHolder1, "position", Vector2(-1152, 0), 0.2)
    tween.tween_property($ScreenHolder2, "position", Vector2(1152, 0), 0.2)

func close():
    var tween = create_tween()
    tween.tween_property($ScreenHolder1, "position", Vector2.ZERO, 0.2)
    tween.tween_property($ScreenHolder2, "position", Vector2.ZERO, 0.2)


func _process(delta: float) -> void :
    pass

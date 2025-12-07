extends Area2D

const END_SCREEN_PATH = "res://Scenes/end_screen.tscn"

var is_active = false
var text_fully_displayed = false
var current_tween: Tween

func _ready():
    $CanvasLayer.visible = false
    $CanvasLayer / PanelContainer / Label.visible_ratio = 1.0

func _on_body_entered(body):
    if body.is_in_group("Player") and not is_active:
        start_sequence()

func start_sequence():
    is_active = true

    $VictoryMusic.play()

    get_tree().paused = true

    $CanvasLayer.visible = true
    var label = $CanvasLayer / PanelContainer / Label
    label.visible_ratio = 0.0

    current_tween = create_tween().set_trans(Tween.TRANS_LINEAR)

    current_tween.tween_property(label, "visible_ratio", 1.0, 3.0)

    current_tween.finished.connect( func(): text_fully_displayed = true)

func _input(event):
    if not is_active:
        return

    if event.is_action_pressed("ui_accept"):
        if not text_fully_displayed:
            if current_tween:
                current_tween.kill()
            $CanvasLayer / PanelContainer / Label.visible_ratio = 1.0
            text_fully_displayed = true

        else:
            get_tree().paused = false
            get_tree().change_scene_to_file(END_SCREEN_PATH)

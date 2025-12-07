extends Area2D


@onready var flash_rect = $CanvasLayer / ColorRect

func _ready() -> void :

    flash_rect.modulate.a = 0.0

func _on_body_entered(body: Node2D) -> void :
    if body.is_in_group("Player"):
        trigger_teleport_sequence(body)

func trigger_teleport_sequence(player_body: Node2D) -> void :

    var tween = create_tween()


    tween.tween_property(flash_rect, "modulate:a", 1.0, 0.1)


    tween.tween_callback( func(): _teleport_logic(player_body))


    tween.tween_property(flash_rect, "modulate:a", 0.0, 0.5)

func _teleport_logic(player_body):

    player_body.set_position($SpawnPointDesert.global_position)

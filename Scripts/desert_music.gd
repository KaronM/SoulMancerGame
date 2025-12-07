extends Area2D

var new_music = preload("res://Assets/Audio/music/ogg/23. Pyramid.ogg")

@onready var music_player = $"../../BGMusic"

func _on_body_entered(body: Node2D) -> void :
    if body.name == "OverworldPlayer":
        if music_player.stream != new_music:
            change_music_smoothly(new_music)

func change_music_smoothly(new_stream):
    var tween = create_tween()

    tween.tween_property(music_player, "volume_db", -80, 0.7)

    tween.tween_callback( func():
        music_player.stream = new_stream
        music_player.play()
    )

    tween.tween_property(music_player, "volume_db", 0, 0.0)

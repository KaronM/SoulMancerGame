extends Area2D

var new_music = preload("res://Assets/Audio/music/ogg/02. Lively City.ogg")

@onready var music_player = $"../../BGMusic"

func _on_body_entered(body: Node2D) -> void :
    if body.name == "OverworldPlayer":
        if music_player.stream != new_music:
            music_player.stream = new_music
            music_player.play()

extends Node

var sfx_player: AudioStreamPlayer

var sword_sound = preload("res://Assets/Audio/sfx/sword_sound.mp3")
var nav_sound = preload("res://Assets/Audio/sfx/menu_sound.mp3")
var ding_sound = preload("res://Assets/Audio/sfx/ding_sound.mp3")
var cancel_sound = preload("res://Assets/Audio/sfx/cancel_sound.mp3")

func _ready():
    sfx_player = AudioStreamPlayer.new()
    add_child(sfx_player)
    sfx_player.bus = "SFX"

func play_sword():
    sfx_player.stream = sword_sound
    sfx_player.play()

func play_nav():
    sfx_player.stream = nav_sound
    sfx_player.play()

func play_ding():
    sfx_player.stream = ding_sound
    sfx_player.play()

func play_cancel():
    sfx_player.stream = cancel_sound
    sfx_player.play()

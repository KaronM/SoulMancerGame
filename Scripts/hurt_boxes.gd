extends Node2D

signal hit

func _ready() -> void :
    pass



func _process(delta: float) -> void :
    if body_entered:
        emit_signal("hit")

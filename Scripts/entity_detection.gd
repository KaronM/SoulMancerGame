extends RayCast2D

signal raycast_hit()

var last_hit = null

func _physics_process(delta):
    if is_colliding():
        emit_signal("raycast_hit")
    else:
        last_hit = null

func _ready() -> void :
    pass



func _process(delta: float) -> void :
    pass

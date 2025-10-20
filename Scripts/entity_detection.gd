extends RayCast2D

signal raycast_hit()

var last_hit = null  # to prevent spamming signals

func _physics_process(delta):
	if is_colliding():
		emit_signal("raycast_hit")
	else:
		last_hit = null

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

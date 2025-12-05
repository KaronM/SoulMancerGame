extends ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if value >= max_value:
		max_value *= 2 # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

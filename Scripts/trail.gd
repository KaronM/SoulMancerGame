extends Line2D
class_name Trail

#store points for trail
var queue : Array
@export var maxLength: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var pos = get_parent().global_position
	
	queue.push_front(pos)
	
	if queue.size() > maxLength:
		queue.pop_back()
	clear_points()
	
	for point in queue:
		add_point(point)

extends Line2D
class_name Trail


var queue: Array
@export var maxLength: int

func _ready() -> void :
    pass



func _process(delta: float) -> void :
    var pos = get_parent().global_position

    queue.push_front(pos)

    if queue.size() > maxLength:
        queue.pop_back()
    clear_points()

    for point in queue:
        add_point(point)

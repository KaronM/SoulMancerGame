extends ProgressBar



func _ready() -> void :
    if value >= max_value:
        max_value *= 2



func _process(delta: float) -> void :
    pass

extends ProgressBar


#set by setter method
var  healthiness = 0: set = _set_health 

func init_health(max_health: float) -> void:
	max_value = max_health
	value = max_health
	healthiness = max_health

func _set_health(new_health: float) -> void:
	value = clamp(new_health, 0, max_value)
	healthiness = value

	if value <= 0 and !get_parent().defeated:
		get_parent().dead()
		get_parent().defeated = true


func damage(damage: float )-> void:
	_set_health(healthiness-damage)

func _ready() -> void:
	pass

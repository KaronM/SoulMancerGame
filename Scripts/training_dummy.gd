extends Entity
#All potential States

#moves and their action token costs
var moveset = {}



func _ready() -> void:
	
	#initialize character
	super.initialize(get_parent())


func _process(delta: float) -> void:
	super.process(get_parent(), delta)
	
func _physics_process(delta: float) -> void:
	super.main(delta, get_parent())

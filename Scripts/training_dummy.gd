extends Entity



var moveset = {}



func _ready() -> void :


    super.initialize(get_parent())


func _process(delta: float) -> void :
    super.process(get_parent(), delta)

func _physics_process(delta: float) -> void :
    pass

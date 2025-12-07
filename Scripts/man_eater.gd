extends Entity
class_name ManEater

var parent


var moveset = {
    "UniqueAttack": 2, 
    "LightAttack": 2, 
}

var movesetNames = {
    "LightAttack": "Vine Whip", 
    "UniqueAttack": "Poison Shot"

}

var movesetCooldowns = {
    "LightAttack": 0, 
    "UniqueAttack": 1

}

var statBoosters = {
}




var movesetRanges = {
    "UniqueAttack": 150, 
    "LightAttack": 45, 
}


var movesetLevels = {
    "LightAttack": 0, 
    "UniqueAttack": 0, 

}

func _ready() -> void :


    "\n\tif $HealthBar and maxHealth:\n\t\t$HealthBar.init_health(maxHealth)\n\t\t$HealthBar._set_health(maxHealth)\n\t"




    parent = get_parent()
    var sprite = $Sprite2D

    var shader_material = sprite.material as ShaderMaterial



    var mat = $Sprite2D.material as ShaderMaterial
    if mat:


        if mat.resource_local_to_scene == false:
            mat = mat.duplicate()
            mat.resource_local_to_scene = true
            $Sprite2D.material = mat


        if parent.is_in_group("Player"):
            mat.set_shader_parameter("line_color", Color(0, 0, 1))
        elif parent.is_in_group("Opponent"):
            mat.set_shader_parameter("line_color", Color(1, 0, 0))


    super.initialize(get_parent())


func _process(delta: float) -> void :
    super.process(parent, delta)

func _physics_process(delta: float) -> void :
    super.main(delta, parent, movesetRanges)

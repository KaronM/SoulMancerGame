extends Entity
class_name Knight

var parent


var moveset = {
    "LightAttack": 1, 
    "HeavyAttack": 2, 
}

var movesetNames = {
    "LightAttack": "Slice", 
    "HeavyAttack": "Cleave", 
}


var movesetCooldowns = {
    "LightAttack": 0, 
    "HeavyAttack": 0, 
}

var statBoosters = {
}




var movesetRanges = {
    "LightAttack": 15, 
    "HeavyAttack": 15, 
}



var movesetLevels = {
    "LightAttack": 0, 
    "HeavyAttack": 10, 


}

func _ready() -> void :


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

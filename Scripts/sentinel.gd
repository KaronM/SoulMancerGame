extends Entity
class_name Sentinel

var parent
var applyShielding = false
var applyAttacking = false

var moveset = {
    "LightAttack": 1, 
    "UniqueAttack": 4, 

}
var movesetNames = {
    "LightAttack": "Spear Stab", 
    "UniqueAttack": "Overclock"

}

var movesetCooldowns = {
    "LightAttack": 0, 
    "UniqueAttack": 2

}

var statBoosters = {
    "UniqueAttack": "", 
}



var movesetRanges = {
    "LightAttack": 10, 
    "UniqueAttack": 300, 

}


var movesetLevels = {
    "LightAttack": 0, 
    "UniqueAttack": 10, 

}




func applyShields():
    applyShielding = true

func applyAttack():
    applyAttacking = true

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

    if applyShielding == true:
        applyShielding = false
    if applyAttacking == true:
        applyAttacking = false
    super.process(parent, delta)

func _physics_process(delta: float) -> void :
    super.main(delta, parent, movesetRanges)

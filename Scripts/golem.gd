extends Entity
class_name Golem

var parent
var applyShielding = false
var applyAttacking = false
var obstacle = load("res://Scenes/Characters/obstacle.tscn")

var moveset = {
    "LightAttack": 1, 
    "UniqueAttack": 6, 

}
var movesetNames = {
    "LightAttack": "Rock Punch", 
    "UniqueAttack": "Stone Smash"

}

var movesetCooldowns = {
    "LightAttack": 0, 
    "UniqueAttack": 4

}

var statBoosers = {
}



var movesetRanges = {
    "LightAttack": 10, 
    "UniqueAttack": 10, 

}


var movesetLevels = {
    "LightAttack": 0, 
    "UniqueAttack": 10, 

}




func spawnStone():
    var rock = obstacle.instantiate()
    rock.obstacleOwner = self
    print(get_tree().current_scene, "febe")
    var map = get_tree().current_scene
    map.add_child(rock)
    rock.global_position = Vector2(global_position.x + 10, global_position.y)


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


    super.process(parent, delta)

func _physics_process(delta: float) -> void :
    super.main(delta, parent, movesetRanges)

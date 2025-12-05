extends Entity
class_name Knight
#All potential States
var parent

#moves and their action token costs
var moveset = {
	"LightAttack": 1,
	"HeavyAttack": 2,
}

var movesetNames = {
	"LightAttack": "Slice",
	"HeavyAttack": "Cleave",
}

#number of rounds waiting for the move
var movesetCooldowns= {
	"LightAttack": 0,
	"HeavyAttack": 0,
}

var statBoosters = {
}



#for raycasts
var movesetRanges ={
	"LightAttack": 15,
	"HeavyAttack": 15,
}


#unlocked move levels
var movesetLevels = {
	"LightAttack": 0,
	"HeavyAttack": 10,

	
}

func _ready() -> void:


	parent = get_parent()
	var sprite = $Sprite2D
	
	var shader_material = sprite.material as ShaderMaterial
	

	#set shader color
	var mat = $Sprite2D.material as ShaderMaterial
	if mat:
		
		#make sure each entity has its own copy of the material
		if mat.resource_local_to_scene == false:
			mat = mat.duplicate()
			mat.resource_local_to_scene = true
			$Sprite2D.material = mat

		
		if parent.is_in_group("Player"):
			mat.set_shader_parameter("line_color", Color(0, 0, 1))#blue
		elif parent.is_in_group("Opponent"):
			mat.set_shader_parameter("line_color", Color(1, 0, 0))#red
			
	#initialize character
	super.initialize(get_parent())


func _process(delta: float) -> void:
	super.process(parent, delta)
	
func _physics_process(delta: float) -> void:
	super.main(delta, parent,movesetRanges)

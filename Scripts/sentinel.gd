extends Entity
class_name Sentinel
#All potential States
var parent
var applyShielding = false
var applyAttacking = false
#moves and their action token costs
var moveset = {
	"LightAttack": 1,
	"UniqueAttack": 4,
	
}
var movesetNames = {
	"LightAttack": "Spear Stab",
	"UniqueAttack": "Overclock"
	
}

var movesetCooldowns= {
	"LightAttack": 0,
	"UniqueAttack": 2
	
}

var statBoosters = {
	"UniqueAttack":'',
}


#Range Detection for raycasts
var movesetRanges ={
	"LightAttack": 10,
	"UniqueAttack": 300,
	
}

#unlocked move levels
var movesetLevels = {
	"LightAttack": 0,
	"UniqueAttack": 10,
	
}

#"Block": 15,
#for raycasts for each move

func applyShields():
	applyShielding = true
	
func applyAttack():
	applyAttacking = true

func _ready() -> void:
	#Health

	parent = get_parent()
	var sprite = $Sprite2D
	var shader_material = sprite.material as ShaderMaterial
	
	

	#set shader color
	var mat = $Sprite2D.material as ShaderMaterial
	if mat:
		# Make sure each entity has its own copy of the material
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
	#turn off stat boosts immediately when activated
	if applyShielding == true:
		applyShielding = false
	if applyAttacking == true:
		applyAttacking = false
	super.process(parent, delta)
	
func _physics_process(delta: float) -> void:
	super.main(delta, parent, movesetRanges)

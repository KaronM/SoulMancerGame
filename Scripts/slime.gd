extends Entity
class_name Slime
#All potential States
var parent

#moves and their action token costs
var moveset = {
	"LightAttack": 1,
	"HeavyAttack": 2,
	"UniqueAttack": 4,
	
}
#"Block": 2,
#Range Detection for raycasts
var movesetRanges ={
	"LightAttack": 10,
	"HeavyAttack": 10,
	"UniqueAttack": 75,
	
}
#"Block": 15,
#for raycasts for each move



func _ready() -> void:
	#Health
	maxHealth= 100
	if $HealthBar:
		$HealthBar.init_health(maxHealth)
		$HealthBar._set_health(maxHealth)
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

	super.process(parent, delta)
	
func _physics_process(delta: float) -> void:
	super.main(delta, parent, movesetRanges)

extends HitBoxes

 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func addDamage(strength: int):
	damage = strength

func _on_area_entered(area: Area2D) -> void:
	# Only react if the area is actually a HitBox
	pass
		#monitoring = false



# Replace with function body.

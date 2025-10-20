extends Area2D

@export var stunned: float
@export var isBlocking: bool

signal hit(area: Area2D)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("area_entered", Callable(self, "_on_area_entered"))
# Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	


func _on_area_entered(area: Area2D) -> void:
	#print("area", area.get_parent().get_parent().get_parent())
	#parent of hurtbox
	var owner = get_parent().get_parent()
	#parent of hitbox
	var areaOwner = area.get_parent().get_parent().get_parent()
	
	print(owner, areaOwner)
	if areaOwner.is_in_group("Player") and owner.is_in_group("Opponent"):
		
		if area.is_in_group("Hitbox"):
			print("HurtBox: emitting hit")
			emit_signal("hit", area)
	elif areaOwner.is_in_group("Opponent") and owner.is_in_group("Player"):
		if area.is_in_group("Hitbox"):
			print("HurtBox: emitting hit")
			emit_signal("hit", area)  
			
	if isBlocking and  areaOwner.is_in_group("Player") and owner.is_in_group("Opponent"):
		if area.is_in_group("Hitbox"):
			emit_signal("blocked", area)
			
	elif isBlocking and areaOwner.is_in_group("Opponent") and owner.is_in_group("Player"):
		if area.is_in_group("Hitbox"):
			emit_signal("blocked", area)  
	# Replace with function body.

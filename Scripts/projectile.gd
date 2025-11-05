extends Node2D
var velocity: Vector2 = Vector2.ZERO
var gravi = 980.0
var damage = 100
var floor_y = 0  # Adjust to your floor's Y position
var piercing = false
func initialize(initial_velocity: Vector2, grav: float, floor_position: float = 0):
	velocity = initial_velocity
	gravi = grav
	floor_y = floor_position

func _physics_process(delta):
	# Apply gravity to vertical velocity
	velocity.y += gravi * delta
	
	# Move the projectile
	position += velocity * delta
	
	# Check if hit the floor
	if position.y >= floor_y:
		queue_free()  # Destroy on floor impact
		return
	
	# Rotate projectile to face movement direction
	rotation = velocity.angle()

func on_area_entered(area: Area2D):
	if !piercing:
		if is_in_group("Player_Projectile") and area.get_parent().get_parent().is_in_group("Opponent"):
			queue_free()
		elif is_in_group("Opponent_Projectile") and area.get_parent().get_parent().is_in_group("Player"):
			queue_free()


func _ready():
	print("projectile parent ",  get_parent().name)
	if $hit_box:
		$hit_box.connect("area_entered",Callable(self, "on_area_entered"))
	
	# Auto-destroy after 5 seconds
	await get_tree().create_timer(5.0).timeout
	queue_free()
	

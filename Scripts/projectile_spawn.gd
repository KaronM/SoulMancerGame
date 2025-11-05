extends Node2D

# Reference to your projectile scene
@export var projectile_scene: PackedScene
@export var projectile_Texture: Texture2D
# Adjust these to control the arc
@export var launch_velocity: float = 400.0
@export var launch_angle: float = -45.0  # Negative for upward arc
@export var gravity: float = 980.0  # Match your project's gravity or customize
@export var damage = 20
@export var piercing : bool

func spawnProjectile():
	
	if not projectile_scene:
		push_error("Projectile scene not assigned!")
		return
	# Instance the projectile
	var projectile = projectile_scene.instantiate()
	
	projectile.texture = projectile_Texture
	#change sprite

	if projectile_Texture and projectile is Sprite2D:
		projectile.texture = projectile_Texture
	
	
	projectile.piercing = piercing
	
	#take damage and make it the value of hitbox
	projectile.get_node("hit_box").addDamage(damage)
	
	# Add to projectile to character
	#get_parent().add_child(projectile)
	get_tree().current_scene.add_child(projectile)
	
	print("tree ", get_tree().current_scene)

	# Set starting position (global position of this spawner)
	projectile.global_position = global_position
	
	#add projectile to hitbox group
	if get_parent().get_parent().is_in_group("Player"):
		projectile.add_to_group("Player_Projectile")
	elif get_parent().get_parent().is_in_group("Opponent"):
		projectile.add_to_group("Opponent_Projectile")

	print("proj group" , projectile.get_groups())
	
	
	# Calculate velocity based on the direction the character is facing

	var direction = 1
	if get_parent().get_parent().is_in_group("Player"):
		direction = 1 
	elif get_parent().get_parent().is_in_group("Opponent"):
		direction = -1 
	
	var angle_rad = deg_to_rad(launch_angle)

	#turn on projectile effects
	
	
	
	var velocity = Vector2(
		cos(angle_rad) * launch_velocity * direction,
		sin(angle_rad) * launch_velocity
	)
	
	# Pass velocity and gravity to projectile
	if projectile.has_method("initialize"):
		projectile.initialize(velocity, gravity,0)
	else:
		# Fallback if projectile doesn't have initialize method
		projectile.velocity = velocity
		projectile.gravity = gravity
		
	#add a CPUParticles2D trail
	var particles = projectile.get_node("CPUParticles2D")
	
	particles.emitting = false
	#add purple effects - ManEater
	print("class", get_parent().get_class())
	
	#if character is maneater
	if get_parent().get_script().get_global_name() == "ManEater":
		particles.position = Vector2.ZERO
		particles.emitting = true
		particles.amount = 25
		particles.lifetime = 0.35
		particles.one_shot = false
		particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_POINT

		# Movement and look
		particles.spread = 120.0
		particles.speed_scale = 1.0
		particles.scale = Vector2.ONE * 1.0
		particles.direction = Vector2(1, 0) # emission direction angle (radians)
		particles.initial_velocity_min = 60.0
		particles.initial_velocity_max = 100.0
		particles.angle_min = -15.0
		particles.angle_max = 15.0
		if get_parent().get_parent().is_in_group("Player"):
			particles.gravity = Vector2(-200,300)
		elif get_parent().get_parent().is_in_group("Opponent"):
			particles.gravity = Vector2(200,300) # disables downward pull

		# Color
		particles.color = Color(0.7, 0.2, 1.0, 1.0)  # solid purple 💜

		# Optional fade effect (alpha fade out)
		particles.color_ramp = Gradient.new()
		particles.color_ramp.add_point(0.0, Color(0.7, 0.2, 1.0, 1.0))
		particles.color_ramp.add_point(1.0, Color(0.7, 0.2, 1.0, 0.0))

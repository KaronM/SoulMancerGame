extends Node2D

@onready var playerNode = get_parent().get_node("Player")
@onready var player = playerNode.get_child(1)
@onready var enemyNode = get_parent().get_node("Opponent")
@onready var enemy = enemyNode.get_child(1)
@onready var cam = $Camera2D
@onready var actionBar = $ActionTokenBar/NinePatchRect/VBoxContainer
@onready var startButton = $StartButton/Control/TextureButton

func _ready() -> void:
	cam.global_position.y = playerNode.global_position.y +2000
	cam.offset.y = 30
	
	cam.zoom = calculate_zoom_for_players(playerNode.position, enemyNode.position)
	actionBar 

func _process(delta: float) -> void:

	var center = (playerNode.position + enemyNode.position) / 2
	cam.global_position = center
	
	cam.zoom = calculate_zoom_for_players(playerNode.global_position, enemyNode.global_position)

# ----------------------------
func calculate_zoom_for_players(p1: Vector2, p2: Vector2) -> Vector2:
	var viewport_size = get_viewport_rect().size
	# Horizontal distance between players
	var dist = abs(p2.x - p1.x)*2
	# Add a little buffer
	var buffer = 5

# Calculate required zoom so both fit in viewport
# Zoom in Godot: smaller zoom → zoom out, bigger zoom → zoom in
# So zoom = viewport_size / world_units_to_fit
	var viewport_width = get_viewport_rect().size.x
	var zoom_x = viewport_width/(dist + buffer)   # this gives world units ratio
	var zoom_val = clamp(zoom_x, 3, 4.0)  # clamp to min/max zoom

	# Return uniform zoom vector for Camera2D
	return Vector2(zoom_val, zoom_val)

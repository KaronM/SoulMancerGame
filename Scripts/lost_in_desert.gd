extends Area2D

# Reference to the white box we just created
@onready var flash_rect = $CanvasLayer/ColorRect

func _ready() -> void:
	# Ensure the flash is invisible when the game starts
	flash_rect.modulate.a = 0.0

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		trigger_teleport_sequence(body)

func trigger_teleport_sequence(player_body: Node2D) -> void:
	# Create a temporary Tween animation
	var tween = create_tween()
	
	# 1. Fade the white box IN (0.1 seconds - very fast)
	tween.tween_property(flash_rect, "modulate:a", 1.0, 0.1)
	
	# 2. Run the actual teleportation function immediately after the fade in finishes
	tween.tween_callback(func(): _teleport_logic(player_body))
	
	# 3. Fade the white box OUT (0.5 seconds - slower fade out looks smoother)
	tween.tween_property(flash_rect, "modulate:a", 0.0, 0.5)

func _teleport_logic(player_body):
	# This happens while the screen is fully white
	player_body.set_position($SpawnPointDesertLost.global_position)

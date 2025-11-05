extends Node

var sceneTree

const SPEED = 100.0

func apply_gravity(body:CharacterBody2D ,delta : float):
	if not body.is_on_floor():
		body.velocity += body.get_gravity() * delta

func apply_movement(body:CharacterBody2D, delta : float, direction: int) -> void:
	if direction:
		body.velocity.x = direction * SPEED

func apply_knockback(body:CharacterBody2D, knockback: Vector2):
	if body.get_parent().is_in_group("Player"):
		body.velocity.x = -1 * knockback.x
		body.velocity.y = knockback.y
	else:
		body.velocity.x = knockback.x
		body.velocity.y = knockback.y
	
func stop_movement(body:CharacterBody2D) -> void:
	body.velocity.x = 0 * SPEED

func _ready() -> void:
	pass
	
func _on_physics_process(_delta:float):
	pass

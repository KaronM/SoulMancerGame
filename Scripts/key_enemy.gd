extends Area2D

@export var enemy_to_spawn: Node2D

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if enemy_to_spawn:
			enemy_to_spawn.visible = true
			enemy_to_spawn.process_mode = Node.PROCESS_MODE_INHERIT
		
		# 2. Add key collection logic here (e.g., add to inventory)
		print("Key collected! Enemy appearing!")
		GameManager.key_count += 1
		
		queue_free()

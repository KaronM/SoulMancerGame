extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.key_count >= 2:
			body.set_position($SpawnPointDungeon.global_position)

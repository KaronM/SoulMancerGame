extends CharacterBody2D

@export var characters: Array[CharacterData] = []
@export var moneyValue: int
@export var experienceValue: int

@export var speed = 100
var player = null

func _physics_process(delta):
    if player:
        var direction = (player.global_position - global_position).normalized()

        velocity = direction * speed
        move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void :
    if body.is_in_group("Player"):
        player = body
        print("Player found! Chasing...")
        await get_tree().create_timer(0.1).timeout
        queue_free()

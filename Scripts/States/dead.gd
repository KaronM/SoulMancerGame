extends State

@onready var entity: CharacterBody2D
@onready var animationPlayer: AnimationPlayer

var direction: int

func _on_process(_delta: float) -> void :
    pass


func _on_physics_process(_delta: float) -> void :

    print("Defeated")
    Movement.apply_gravity(entity, _delta)

    for node in entity.get_children():
        if node is Label:
            node.queue_free()

func _on_next_transitions() -> void :
    emit_signal("Defeated")


func _on_enter(owner: CharacterBody2D) -> void :


    entity = owner

    entity.get_node_or_null("StatusEffects").texture = null
    entity.get_node_or_null("StatusIcon").texture = null

    entity.going_home = false
    animationPlayer = entity.get_node("AnimationPlayer")
    animationPlayer.play("Defeated")
    entity.velocity = Vector2.ZERO
    entity.defeated = false
    entity.moveQueues.clear()



    entity.set_collision_mask_value(2, false)
    entity.set_collision_mask_value(3, false)
    entity.set_collision_layer_value(2, false)
    entity.set_collision_layer_value(3, false)

    entity.set_collision_mask_value(1, false)
    entity.set_collision_layer_value(1, false)





    var hurtBox = entity.get_node("HurtBox")
    if hurtBox:
        hurtBox.set_collision_mask_value(5, false)
        hurtBox.set_collision_layer_value(4, false)
    GameManager.activeCharacters -= 1



func _on_exit() -> void :
    animationPlayer.stop()

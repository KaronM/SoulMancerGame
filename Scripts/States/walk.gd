extends State

@onready var entity: CharacterBody2D
@onready var animationPlayer: AnimationPlayer


var parent: Node2D
var direction: int



func _on_physics_process(delta: float) -> void :




    Movement.apply_movement(entity, delta, direction, entity.speed)
    animationPlayer.play("WalkForward")



    if GameManager.matchEnd:
        entity.change_state(entity.states["idle"])



func _on_enter(owner: CharacterBody2D) -> void :
    entity = owner
    parent = entity.get_parent()
    animationPlayer = entity.get_node("AnimationPlayer")

    if parent.is_in_group("Player"):
        direction = 1
    else:
        direction = -1



func _on_exit() -> void :
    Movement.stop_movement(entity)
    animationPlayer.stop()



func _stop_at_spawn():
    print("stopped")
    Movement.stop_movement(entity)
    animationPlayer.stop()
    entity.going_home = false
    entity.home = true

    entity.change_state(entity.states["idle"])

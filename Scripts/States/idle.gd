extends State

@onready var entity: CharacterBody2D
@onready var animationPlayer: AnimationPlayer


var direction: int

func _on_process(_delta: float) -> void :
    pass


func _on_physics_process(_delta: float) -> void :
    if animationPlayer.current_animation != "Idle":
        animationPlayer.play("Idle")
    print("Idle")


func _on_next_transitions() -> void :
    emit_signal("Idle")


func _on_enter(owner: CharacterBody2D) -> void :
    entity = owner
    entity.going_home = false
    animationPlayer = entity.get_node("AnimationPlayer")
    animationPlayer.play("Idle")
    entity.velocity = Vector2.ZERO



func _on_exit() -> void :
    animationPlayer.stop()

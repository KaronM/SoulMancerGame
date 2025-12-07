extends State

@onready var entity: CharacterBody2D
@onready var animationPlayer: AnimationPlayer


var direction: int
const JUMP_VELOCITY = -200.0
const SPEED = 100
var jumped = false

func _on_process(_delta: float) -> void :
    pass


func _on_physics_process(_delta: float) -> void :

    if animationPlayer.current_animation != "Jump":
        animationPlayer.play("Jump")


    if !jumped and entity.is_on_floor():
        entity.velocity.y = JUMP_VELOCITY
        entity.velocity.x += SPEED
        jumped = true



    entity.move_and_slide()


    if jumped and entity.is_on_floor():

        entity.change_state(entity.states["walk"])



func _on_unhandled_input(_event: InputEvent) -> void :
    pass


func _on_next_transitions() -> void :
    emit_signal("Jump")


func _on_enter(owner: CharacterBody2D) -> void :
    entity = owner
    animationPlayer = entity.get_node("AnimationPlayer")
    animationPlayer.play("Jump")

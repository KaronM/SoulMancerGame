extends State

@onready var entity: CharacterBody2D
@onready var animationPlayer: AnimationPlayer


var direction: int

func _on_process(_delta: float) -> void :
    pass


func _on_physics_process(_delta: float) -> void :
    if animationPlayer.current_animation != "LightAttack":
        animationPlayer.play("LightAttack")


func _on_animation_finished_light(anim_name: String) -> void :
    if anim_name == "LightAttack":


        entity.remove_move(anim_name)
        if entity.moveQueues.size() > 0:
            entity.change_state(entity.states["walk"])
        else:
                entity.change_state(entity.states["retreat"])



func _on_unhandled_input(_event: InputEvent) -> void :
    pass


func _on_next_transitions() -> void :
    emit_signal("LightAttack")


func _on_enter(owner: CharacterBody2D) -> void :
    entity = owner
    animationPlayer = entity.get_node("AnimationPlayer")
    animationPlayer.play("LightAttack")
    animationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished_light"))


func _on_exit() -> void :
    pass

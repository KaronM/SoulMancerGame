extends State

@onready var entity: CharacterBody2D
@onready var animationPlayer: AnimationPlayer

var direction: int

func _on_process(_delta: float) -> void :
    pass


func _on_physics_process(_delta: float) -> void :
    if animationPlayer.current_animation != "HeavyAttack":
        animationPlayer.play("Heavyattack")



func _on_animation_finished_heavy(anim_name: String) -> void :
    print("Animation finished:", anim_name)
    if anim_name == "HeavyAttack":

        entity.remove_move(anim_name)
        if entity.moveQueues.size() > 0:
            entity.change_state(entity.states["walk"])
        else:
            entity.change_state(entity.states["retreat"])



func _on_unhandled_input(_event: InputEvent) -> void :
    pass


func _on_next_transitions() -> void :
    emit_signal("HeavyAttack")


func _on_enter(owner: CharacterBody2D) -> void :
    entity = owner
    animationPlayer = entity.get_node("AnimationPlayer")
    animationPlayer.play("HeavyAttack")
    animationPlayer.connect("animation_finished", Callable(self, "_on_animation_finished_heavy"))


func _on_exit() -> void :
    pass

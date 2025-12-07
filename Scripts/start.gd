extends Label

func _ready():

    blink()

func blink():
    var tween = create_tween()
    tween.set_loops()


    tween.tween_property(self, "modulate:a", 0.2, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

    tween.tween_property(self, "modulate:a", 1.0, 0.8).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

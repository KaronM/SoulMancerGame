extends Area2D

@export var stunned: float
@export var isBlocking: bool

signal hit(area: Area2D)
signal blocked(area: Area2D)

func _ready() -> void :
    connect("area_entered", Callable(self, "_on_area_entered"))




func _process(delta: float) -> void :
    pass



func _on_area_entered(area: Area2D) -> void :


    var owner = get_parent().get_parent()

    var areaOwner = area.get_parent().get_parent().get_parent()

    if owner.is_in_group("Opponent") and (areaOwner.is_in_group("Player") or area.get_parent().is_in_group("Player_Projectile")):

        if area.is_in_group("Hitbox"):
            print("HurtBox: emitting hit")
            emit_signal("hit", area)
    elif owner.is_in_group("Player") and (areaOwner.is_in_group("Opponent") or area.get_parent().is_in_group("Opponent_Projectile")):
        if area.is_in_group("Hitbox"):
            print("HurtBox: emitting hit")
            emit_signal("hit", area)

    if isBlocking and areaOwner.is_in_group("Player") and owner.is_in_group("Opponent"):
        if area.is_in_group("Hitbox"):
            emit_signal("blocked", area)

    elif isBlocking and areaOwner.is_in_group("Opponent") and owner.is_in_group("Player"):
        if area.is_in_group("Hitbox"):
            emit_signal("blocked", area)

extends CharacterBody2D
class_name Obstacle

var obstacleOwner: Entity

var defeated = false

func _process(delta: float) -> void :
    if not is_on_floor():
        velocity += get_gravity() * delta

func dead():
    queue_free()

func _ready() -> void :
    var raycast_mask
    if obstacleOwner:
        collision_layer = obstacleOwner.collision_layer
        collision_mask = obstacleOwner.collision_mask
        raycast_mask = obstacleOwner.rayCast.collision_mask


        if obstacleOwner.is_in_group("Player"):
            set_collision_layer_value(collision_layer, false)
            set_collision_mask_value(collision_mask, false)
            $HurtBox.set_collision_layer_value(raycast_mask, false)
        else:
            pass


    $HurtBox.area_entered.connect(Hurt)
    $HealthBar.max_value = 200
    $HealthBar.value = 200


func Hurt(area: Area2D):
    print("mushu")
    print(area.get_parent().get_groups(), "mush")
    print(obstacleOwner.get_groups(), "mush")
    if area is HitBoxes and area.get_parent().get_groups() != obstacleOwner.get_groups():
        print(area.get_parent().get_parent().name, "zumi")
        $HealthBar.damage(area.damage)



func process(delta: float) -> void :
    pass

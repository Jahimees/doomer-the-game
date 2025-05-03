class_name StandStranger extends Stranger

@export var flip_h: bool

func _ready() -> void:
	animation.flip_h = flip_h

#OVERRIDE
func _physics_process(delta: float) -> void:
		
	if (current_state == Globals.StrangerState.SMOKING):
		animation.play('smoking')
		return
	
	if not floor_ray.is_colliding():
		velocity += get_gravity() * delta

	velocity.x = move_toward(velocity.x, 0, SPEED)
	animation.play('idle')

	move_and_slide()
	try_to_steal_cigarette()

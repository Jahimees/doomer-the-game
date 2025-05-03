class_name Stranger extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var RANDOM_GENERATOR = RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction = 0
var current_state: Globals.StrangerState = Globals.StrangerState.DEFAULT

var is_asked: bool = false

var phrases = [
	'Уважаемый, не найдется ли сигаретки?', 
	'Сигареты не будет?',
	'Есть сигарета?',
	'Сигарета будет?',
	'Дружище, можешь угостить сигареткой?'
] 

@onready var animation = $AnimatedSprite2D
@onready var floor_ray = $FloorRay

func _physics_process(delta: float) -> void:
		
	if (current_state == Globals.StrangerState.SMOKING):
		animation.play('smoking')
		return
		
	if not floor_ray.is_colliding():
		velocity += get_gravity() * delta
	else:
#		TODO add the gravity
		pass
	
	if (direction):
		velocity.x =  direction * SPEED
		#move_toward(velocity.x, direction * SPEED, SPEED)
		if (direction > 0):
			animation.play('walking')
			animation.set_flip_h(false)
		
		elif (direction < 0):
			animation.play('walking')
			animation.set_flip_h(true)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play('idle')

	move_and_slide()
	try_to_steal_cigarette()
	
func change_state(state: Globals.StrangerState):
	current_state = state

func _on_direction_timer_timeout() -> void:
	direction = RANDOM_GENERATOR.randi_range(-1, 1)
	
func try_to_steal_cigarette():
	if (current_state == Globals.StrangerState.ASKED):
		return false
		
	var collision: KinematicCollision2D = get_last_slide_collision()
	if (collision and collision.get_collider()):
		
		var collider = collision.get_collider()
		if (collider.has_method('change_cigarettes_count') and !is_asked):
			is_asked = true
			Signals.init_dialogue.emit(collider, self)
			self.set_collision_mask_value(Globals.LAYER_PLAYER, false)
			
			await get_tree().create_timer(1).timeout
			is_asked = false
			return true
			
	return false

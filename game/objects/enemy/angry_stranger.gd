class_name AngryStranger extends Stranger

var entred_player: Player = null

#var phrases = [
	#'Уважаемый, не найдется ли сигаретки?', 
	#'Сигареты не будет?',
	#'Есть сигарета?',
	#'Сигарета будет?',
	#'Дружище, можешь угостить сигареткой?'
#] 

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
		velocity.x = direction * SPEED
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
	if (await try_to_steal_cigarette()):
		entred_player = null

#OVERRIDE
func _on_direction_timer_timeout() -> void:
	if (entred_player):
		direction = 1 if self.global_position.x - entred_player.global_position.x < 0 else -1
	else:
		direction = RANDOM_GENERATOR.randi_range(-1, 1)

func _on_area_2d_player_entered(body: Node2D) -> void:
	if (body is Player and current_state != Globals.StrangerState.ASKED):
		entred_player = body

func _on_area_2d_player_exited(body: Node2D) -> void:
	if (body is Player):
		entred_player = null

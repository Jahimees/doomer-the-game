extends CharacterBody2D
class_name Player 

const SPEED := 150.0
const JUMP_VELOCITY := -400.0
const HEALTH_WAIT_TIME := 1
const EVADE_TIME := 2
const EVADE_COOLDOWN := 10

@onready var anim = $Animation
@onready var healthTimer = $HealthTimer
@onready var hud = $Hud
@onready var evadeTimer = $EvadeCooldownTimer
@onready var step_sound_player = $StepSound
@onready var smoke_cigarette_sound_player = $SmokeCigaretteSoundPlayer
@onready var get_cigarette_sound_player = $GetCigaretteSoundPlayer
@onready var evade_audio_player = $EvadeAudioPlayer

var direction
var health = 100
var cigarette_count = 0
var is_evade_on = false
var is_evade_cooldown = false

var is_step_done = false

func _ready():
	healthTimer.start(HEALTH_WAIT_TIME)

func _physics_process(delta: float) -> void:
	do_move_actions(delta)
	do_evade_actions()
	move_and_slide()

func do_evade_actions():
	if Input.is_action_just_pressed("evade_enemy") and !is_evade_on and !is_evade_cooldown:
		is_evade_cooldown = true
		is_evade_on = true
		evade_audio_player.play()
		self.set_collision_layer_value(Globals.LAYER_PLAYER, false)
		evadeTimer.start(EVADE_COOLDOWN)
		evadeTimer.timeout
		
		await get_tree().create_timer(EVADE_TIME).timeout
		
		evade_audio_player.play()
		is_evade_on = false
		self.set_collision_layer_value(Globals.LAYER_PLAYER, true)
	
	if is_evade_cooldown:
		var time_passed = EVADE_COOLDOWN - evadeTimer.time_left
		print(time_passed)
		hud.change_evade_cooldown_bar(time_passed)

func do_move_actions(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		if (!is_step_done and is_on_floor()):
			step_sound_player.play()
			is_step_done = true
			get_tree().create_timer(0.5).timeout.connect(func(): 
				is_step_done = false
			)
		
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
		if (direction > 0):
			anim.set_flip_h(false)
		else:
			anim.set_flip_h(true)
			
		play_animation(anim, 'walking')

	else:
		velocity.x = 0
		play_animation(anim, 'idle')
		#anim.play('idle')

func play_animation(anim: AnimatedSprite2D, anim_name: String):
	if is_evade_on:
		anim.play(anim_name + '_0')
	else:
		anim.play(anim_name)
	

func _on_evade_ended():
	is_evade_on = false

################################ HEALTH ##################################

func has_cigarettes():
	return cigarette_count > 0

func _on_health_timer_timeout() -> void:
	if (health > 0):
		health = health - 2
		Signals.hp_changed.emit(health)
	else:
		if (cigarette_count > 0):
			smoke_cigarette_sound_player.play()
			cigarette_count -= 1
			health = 100
			Signals.hp_changed.emit(health)
			Signals.cigarettes_changed.emit(cigarette_count)
		else:
			get_tree().change_scene_to_file("res://game/UI/menu/death_screen.tscn")
		
func change_cigarettes_count(count: int):
	print('cigarettes changed')
	if (count > 0):
		get_cigarette_sound_player.play()
		
	cigarette_count += count
	Signals.emit_signal('cigarettes_changed', cigarette_count)


func _on_evade_cooldown_timer_timeout() -> void:
	is_evade_cooldown = false

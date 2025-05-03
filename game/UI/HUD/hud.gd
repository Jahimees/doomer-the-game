extends CanvasLayer

@onready var progress_bar = $TextureProgressBar
@onready var evade_cooldown_bar = $EvadeCooldownBar
@onready var cigarette_rect_scene = preload("res://game/UI/HUD/cigarette_texture_rect.tscn")
@onready var pack = $CigarettePackFront

var cigarettes_in_pack = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Signals.hp_changed.connect(hp_changed)
	Signals.cigarettes_changed.connect(cigarettes_changed)

func hp_changed(hp_count: float):
	progress_bar.value = hp_count
	
func cigarettes_changed(current_cigarette_count: int):
	while (cigarettes_in_pack.size() < current_cigarette_count):
		var instance: Control = cigarette_rect_scene.instantiate()
		
		var last_cigarette_position = cigarettes_in_pack.get(cigarettes_in_pack.size() - 1)
		last_cigarette_position = last_cigarette_position.position.x if last_cigarette_position else pack.position.x
		
		instance.scale = Vector2(0.5, 0.5)
		instance.position = Vector2(last_cigarette_position + 10, pack.position.y + 20)
		cigarettes_in_pack.append(instance)
		add_child(instance)
		instance.z_index = 1
	if (cigarettes_in_pack.size() > current_cigarette_count):
		var last_cigarette: Node = cigarettes_in_pack.pop_back() as Node
		remove_child(last_cigarette)
		last_cigarette.queue_free()

func change_evade_cooldown_bar(time_passed: float):
	evade_cooldown_bar.value = time_passed

func _on_button_pressed() -> void:
	print('I was pressed')

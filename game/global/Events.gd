extends Node

const DIALOGUE_SCENE = preload("res://game/UI/HUD/Dialogue.tscn")
const PAUSE_SCENE = preload("res://game/UI/menu/pause_menu.tscn")

func _ready() -> void:
	Signals.init_dialogue.connect(_on_open_dialogue)
	Signals.close_dialogue.connect(_on_close_dialogue)
	Signals.pause_game.connect(_on_game_paused)
	Signals.resume_game.connect(_on_game_resumed)
	
func _on_open_dialogue(first_person: CharacterBody2D, second_person: CharacterBody2D):
	if (!first_person.has_method('has_cigarettes')):
		push_error('Parameter first_person is not a player')
		return
	
	Engine.time_scale = 0.0
	var phrases: Array = second_person.get('phrases')
	
	if (!phrases):
		push_error('Parameter \'phrases\' does not exists in second_person')
		Engine.time_scale = 1.0
		return
		
	var chosen_phrase = phrases.pick_random()
	
	var dialogue_node = DIALOGUE_SCENE.instantiate()
	first_person.add_child(dialogue_node)
	dialogue_node.prepare_dialogue(chosen_phrase, first_person, second_person)

func _on_close_dialogue(main_person: CharacterBody2D, second_person: CharacterBody2D):
	if (!main_person.has_method('has_cigarettes')):
		push_error('main_person is not player node')
		
	if (main_person.has_cigarettes()):
		main_person.cigarette_count -=1
		Signals.cigarettes_changed.emit(main_person.cigarette_count)
		if (second_person.has_method('change_state')):
			second_person.change_state(Globals.StrangerState.SMOKING)
	else:
		second_person.change_state(Globals.StrangerState.ASKED)
	Engine.time_scale = 1.0

func _on_game_paused(game: Node):
	if (!Globals.is_game_paused):
		Engine.time_scale = 0.0
		Globals.is_game_paused = true
		game.add_child(PAUSE_SCENE.instantiate())
		
func _on_game_resumed(pause_scene: Node):
		Engine.time_scale = 1.0
		Globals.is_game_paused = false
		pause_scene.queue_free()

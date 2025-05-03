extends Node

signal hp_changed(hp_count: float)

signal cigarettes_changed(current_cigarretes_count: int)
	
signal init_dialogue(main_person: CharacterBody2D, second_person: CharacterBody2D)
signal close_dialogue(main_person: CharacterBody2D, second_person: CharacterBody2D)

signal pause_game(game: Node)
signal resume_game(pause_scene: Node)

signal game_music_volume_changed()

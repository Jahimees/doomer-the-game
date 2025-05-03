extends CanvasLayer

@onready var music_slider = $MusicSlider

func _ready() -> void:
	music_slider.value = Globals.game_music_volume

func _on_continue_button_pressed() -> void:
	Signals.resume_game.emit(self)

func _on_exit_game_button_pressed() -> void:
	get_tree().quit()

func _on_to_main_menu_button_pressed() -> void:
	Signals.resume_game.emit(self)
	get_tree().change_scene_to_file("res://game/UI/menu/MainMenu.tscn")

func change_volume():
	if (music_slider.value == -60):
		Globals.game_music_volume = -100
	else:
		Globals.game_music_volume = music_slider.value
	Signals.game_music_volume_changed.emit()

func _on_music_slider_value_changed(value: float) -> void:
	change_volume()

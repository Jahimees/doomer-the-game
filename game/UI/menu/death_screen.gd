extends CanvasLayer


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")


func _on_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://game/UI/menu/MainMenu.tscn")

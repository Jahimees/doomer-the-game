extends CanvasLayer

@onready var animation = $Animation
@onready var audio_player = $MainTheme
@onready var audio_slider = $AudioSlider

func _ready() -> void:
	animation.play('walking')
	change_volume()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func change_volume():
	if (audio_slider.value == -60):
		audio_player.volume_db = -100
	else:
		audio_player.volume_db = audio_slider.value

func _on_audio_slider_value_changed(value: float) -> void:
	change_volume()

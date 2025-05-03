extends Node2D

@onready var music_player = $MusicPlayer

func _ready() -> void:
	music_player.volume_db = Globals.game_music_volume
	Signals.game_music_volume_changed.connect(func():
		music_player.volume_db = Globals.game_music_volume
	)


func _on_final_area_body_entered(body: Node2D) -> void:
	if (body is Player):
		get_tree().change_scene_to_file("res://game/UI/cutscenes/final_cutscene.tscn")

func _physics_process(delta: float) -> void:
	if (Input.is_action_just_pressed('pause')):
		Signals.pause_game.emit(self)

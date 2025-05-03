extends CanvasLayer

@onready var dialogue_text_box = $DialogueTextBox
@onready var give_answer_button = $GiveAnswerButton
@onready var enemy_icon_texture = $EnemyIcon

@onready var stranger_texture = load('res://assets/enemies/enemy_sprite.png')
@onready var angry_stranger_texture = load('res://assets/enemies/enemy_2_sprite.png')
@onready var stand_stranger_texture = load('res://assets/enemies/enemy_3_sprite.png')
@onready var ask_sound_player = $AskSoundPlayer

var current_atlas

var second_person: CharacterBody2D
var main_person: CharacterBody2D
var has_cigarettes: bool

func _ready() -> void:
	current_atlas = AtlasTexture.new()
	current_atlas.region = Rect2(38, 3, 55, 59)
	enemy_icon_texture.texture = current_atlas

func prepare_dialogue(text: String, main_person: CharacterBody2D, second_person: CharacterBody2D):
	self.second_person = second_person
	self.main_person = main_person
	self.has_cigarettes = main_person.has_cigarettes()
	dialogue_text_box.text = text
	
	load_atlas_texture(second_person)
	
	play_sound(second_person)
	
	if (has_cigarettes):
		give_answer_button.text = 'На, держи'
	else:
		give_answer_button.text = 'Извините, нету'
		
func load_atlas_texture(person: CharacterBody2D):
	var atlas_texture
	if person is StandStranger:
		atlas_texture = stand_stranger_texture
	elif person is AngryStranger:
		atlas_texture = angry_stranger_texture
	else:
		atlas_texture = stranger_texture
	
	current_atlas.atlas = atlas_texture

func play_sound(person):
	if (person is StandStranger):
		ask_sound_player.pitch_scale = 0.8
	elif (person is AngryStranger):
		ask_sound_player.pitch_scale = 0.6
	elif (person is Stranger):
		ask_sound_player.pitch_scale = 0.7
	
	ask_sound_player.play()
	

func _on_give_answer_button_pressed() -> void:
	Signals.close_dialogue.emit(main_person, second_person)
	queue_free()

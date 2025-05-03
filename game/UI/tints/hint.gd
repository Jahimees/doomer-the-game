extends Node2D

@onready var label = $MarginContainer/Label
@onready var showAnimation = $ShowAnimation
@onready var hideAnimation = $HideAnimation

@export var label_text: String = ''

func _ready():
	label.visible = false
	label.text = label_text

func _on_collision_area_body_entered(body: Node2D) -> void:
	print('in')
	label.visible = true
	showAnimation.play("new_animation")
	await showAnimation.animation_finished


func _on_collision_area_body_exited(body: Node2D) -> void:
	print('out')
	showAnimation.play_backwards("new_animation")
	await showAnimation.animation_finished
	label.visible = false

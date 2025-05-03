extends Area2D


func _ready():
	$AnimationPlayer.play("cigarette_idle_anim")

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if (body.has_method('change_cigarettes_count')):
		body.change_cigarettes_count(1)
		queue_free()

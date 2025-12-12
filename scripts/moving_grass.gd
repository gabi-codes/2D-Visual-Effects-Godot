extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	var rand_dir = [-1, 1].pick_random()
	var rand_degrees = randf_range(10, 35)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", rand_dir * rand_degrees, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_area_2d_body_exited(body: Node2D) -> void:
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", 0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

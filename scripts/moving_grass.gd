extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	
	var rand_dir = [-1, 1].pick_random()
	var rand_degrees = randf_range(10, 35)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", rand_dir * rand_degrees, 0.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _on_area_2d_body_exited(body: Node2D) -> void:
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "rotation_degrees", 0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

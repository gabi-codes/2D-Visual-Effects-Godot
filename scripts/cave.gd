extends Area2D


func _on_body_entered(body: Node2D) -> void:
	Global.cave_in.emit()


func _on_body_exited(body: Node2D) -> void:
	Global.cave_out.emit()

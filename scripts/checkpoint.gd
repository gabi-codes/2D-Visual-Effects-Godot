extends Area2D


func _on_body_entered(body: Node2D) -> void:
	Global.respown_position = self.global_position

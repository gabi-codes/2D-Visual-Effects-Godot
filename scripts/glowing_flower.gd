extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var point_light_2d: PointLight2D = $PointLight2D

var touched_sprite: Texture = preload("res://assets/Plant Animations/BlueFlower1/BlueFlower_00000.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while true:
		var final_rotation
		if self.rotation_degrees < 0: final_rotation = 12
		else: final_rotation = -12
		
		var time : float = randf_range(5, 10)
		
		var tween : Tween = get_tree().create_tween()
		tween.tween_property(self, "rotation_degrees", final_rotation, time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		await tween.finished


func _on_checkpoint_body_entered(body: Node2D) -> void:
	sprite_2d.texture = touched_sprite
	point_light_2d.energy = 1.0
	Global.respown_position = self.global_position + Vector2(-80, -650)

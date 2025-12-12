extends TileMapLayer

@onready var character_body_2d: CharacterBody2D = $"../CharacterBody2D"

func _process(delta: float) -> void:
	self.position.x = character_body_2d.position.x * 0.2
	self.position.y = character_body_2d.position.y * 0.2

extends TileMapLayer

@onready var character_body_2d: CharacterBody2D = $"../CharacterBody2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position.x = character_body_2d.position.x * 0.2
	self.position.y = character_body_2d.position.y * 0.2

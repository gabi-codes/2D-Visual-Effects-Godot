extends ColorRect

@onready var label: Label = $Label
@onready var character_body_2d: CharacterBody2D = $"../../CharacterBody2D"

var time: float = 0
var stop_timer: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0.0
	label.modulate.a = 0.0


func _process(delta: float) -> void:
	if !stop_timer:
		time += delta



func _on_area_2d_body_entered(body: Node2D) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(label, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	
	var min = floor(time / 60)
	var sec = fmod(time, 60)
	var mil = fmod(time, 1) * 100
	
	stop_timer = true
	label.text = "Time  %d:%d:%d\nDeaths  %s" % [min, sec, mil, character_body_2d.deaths]
	
	await get_tree().create_timer(5).timeout
	
	get_tree().quit()

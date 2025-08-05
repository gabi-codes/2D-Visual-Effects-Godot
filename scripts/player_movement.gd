extends CharacterBody2D

@onready var dash_timer: Timer = $DashTimer
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D

@export var max_speed : float = 1200.0
@export var gravity : float = 130
@export var jump_force : int = 3400
@export var dash_force : int = 3500
@export var acceleration : int = 150
@export var jump_buffer : int = 10
@export var cayote_time : int = 7

signal player_dash

var jump_buffer_counter : int = 0
var cayote_counter : int = 0
var can_dash : bool = true
var dashing : bool = false
var spikes_touched : bool = false
var can_double_jump : bool = true


func _ready() -> void:
	Global.spike_touched.connect(death)


func _physics_process(delta: float) -> void:
	
	if spikes_touched: return
	move_and_slide()

	var direction = Input.get_axis("left", "right")

	if Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer
	
	if Input.is_action_just_released("jump") and velocity.y < 0 and not dashing:
		velocity.y *= 0.2

	if Input.is_action_just_pressed("dash") and can_dash: 
		dash()
		
	if direction == 1:
		sprite_2d.flip_h = false
	elif direction == -1:
		sprite_2d.flip_h = true

	if is_on_floor():
		can_double_jump = true
		cayote_counter = cayote_time
		if not dashing: can_dash = true
		if direction == 0: sprite_2d.play("idle")
		else: sprite_2d.play("walk")
	
	if velocity.y != 0 and sprite_2d.animation != "jump":
		sprite_2d.play("jump")
	
	if not is_on_floor():
		if cayote_counter > 0: cayote_counter -= 1
		if dashing: velocity.y = 0
		if not dashing: velocity.y += gravity
		if velocity.y > 6000: velocity.y = 6000
		
		if Input.is_action_just_pressed("jump") and can_double_jump and not dashing and cayote_counter == 0:
			sprite_2d.play("jump")
			velocity.y = -jump_force * 0.8
			can_double_jump = false
	
	if jump_buffer_counter > 0: jump_buffer_counter -= 1
	
	if jump_buffer_counter > 0 and cayote_counter > 0:
		velocity.y = -jump_force
		jump_buffer_counter = 0
		cayote_counter = 0
	
	if not dashing:
	
		if direction:
			velocity.x += acceleration * direction
			if velocity.x > max_speed: velocity.x = lerp(velocity.x, max_speed, 0.2)
			elif velocity.x < -max_speed: velocity.x = lerp(velocity.x, -max_speed, 0.2)
		else:
			velocity.x = lerp(velocity.x, 0.0, 0.35)
	

func dash():
	var dir : int = 1
	if sprite_2d.flip_h: dir = -1
	
	velocity.x = dash_force * dir
	dash_timer.start(0.2)
	dashing = true
	can_dash = false


func death():
	
	if spikes_touched: return
	
	var direction = velocity.normalized() * -1
	var death_position : Vector2 = self.position + direction * 600
	
	spikes_touched = true
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "position", death_position, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite_2d.material, "shader_parameter/dissolve_value", 0.0, 0.4)
	tween.tween_property(self, "position", Global.respown_position, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(sprite_2d.material, "shader_parameter/dissolve_value", 1.0, 0.4)
	
	await tween.finished
	velocity = Vector2.ZERO
	spikes_touched = false


func _on_dash_timer_timeout() -> void:
	dashing = false

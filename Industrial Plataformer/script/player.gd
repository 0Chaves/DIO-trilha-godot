extends CharacterBody2D


@export var speed = 5
@export_range(0,1) var lerp_factor = 0.204
@export var lerp_factor_rotarion = 0.2


@onready var sprite = $Sprite

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var target_velocity = direction * speed * 100
	velocity = lerp(velocity, target_velocity,lerp_factor)
	move_and_slide()
	
	var target_rotarion = direction.x * 45
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, target_rotarion, lerp_factor_rotarion)

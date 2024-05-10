extends Node

@export var speed:float = 1

#@onready var sprite2d:AnimatedSprite2D = $AnimatedSprite2D
var enemy: Enemy
var sprite2d: AnimatedSprite2D


func _ready():
	enemy = get_parent()
	sprite2d = enemy.get_node("AnimatedSprite2D")

func _physics_process(delta):
	#Calcular direção
	var player_position = GameManager.player_position
	var vector_toPlayer:Vector2 = (player_position - enemy.position).normalized()
	
	#Movimento
	enemy.velocity = vector_toPlayer * speed * 100
	enemy.move_and_slide()
	
	#Girar sprite
	if enemy.velocity.x < 0:
		sprite2d.flip_h = true
	elif enemy.velocity.x > 0:
		sprite2d.flip_h = false
	



class_name life_regen
extends Node2D

@export var regen_amount: int = 10

@onready var area2d: Area2D = $Area2D
@onready var animation: AnimationPlayer = $AnimationPlayer

func _ready():
	area2d.body_entered.connect(on_body_entered)

func on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regen_amount)
		print(player.health)
		self.animation.play("collected")
		#queue_free() chamada na animação
	

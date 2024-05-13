class_name Enemy
extends Node2D

@export var health: int = 10
@export var death_scene: PackedScene = preload("res://enemies/behaviors/death.tscn")
@export var enemy_damage: int = 1

func damage(amount: int):
	health -= amount
	print("Inimigo recebeu dano de ", amount, ". A vida total é de ", health)
	
	# Piscar node
	modulate = '#ff9494' # hexadecimal da cor
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

	#Processar morte
	if health <= 0:
		die()

func die():
	if death_scene:
		var death_object = death_scene.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	queue_free()

extends Node2D

#TODO: Compreender a diferença entre packedscene e node

@onready var path_follow_2d:PathFollow2D = %PathFollow2D

@export var creatures: Array[PackedScene]
@export var mobs_per_second: float = 2.0
var interval: float = 1 / mobs_per_second
var cooldown: float = 0.0

func _process(delta: float):
	#Frequencia: monstros por minuto/segundo definido no escopo global
	#Temporizador (cooldown)
	if (cooldown > 0):
		cooldown -= delta
		return
	cooldown = interval
	
	#Instanciar uma criatura aleatória
	# - Pegar criatura aleatória
	# - Pegar ponto aleatório
	# - Instanciar cena
	# - Colocar na poisção
	var index: int = randi_range(0,creatures.size() - 1)
	var creature_scene: PackedScene = creatures[index]
	var creature: CharacterBody2D = creature_scene.instantiate()
	creature.global_position = get_point()
	get_parent().add_child(creature)
	
func get_point() -> Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position


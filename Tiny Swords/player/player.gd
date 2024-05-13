class_name Player
extends CharacterBody2D

@export_category("Movement")
@export_range(1,15) var speed:float = 4
@export_range(0,1) var lerp_factor_velocity = 0.3

@export_category("Life")
@export var health: int = 100
@export var max_health: int = 100
@export var death_scene: PackedScene = preload("res://enemies/behaviors/death.tscn")

@export_category("Sword")
@export var sword_damage: int = 3

@export_category("Magic")
@export var magic_1_damage: int = 15
@export var magic_1_interval: float = 30
@export var magic_1_scene: PackedScene = preload("res://player/magic_1.tscn")


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite2d: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea
@onready var hitbox_area: Area2D = $HitboxArea

#TODO: pensar numa forma de separar as duas checagens de running e attacking pois se correr e atacar, o correr só volta pra falso depois que o ataque para
#TODO: pensar numa forma de alterar a velocidade do ataque e de animação
#TODO: pensar em como fazer os objetos certos ficarem na frente da tela, e nao por hierarquia
var is_running: bool = false
func getrunning():
	if is_running:
		return "True"
	elif !is_running:
		return "False"
var is_attacking: bool = false
func getattack():
	if is_attacking:
		return "True"
	elif !is_attacking:
		return "False"
var input_vector:Vector2 = Vector2(0,0)
var attack_cooldown: float = 0.0
var hitbox_cooldown: float = 0.0
var magic_1_cooldown: float = 0.0

func _process(delta: float) -> void:
	#Transfere a posicao do jogador para o script GameManeger
	GameManager.player_position = position
	#ler input
	read_input()
	#Processar attack
	update_attack_cooldown(delta)
	if Input.is_action_just_pressed("attack"):
		attack()
	#Processar animação
	play_run_idle_animation()
	
	#Processar dano
	update_hitbox_detection(delta)
	
	#Magic_1
	update_magic_1(delta)
	
func _physics_process(delta):
	#Modifica a velocidade
	var target_velocity = input_vector * speed * 100
	if is_attacking:
		target_velocity *= 0.2
	velocity = lerp(velocity, target_velocity, lerp_factor_velocity)
	move_and_slide()
	
func read_input() -> void:
	#Obtem o input vecotr
	input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down", 0.15)
func attack() ->void:
	if is_attacking:
		return
	#attack_side_1
	#attack_side_2
	#Executa animação de ataque e seta o cooldown
	animation_player.play("attack_side_1")
	#Configurar temporizador
	attack_cooldown = 0.6
	#Marcar ataque
	is_attacking = true
	
	#aplicar dano nos inimigos
	 #chamado no animation player para dar match com o frame certo

func deal_damage_to_enemies():
	#Acessar todos os inimigos
	var bodies = sword_area.get_overlapping_bodies()
	#var enemies = get_tree().get_nodes_in_group("enemies") #retorna um array de nodes que estao instanciados no grupo
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			var direction_to_enemy:Vector2 = (enemy.position - position).normalized()
			var attack_direction:Vector2
			if sprite2d.flip_h:
				attack_direction = Vector2.LEFT
			else:
				attack_direction = Vector2.RIGHT
			var dot_product = attack_direction.dot(direction_to_enemy)
			
			if(dot_product <= 1 && dot_product > cos(PI/3)):
				enemy.damage(sword_damage)
	#Chamar a função 'damage'
	# com sword damage como parametro
	# sendo chamada na animação

func update_attack_cooldown(delta: float):
	# Atualizar temporizador do ataque
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0.0:
				is_attacking = false
	$Label.text = getattack()
	$Label2.text = getrunning()
func update_magic_1(delta: float):
	#Atualizar temporizador
	if magic_1_cooldown > 0:
		magic_1_cooldown -= delta
		return
	magic_1_cooldown = magic_1_interval
	
	#Criar magia
	var magic_1 := magic_1_scene.instantiate() as Magic_1
	magic_1.damage_amount = magic_1_damage
	add_child(magic_1)
	
func play_run_idle_animation():
	#Executa animação de correr e parar
	if !is_attacking:
		if input_vector.is_zero_approx():
			is_running = false
			animation_player.play("idle")
		else:
			is_running = true
			animation_player.play("run")
			if input_vector.x < 0:
				sprite2d.flip_h = true
			elif input_vector.x > 0:
				sprite2d.flip_h = false
func update_hitbox_detection(delta:float):
	#Temporizador
	if hitbox_cooldown > 0: 
		hitbox_cooldown -= delta
		return
	
	#Detectar inimigos
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy: Enemy = body
			damage(enemy.enemy_damage)
	#Frequência (2x por segundo)
	hitbox_cooldown = 0.5
func damage(amount: int):
	if health <= 0: return
	health -= amount
	print("Player recebeu dano de ", amount, ". A vida total é de ", health)
	
	# Piscar node
	modulate = '#ff9494' # hexadecimal da cor
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate", Color.WHITE, 0.3)

	#Processar morte
	if health <= 0:
		die()
func heal(amount: int) -> int:
	health += amount
	if health > max_health:
		health = max_health
	return health
func die():
	if death_scene:
		var death_object = death_scene.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	print("Player morreu!")
	queue_free()

extends CharacterBody2D

@export_range(1,15) var speed:float = 4
@export_range(0,1) var lerp_factor_velocity = 0.3
@export var sword_damage: int = 3

@export var health: int = 100
@export var death_scene: PackedScene = preload("res://enemies/behaviors/death.tscn")


@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite2d: Sprite2D = $Sprite2D
@onready var sword_area: Area2D = $SwordArea

#TODO: pensar numa forma de separar as duas checagens de running e attacking pois se correr e atacar, o correr só volta pra falso depois que o ataque para
#TODO: pensar numa forma de alterar a velocidade do ataque e de animação
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

var attack_cooldown: float = 0.0
var input_vector:Vector2 = Vector2(0,0)

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
	var enemies = sword_area.get_overlapping_bodies()
	#var enemies = get_tree().get_nodes_in_group("enemies") #retorna um array de nodes que estao instanciados no grupo
	for enemy in enemies:
		if enemy.is_in_group("enemies"):
			
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
	
func damage(amount: int):
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

func die():
	if death_scene:
		var death_object = death_scene.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
	
	queue_free()

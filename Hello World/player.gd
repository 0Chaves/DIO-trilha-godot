extends Sprite2D
#IMPORTANTE pesquisar sobre whiteboxing/grayboxig



@export var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Hello World from player!")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#position.x += input.x * 10.0
	#position.y += input.y * 10.0
	position += input * speed * delta
	#print(delta)

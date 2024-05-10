extends Node

@export var object_templates: Array[PackedScene]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	#check if event is a left click
	var mousebutton := event as InputEventMouseButton
	if(!mousebutton):
		return
	if(mousebutton.get_button_index() == MouseButton.MOUSE_BUTTON_LEFT):
		if(mousebutton.pressed):
			spawn_object(mousebutton.position)
	
	#if event is InputEventMouseButton:
		
	#if(event.is_class(InputEventMouseButton.new().get_class())):
		#print(((InputEventMouseButton)event).get)

func spawn_object(position: Vector2) -> void:
	var index:int = randi_range(0, object_templates.size() - 1)
	var object_template = object_templates[index]
	var object: RigidBody2D = object_template.instantiate()
	object.position = position
	add_child(object)

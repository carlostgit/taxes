extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (NodePath) var _node_path_worker

const MyArea2D_oreResource = preload("res://Area2D_ore.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_down"):
		send_ore_to_worker(1)
		
func set_ore(var value_arg):
	$Label_ore.set_text(str(value_arg))

func get_ore():
	var value_text = $Label_ore.get_text()
	var value = float(value_text)
	return value

func add_ore(var value_arg):
	var value = get_ore()
	set_ore(value+value_arg)

func send_ore_to_worker(var amount_arg):
	var ore = MyArea2D_oreResource.instance()
	self.get_parent().add_child(ore)
	var destiny = get_node(_node_path_worker)
	ore.set_origin_destiny(self.get_node("."),destiny)
	ore.set_value(amount_arg)
	add_ore(-amount_arg)

func send_1_ore_to_worker():
	send_ore_to_worker(1.0)

func _on_KinematicBody2D_worker_working_signal():
	send_1_ore_to_worker()

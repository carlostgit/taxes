extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var _speed = 10000

export (NodePath) var _shop_path

const MyArea2D_oreResource = preload("res://Area2D_ore.tscn")
const MyNode2D_CoinResource = preload("res://Node2D_Coin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout",self,"on_timer_timeout")
	$Timer.start()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var step_distance = _speed*delta
	
	if Input.is_action_pressed("ui_left"):
		$AnimationPlayer_slacker.play("left")
		$slacker.set_flip_h(false)
		
		self.move_and_slide(Vector2(-step_distance,0))
	elif Input.is_action_pressed("ui_right"):
		$AnimationPlayer_slacker.play("left")
		$slacker.set_flip_h(true)
		self.move_and_slide(Vector2(step_distance,0))
#		add_money(1.1)
#		update()
	elif Input.is_action_pressed("ui_up"):
		$AnimationPlayer_slacker.play("up")
		self.move_and_slide(Vector2(0,-step_distance))
	elif Input.is_action_pressed("ui_down"):
		$AnimationPlayer_slacker.play("down")
		self.move_and_slide(Vector2(0,step_distance))
	else:
		$AnimationPlayer_slacker.stop()

func set_money(var value_arg):
	$Label_money.set_text(str(value_arg))

func get_money():
	var value_text = $Label_money.get_text()
	var value = float(value_text)
	return value

func add_money(var value_arg):
	var value = get_money()
	set_money(value+value_arg)

func set_ore(var value_arg):
	$Label_ore.set_text(str(value_arg))

func get_ore():
	var value_text = $Label_ore.get_text()
	var value = float(value_text)
	return value

func add_ore(var value_arg):
	var value = get_ore()
	set_ore(value+value_arg)

func set_candy(var value_arg):
	$Label_candy.set_text(str(value_arg))

func get_candy():
	var value_text = $Label_candy.get_text()
	var value = float(value_text)
	return value

func add_candy(var value_arg):	
	var value = get_candy()
	set_candy(value+value_arg)

func hit_money(var value_arg, var origin_arg, var destiny_arg):
	add_money(value_arg)

#	var current_money = get_money()
#	if (current_money>0):
#		var shop_node = self.get_node(_shop_path)
#		self.call_deferred("send_money",current_money,shop_node)


func hit_ore(var value_arg, var origin_arg, var destiny_arg):
	add_ore(value_arg)
	
	
func hit_candy(var value_arg, var origin_arg, var destiny_arg):
	add_candy(value_arg)
	
#######################
#Send methods
func send_ore(var amount_arg, var destiny_arg):
	var ore = MyArea2D_oreResource.instance()
	self.get_parent().add_child(ore)
	#self.get_tree().get_root().add_child(ore)
	ore.set_origin_destiny(self,destiny_arg)
	ore.set_value(amount_arg)
	add_ore(-amount_arg)

func send_money(var amount_arg, var destiny_arg):
	var money = MyNode2D_CoinResource.instance()
	self.get_parent().add_child(money)
	#self.get_tree().get_root().add_child(money)
	money.set_origin_destiny(self,destiny_arg)
	money.set_value(amount_arg)
	add_money(-amount_arg)	
	
func on_timer_timeout():
	var current_money = get_money()
	if (current_money>0):
		var shop_node = self.get_node(_shop_path)
		self.call_deferred("send_money",current_money,shop_node)

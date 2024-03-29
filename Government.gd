extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (NodePath) var _slacker_path = "../Slacker"

const MyCoinResource = preload("res://Coin.tscn")

var _money:float = 0.0
var _collected:float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout",self,"on_timer_timeout")
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_money(var value_arg):
	var value_rounded = stepify(value_arg, 0.01)
	$Label_money.set_text(str(value_rounded))
	self._money = value_arg

func get_money():
	return self._money

func add_money(var value_arg):
	var value = get_money()
	set_money(value+value_arg)

	if(value_arg>0):
		add_collected(value_arg)

func set_collected(var value_arg):
	var value_arg_rounded = stepify(value_arg, 0.01)
	$Label_collected.set_text(str(value_arg_rounded))
	self._collected = value_arg


func get_collected():
	return self._collected

func add_collected(var value_arg):
	var value = get_collected()
	set_collected(value+value_arg)

func hit_money(var value_arg, var origin_arg, var destiny_arg):
	add_money(value_arg)

#Deferred functions
func send_money(var amount_arg, var destiny_node_arg):
		var coin = MyCoinResource.instance()
		self.get_parent().add_child(coin)
		coin.set_origin_destiny(self,destiny_node_arg)
		coin.set_value(amount_arg)
		add_money(-amount_arg)

func on_timer_timeout():
	var current_money = get_money()

	if(current_money >= 0.01):
		call_deferred("send_money",current_money,self.get_node(_slacker_path))

func get_revenue():
	return self.get_collected()

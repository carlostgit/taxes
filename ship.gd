extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const MyNode2D_moneyResource = preload("res://Node2D_Coin.tscn")
const MyNode2D_candyResource = preload("res://Area2D_candy.tscn")

var _money = 0.0
var _ore = 0.0
var _candy = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func set_money(var value_arg):
	var value_arg_rounded = stepify(value_arg, 0.01)
	$Label_money.set_text(str(value_arg_rounded))
	
	self._money = value_arg

func get_money():
	return self._money
	
func add_money(var value_arg):
	var value = get_money()
	set_money(value+value_arg)

func set_ore(var value_arg):
	$Label_ore.set_text(str(value_arg))
	self._ore	= value_arg

func get_ore():
	return self._ore

func add_ore(var value_arg):
	var value = get_ore()
	set_ore(value+value_arg)

func hit_ore(var value_arg, var origin_arg, var destiny_arg):
	add_ore(value_arg)	
	call_deferred("send_money",value_arg, origin_arg)

func set_candy(var value_arg):
	var value_rounded = stepify(value_arg,0.01)
	$Label_candy.set_text(str(value_rounded))
	self._candy = value_arg

func get_candy():
	return self._candy

func add_candy(var value_arg):
	var value = get_candy()
	set_candy(value+value_arg)

func send_money(var amount_arg, var destiny_node_arg):
	if(amount_arg != 0):
		var coin = MyNode2D_moneyResource.instance()
		self.get_parent().add_child(coin)
		coin.set_origin_destiny(self,destiny_node_arg)
		coin.set_value(amount_arg)
		add_money(-amount_arg)

func hit_money(var value_arg, var origin_arg, var destiny_arg):
	add_money(value_arg)
	call_deferred("send_candy",value_arg, origin_arg)

func send_candy(var amount_arg, var destiny_node_arg):
	var candy = MyNode2D_candyResource.instance()
	self.get_parent().add_child(candy)
	candy.set_origin_destiny(self,destiny_node_arg)
	candy.set_value(amount_arg)
	add_candy(-amount_arg)

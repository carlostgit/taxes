extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (NodePath) var _slacker_path

const MyNode2D_moneyResource = preload("res://Node2D_Coin.tscn")



# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout",self,"on_timer_timeout")
	$Timer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_money(var value_arg):
	$Label_money.set_text(str(value_arg))

func get_money():
	var value_text = $Label_money.get_text()
	var value = float(value_text)
	return value

func add_money(var value_arg):
	var value = get_money()
	set_money(value+value_arg)
	
	if(value_arg>0):
		add_collected(value_arg)

func set_collected(var value_arg):
	$Label_collected.set_text(str(value_arg))

func get_collected():
	var value_text = $Label_collected.get_text()
	var value = float(value_text)
	return value

func add_collected(var value_arg):
	var value = get_collected()
	set_collected(value+value_arg)


func hit_money(var value_arg, var origin_arg, var destiny_arg):
	add_money(value_arg)
	
#		var coin = MyNode2D_moneyResource.instance()
#		self.get_parent().add_child(coin)
#		coin.set_origin_destiny(self,self.get_node(_slacker_path))
#		coin.set_value(current_money)
#		add_money(-current_money)
		
#Deferred functions
func send_money(var amount_arg, var destiny_node_arg):
		var coin = MyNode2D_moneyResource.instance()
		self.get_parent().add_child(coin)
		coin.set_origin_destiny(self,destiny_node_arg)
		coin.set_value(amount_arg)
		add_money(-amount_arg)

func on_timer_timeout():
	var current_money = get_money()
	
	if(current_money > 0.01):
		call_deferred("send_money",current_money,self.get_node(_slacker_path))

func get_revenue():
	return self.get_collected()
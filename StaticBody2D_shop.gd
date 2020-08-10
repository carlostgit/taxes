extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (NodePath) var _government

export (bool) var _automatic_mode = false

const MyNode2D_candyResource = preload("res://Area2D_candy.tscn")
#const MyNode2D_oreResource = preload("res://Area2D_ore.tscn")
const MyNode2D_moneyResource = preload("res://Node2D_Coin.tscn")

var _tax_rate = 0.25

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (get_money()>0):
		$Button_pay_taxes.show()
	else:
		$Button_pay_taxes.hide()
		
#	pass
#	_tax_rate
	
#	var price_before_taxes = price_after_taxes / (1-_tax_rate)
	var price_before_taxes = 1.0 / (1-_tax_rate)
	var price_before_taxes_rounded = stepify(price_before_taxes, 0.01)
	$Control_prices/Label_candy_RP.set_text(str(price_before_taxes_rounded))

func set_money(var value_arg):
	$Label_money.set_text(str(value_arg))

func get_money():
	var value_text = $Label_money.get_text()
	var value = float(value_text)
	return value

func add_money(var value_arg):
	var value = get_money()
	set_money(value+value_arg)

func set_after_taxes(var value_arg):
	$Label_after_taxes.set_text(str(value_arg))

func get_after_taxes():
	var value_text = $Label_after_taxes.get_text()
	var value = float(value_text)
	return value

func add_after_taxes(var value_arg):
	var value = get_after_taxes()
	set_after_taxes(value+value_arg)


func hit_money(var value_arg, var origin_arg, var destiny_arg):
	add_money(value_arg)
	
	yield(get_tree().create_timer(0.5), "timeout")
	
#
	var taxes = _tax_rate*value_arg
	var taxes_rounded = stepify(taxes, 0.01)
	var value_aft_taxes = value_arg - taxes_rounded
#
#	add_after_taxes(value_aft_taxes)
#	add_money(-value_aft_taxes)
	
	
	
	call_deferred("send_candy",value_aft_taxes,origin_arg)
#	var candy = MyNode2D_candyResource.instance()
#	self.get_parent().add_child(candy)
#	candy.set_origin_destiny(self,origin_arg)
#	candy.set_value(value_aft_taxes)	
#	add_candy(-value_aft_taxes)
	
	
#	pay_taxes(taxes)
#	if (self._automatic_mode):
#		call_deferred("pay_taxes")

func set_ore(var value_arg):
	$Label_ore.set_text(str(value_arg))

func get_ore():
	var value_text = $Label_ore.get_text()
	var value = float(value_text)
	return value

func add_ore(var value_arg):
	var value = get_ore()
	set_ore(value+value_arg)

func hit_ore(var value_arg, var origin_arg, var destiny_arg):
	add_ore(value_arg)
	
	#Hay que hacer call_deferred pq se crean Area2d nodes
	#y mientras se procesa una señal de bodyentered o del estilo,
	#no conviene añadir areas o bodies
	call_deferred("send_money",value_arg, origin_arg)
#	var coin = MyNode2D_moneyResource.instance()
#	self.get_parent().add_child(coin)
#	coin.set_origin_destiny(self,origin_arg)
#	coin.set_value(value_arg)
#	add_money(-value_arg)

	

func set_candy(var value_arg):
	var value_rounded = stepify(value_arg,0.01)
	$Label_candy.set_text(str(value_rounded))

func get_candy():
	var value_text = $Label_candy.get_text()
	var value = float(value_text)
	return value

func add_candy(var value_arg):
	var value = get_candy()
	set_candy(value+value_arg)

func hit_candy(var value_arg, var origin_arg, var destiny_arg):
	add_candy(value_arg)
	
	call_deferred("send_money",value_arg,origin_arg)
#	var coin = MyNode2D_moneyResource.instance()
#	self.get_parent().add_child(coin)
#	coin.set_origin_destiny(self,origin_arg)
#	coin.set_value(value_arg)
	add_after_taxes(-value_arg)

################################
#func pay_taxes(var amount_arg):
#	var coin_gov = MyNode2D_moneyResource.instance()
#	self.get_parent().add_child(coin_gov)
#	coin_gov.set_origin_destiny(self,get_node(_government))
#	coin_gov.set_value(amount_arg)
#	add_money(-amount_arg)	
#	var remaining_money = get_money()
#	if (remaining_money>0):
#		add_money(-remaining_money)
#		add_after_taxes(remaining_money)	

func send_money(var amount_arg, var destiny_node_arg):
	if(amount_arg != 0):
		var coin = MyNode2D_moneyResource.instance()
		self.get_parent().add_child(coin)
		coin.set_origin_destiny(self,destiny_node_arg)
		coin.set_value(amount_arg)
		add_after_taxes(-amount_arg)

func send_candy(var amount_arg, var destiny_node_arg):
	var candy = MyNode2D_candyResource.instance()
	self.get_parent().add_child(candy)
	candy.set_origin_destiny(self,destiny_node_arg)
	candy.set_value(amount_arg)
	add_candy(-amount_arg)


func set_value_added_tax_rate(var rate):
	_tax_rate = rate

func pay_taxes():
	var money = get_money()
	if (money>0):
		var taxes = _tax_rate*money
		var taxes_rounded = stepify(taxes, 0.01)
		var coin_gov = MyNode2D_moneyResource.instance()
		self.get_parent().add_child(coin_gov)
		coin_gov.set_origin_destiny(self,get_node(_government))
		coin_gov.set_value(taxes_rounded)
		add_money(-taxes_rounded)	
		var remaining_money = get_money()
		if (remaining_money>0):
			add_money(-remaining_money)
			add_after_taxes(remaining_money)	

func _on_Button_pay_taxes_pressed():
	self.pay_taxes()
	
func set_automatic_mode(var automatic_mode_arg):
	self._automatic_mode = automatic_mode_arg



func _on_Timer_timeout():
	if (self._automatic_mode):
		call_deferred("pay_taxes")

	

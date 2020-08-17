extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export (NodePath) var _government

export (NodePath) var _ship

export (bool) var _automatic_mode = false

const MyNode2D_candyResource = preload("res://Area2D_candy.tscn")
#const MyNode2D_oreResource = preload("res://Area2D_ore.tscn")
const MyNode2D_moneyResource = preload("res://Node2D_Coin.tscn")

var _tax_rate = 0.25

var _candy:float = 0.00
var _money:float = 0.00
var _after_taxes:float = 0.00
var _ore:float = 0.00

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (get_money()>0):
		$Button_pay_taxes.show()
	else:
		$Button_pay_taxes.hide()
	
	if (get_after_taxes()>0.001):
		$Button_buy_candies.show()
	else:
		$Button_buy_candies.hide()
	
	
#	var price_before_taxes = price_after_taxes / (1-_tax_rate)
	var price_before_taxes = 1.0 / (1-_tax_rate)
	var price_before_taxes_rounded = stepify(price_before_taxes, 0.01)
	$Control_prices/Label_candy_RP.set_text(str(price_before_taxes_rounded))

func set_money(var value_arg):
	var value_arg_rounded = stepify(value_arg, 0.01)
	$Label_money.set_text(str(value_arg_rounded))
	
	self._money = value_arg

func get_money():
#	var value_text = $Label_money.get_text()
#	var value = float(value_text)
#	return value
	return self._money
	
func add_money(var value_arg):
	var value = get_money()
	set_money(value+value_arg)
	
func set_after_taxes(var value_arg):
	var value_rounded = stepify(value_arg,0.01)
	$Label_after_taxes.set_text(str(value_rounded))
	self._after_taxes = value_arg
	
func get_after_taxes():
#	var value_text = $Label_after_taxes.get_text()
#	var value = float(value_text)
#	return value
	return self._after_taxes

func add_after_taxes(var value_arg):
	var value = get_after_taxes()
	set_after_taxes(value+value_arg)

func hit_money(var value_arg, var origin_arg, var destiny_arg):
#	var previous_stock_value = get_stock_value()
		
#	var value_rounded = stepify(value_arg, 0.01)
#	add_money(value_rounded)
	
	add_money(value_arg)
#	yield(get_tree().create_timer(0.5), "timeout")
	#
	var taxes = _tax_rate*value_arg

#	var taxes_rounded = stepify(taxes, 0.01)

#	var value_aft_taxes = value_arg - taxes_rounded
	var value_aft_taxes = value_arg - taxes

#	Para corregir los errores por redondeo
#	var correction = 0.00
#	var stock_value = get_stock_value()
#	if (stock_value>=0.01):
#		correction = 0.01
#	elif (stock_value<=-0.01):
#		correction = -0.01
#	Me aseguro de que la tienda ni gane ni pierda dinero
#	var previous_stock_value = get_stock_value()-value_rounded
#	var correction = previous_stock_value
	

	call_deferred("send_candy",value_aft_taxes, origin_arg)

func get_stock_value():
	return get_money()*(1-_tax_rate)+get_after_taxes()+get_candy()

func set_ore(var value_arg):
	$Label_ore.set_text(str(value_arg))
	self._ore	= value_arg

func get_ore():
#	var value_text = $Label_ore.get_text()
#	var value = float(value_text)
#	return value
	return self._ore

func add_ore(var value_arg):
	var value = get_ore()
	set_ore(value+value_arg)

func hit_ore(var value_arg, var origin_arg, var destiny_arg):
	add_ore(value_arg)
	
	#Hay que hacer call_deferred pq se crean Area2d nodes
	#y mientras se procesa una señal de bodyentered o del estilo,
	#no conviene añadir areas o bodies
	call_deferred("send_money",value_arg, origin_arg)

func set_candy(var value_arg):
	var value_rounded = stepify(value_arg,0.01)
	$Label_candy.set_text(str(value_rounded))
	self._candy = value_arg

func get_candy():
#	var value_text = $Label_candy.get_text()
#	var value = float(value_text)
#	return value
	return self._candy

func add_candy(var value_arg):
	var value = get_candy()
	set_candy(value+value_arg)

func hit_candy(var value_arg, var origin_arg, var destiny_arg):
	add_candy(value_arg)
	
#	call_deferred("send_money",value_arg,origin_arg)
#	add_after_taxes(-value_arg)

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
#		var taxes_rounded = stepify(taxes, 0.01)
		var coin_gov = MyNode2D_moneyResource.instance()
		self.get_parent().add_child(coin_gov)
		coin_gov.set_origin_destiny(self,get_node(_government))
#		coin_gov.set_value(taxes_rounded)
		coin_gov.set_value(taxes)
#		add_money(-taxes_rounded)	
		add_money(-taxes)
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
		call_deferred("buy_candies")


func buy_candies():
	var after_taxes = get_after_taxes()
	if (after_taxes>0.001):
		var coin_gov = MyNode2D_moneyResource.instance()
		self.get_parent().add_child(coin_gov)
		coin_gov.set_origin_destiny(self,get_node(_ship))
		coin_gov.set_value(after_taxes)
		add_after_taxes(-after_taxes)
		


func _on_Button_buy_candies_pressed():
	call_deferred("buy_candies")
#	pass # Replace with function body.

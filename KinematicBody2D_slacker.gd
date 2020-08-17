extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var _speed = 10000

export (bool) var _automatic_mode = false

export (NodePath) var _shop_path

export (NodePath) var _ship_path

export (NodePath) var _government

const MyArea2D_oreResource = preload("res://Area2D_ore.tscn")
const MyNode2D_CoinResource = preload("res://Node2D_Coin.tscn")

var _tax_rate = 0.25

var _candy = 0.0
var _money = 0.0
var _after_taxes = 0.0
var _ore = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.connect("timeout",self,"on_timer_timeout")
	$Timer.start()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_overridable(delta)
	
func process_overridable(var delta):
	
#	var step_distance = _speed*delta
#
#	if Input.is_action_pressed("ui_left"):
#		$AnimationPlayer_slacker.play("left")
#		$slacker.set_flip_h(false)
#
##		self.move_and_slide(Vector2(-step_distance,0))
#	elif Input.is_action_pressed("ui_right"):
#		$AnimationPlayer_slacker.play("left")
#		$slacker.set_flip_h(true)
##		self.move_and_slide(Vector2(step_distance,0))
##		
#	elif Input.is_action_pressed("ui_up"):
#		$AnimationPlayer_slacker.play("up")
##		self.move_and_slide(Vector2(0,-step_distance))
#	elif Input.is_action_pressed("ui_down"):
#		$AnimationPlayer_slacker.play("down")
##		self.move_and_slide(Vector2(0,step_distance))
#	else:
#		$AnimationPlayer_slacker.stop()
		
#	Vista de los botones
	update_buttons_view()
	
func update_buttons_view():
	if (get_money()>0):
		$Button_pay_taxes.show()
	else:
		$Button_pay_taxes.hide()
	
	if (get_ore()>0):
		$Button_sell_ore.show()
	else:
		$Button_sell_ore.hide()
	
	if (get_after_taxes()>0):
		$Button_buy_candies.show()
	else:
		$Button_buy_candies.hide()


func set_corporate_tax_rate(var rate):
	_tax_rate = rate;

func set_money(var value_arg):
	var value_round = stepify(value_arg, 0.01)
	$Label_money.set_text(str(value_round))
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
	var value_rounded = stepify(value_arg, 0.01)
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

func set_ore(var value_arg):
	var value_rounded = stepify(value_arg,0.01)
	$Label_ore.set_text(str(value_rounded))
	self._ore = value_arg
	
func get_ore():
#	var value_text = $Label_ore.get_text()
#	var value = float(value_text)
#	return value
	return self._ore
	
func add_ore(var value_arg):
	var value = get_ore()
	set_ore(value+value_arg)

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

func hit_money(var value_arg, var origin_arg, var destiny_arg):
	add_money(value_arg)

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
	add_after_taxes(-amount_arg)	
	
func on_timer_timeout():
	
	if (_automatic_mode):
		self.call_deferred("pay_taxes")
	
	yield(get_tree().create_timer(0.5), "timeout")

	if (_automatic_mode):
		self.call_deferred("buy_candies")

func buy_candies():
	var current_money = get_after_taxes()
	
	if (current_money>0):
		var shop_node = self.get_node(_shop_path)
		self.call_deferred("send_money",current_money,shop_node)

func pay_taxes():
	var money_bef_taxes = self.get_money()
	var taxes = self._tax_rate*money_bef_taxes
#	var taxes_rounded = stepify(taxes, 0.01)
#	var money_after_taxes = money_bef_taxes-taxes_rounded
	var money_after_taxes = money_bef_taxes-taxes
	add_after_taxes(money_after_taxes)
	add_money(-money_after_taxes)
	
#	if (taxes_rounded>0):
	if (taxes>0):
		var coin_gov = MyNode2D_CoinResource.instance()
		self.get_parent().add_child(coin_gov)
		coin_gov.set_origin_destiny(self,get_node(_government))
#		coin_gov.set_value(taxes_rounded)
		coin_gov.set_value(taxes)
#		add_money(-taxes_rounded)
		add_money(-taxes)

func sell_ore():
	var current_ore = get_ore()
	if (current_ore > 0):
#		var shop_node = self.get_node(_shop_path)
#		call_deferred("send_ore",current_ore,shop_node)	
		var ship_node = self.get_node(_ship_path)
		call_deferred("send_ore",current_ore,ship_node)	

func _on_Button_pay_taxes_pressed():
	pay_taxes()

func _on_Button_buy_candies_pressed():
	buy_candies()

func _on_Button_sell_ore_pressed():
	sell_ore()

func set_automatic_mode(var automatic_mode_arg):
	self._automatic_mode = automatic_mode_arg
	
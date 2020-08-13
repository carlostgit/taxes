extends "res://KinematicBody2D_slacker.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _ready_to_work = true

var _GDP = 0.0

const MyNode2D_moneyResource = preload("res://Node2D_Coin.tscn")

signal working_signal


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer_work.connect("timeout",self,"on_timer_work_timeout")
	$Timer_work.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_overridable(delta)
	
func process_overridable(var delta):
	
#	var step_distance = _speed*delta
#
#	if Input.is_action_pressed("ui_left"):
#		$AnimationPlayer_slacker.play("working")
#		$slacker.set_flip_h(false)		
#		self.move_and_slide(Vector2(-step_distance,0))
#	elif Input.is_action_pressed("ui_right"):
#		$AnimationPlayer_slacker.play("waiting")
#		$slacker.set_flip_h(true)
#		self.move_and_slide(Vector2(step_distance,0))
#	elif Input.is_action_pressed("ui_up"):
#		$AnimationPlayer_slacker.play("working")
#		self.move_and_slide(Vector2(0,-step_distance))
#	elif Input.is_action_pressed("ui_down"):
#		$AnimationPlayer_slacker.play("waiting")
#		self.move_and_slide(Vector2(0,step_distance))
#	else:
#		$AnimationPlayer_slacker.stop()
	
	update_buttons_view()
	
func update_buttons_view():
	
#	Worker special buttons
	if (self._ready_to_work and false==self._automatic_mode):
		$Button_work.show()
	else:
		$Button_work.hide()

#	Inherited buttons
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




func hit_money(var value_arg, var origin_arg, var destiny_arg):
#	var taxes = self._tax_rate_worker*value_arg
#	var money_after_taxes = value_arg-taxes
#
	add_money(value_arg)
	
	add_to_GDP(value_arg)
	
#	self.call_deferred("pay_taxes",taxes)
	
	#var current_money = get_money()
#	if (money_after_taxes>0):
#		var shop_node = self.get_node(_shop_path)
#		self.call_deferred("send_money",money_after_taxes,shop_node)

	

#func pay_taxes(var amount_arg):
#	if (amount_arg!=0):
#		var coin_gov = MyNode2D_moneyResource.instance()
#		self.get_parent().add_child(coin_gov)
#		coin_gov.set_origin_destiny(self,get_node(_government))
#		coin_gov.set_value(amount_arg)
#		add_money(-amount_arg)		

#func pay_taxes():
#	var money_bef_taxes = self.get_money()
#	var taxes = self._tax_rate*money_bef_taxes
#	var money_after_taxes = money_bef_taxes-taxes
#
#	add_after_taxes(money_after_taxes)
#	add_money(-money_after_taxes)
#
#	if (taxes>0):
#		var coin_gov = MyNode2D_moneyResource.instance()
#		self.get_parent().add_child(coin_gov)
#		coin_gov.set_origin_destiny(self,get_node(_government))
#		coin_gov.set_value(taxes)
#		add_money(-taxes)

	
	
func on_timer_timeout():
	
#	var current_money = get_money()
#	var taxes = self._tax_rate_worker*current_money
#	var money_after_taxes = current_money-taxes
	if (self._automatic_mode):
		self.call_deferred("pay_taxes")

	yield(get_tree().create_timer(0.5), "timeout")
	
	if (self._automatic_mode):
		self.call_deferred("buy_candies")
	
#	var money_after_taxes = get_after_taxes()
#	if (money_after_taxes>0):
#		var shop_node = self.get_node(_shop_path)
#		self.call_deferred("send_money",money_after_taxes,shop_node)
	
	yield(get_tree().create_timer(0.5), "timeout") 
	
	if (self._automatic_mode):
		self.call_deferred("sell_ore")
		
#	var current_ore = get_ore()
#	if (current_ore > 0):
#		var shop_node = self.get_node(_shop_path)
#		call_deferred("send_ore",current_ore,shop_node)
	
func buy_candies():
	var money_after_taxes = get_after_taxes()
	if (money_after_taxes>0):
		var shop_node = self.get_node(_shop_path)
		self.call_deferred("send_money",money_after_taxes,shop_node)



#func _on_Button_pressed():
#	if(_ready_to_work):
#		emit_signal("working_signal")
#		_ready_to_work = false
#		yield(get_tree().create_timer(0.5), "timeout")
#		_ready_to_work = true


func _on_Button_work_pressed():
	work()
	
func work():
	if(_ready_to_work):
		
		_ready_to_work = false
		$AnimationPlayer_slacker.play("working")
		yield(get_tree().create_timer(1.0), "timeout")
		emit_signal("working_signal")
		$AnimationPlayer_slacker.play("waiting")
		_ready_to_work = true

	
func on_timer_work_timeout():
	if (_automatic_mode or $CheckButton_auto_work.is_pressed()):
		self.call_deferred("work")
		
	
func add_to_GDP(var value_arg):
	_GDP += value_arg
	
func get_GDP():
	return _GDP
	
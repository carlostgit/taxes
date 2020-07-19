extends "res://KinematicBody2D_slacker.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
var _tax_rate_worker = 0.25

export (NodePath) var _government

const MyNode2D_moneyResource = preload("res://Node2D_Coin.tscn")



func hit_money(var value_arg, var origin_arg, var destiny_arg):
	var taxes = self._tax_rate_worker*value_arg
	var money_after_taxes = value_arg-taxes
	
	add_money(value_arg)
	
	self.call_deferred("pay_taxes",taxes)
	
	#var current_money = get_money()
	if (money_after_taxes>0):
		var shop_node = self.get_node(_shop_path)
		self.call_deferred("send_money",money_after_taxes,shop_node)

	

func pay_taxes(var amount_arg):
	if (amount_arg!=0):
		var coin_gov = MyNode2D_moneyResource.instance()
		self.get_parent().add_child(coin_gov)
		coin_gov.set_origin_destiny(self,get_node(_government))
		coin_gov.set_value(amount_arg)
		add_money(-amount_arg)		

func set_corporate_tax_rate(var rate):
	_tax_rate_worker = rate;
extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var _corporate_tax_rate = 0.25
export (float) var _value_added_tax = 0.6
export (bool) var _tax_labour_only = true

var _GDP = 0.0

const MyNode2D_CoinResource = preload("res://Node2D_Coin.tscn")
const MyArea2D_oreResource = preload("res://Area2D_ore.tscn")
const MyArea2D_candyResource = preload("res://Area2D_candy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Worker.set_corporate_tax_rate(_corporate_tax_rate)
	if(self._tax_labour_only):
		$Slacker.set_corporate_tax_rate(0.0)
	else:
		$Slacker.set_corporate_tax_rate(_corporate_tax_rate)
		
	$Shop.set_value_added_tax_rate(_value_added_tax)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_GDP = $Worker.get_GDP()
	
	$Control_info.set_GDP(_GDP)
	var revenue = $Government.get_revenue()
	$Control_info.set_revenue(revenue)
#		
func _on_Area2D_mine_body_entered(body):
#	print ("Body entered. Body name")
#	if body == $Slacker:
#		print ("slacker")
#	if body == $Worker:
#		print ("worker")
	pass	

func reset():
	self.get_tree().reload_current_scene()
	
func set_corporate_tax(var corp_tax_arg):
	_corporate_tax_rate=corp_tax_arg
	$Worker.set_corporate_tax_rate(corp_tax_arg)
	if(self._tax_labour_only):
		$Slacker.set_corporate_tax_rate(0.0)
	else:
		$Sacker.set_corporate_tax_rate(corp_tax_arg)	

func set_tax_labour_only(var tax_labour_only_arg):
	self._tax_labour_only = tax_labour_only_arg
	if(self._tax_labour_only):
		$Slacker.set_corporate_tax_rate(0.0)
	else:
		$Slacker.set_corporate_tax_rate(self._corporate_tax_rate)	

func set_VAT(var VAT_arg):
	_value_added_tax=VAT_arg

	$Shop.set_value_added_tax_rate(_value_added_tax)

func _on_Button_pay_taxes_pressed():
	pass # Replace with function body.

func set_automatic_mode(var automatic_mode_arg):
	$Slacker.set_automatic_mode(automatic_mode_arg)
	$Worker.set_automatic_mode(automatic_mode_arg)
	$Shop.set_automatic_mode(automatic_mode_arg)
	
func get_GDP():
	return _GDP
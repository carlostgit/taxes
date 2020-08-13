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
	
#	$Label_corporate_tax_rate.set_text(str(_corporate_tax_rate))
	$KinematicBody2D_worker.set_corporate_tax_rate(_corporate_tax_rate)
	if(self._tax_labour_only):
		$KinematicBody2D_slacker.set_corporate_tax_rate(0.0)
	else:
		$KinematicBody2D_slacker.set_corporate_tax_rate(_corporate_tax_rate)
		
#	$Label_value_added_tax_rate.set_text(str(_value_added_tax))
	$StaticBody2D_shop.set_value_added_tax_rate(_value_added_tax)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
	_GDP = $KinematicBody2D_worker.get_GDP()
	
	$Control_info.set_GDP(_GDP)
	var revenue = $StaticBody2D_government.get_revenue()
	$Control_info.set_revenue(revenue)
#		
func _on_Area2D_mine_body_entered(body):
#	print ("Body entered. Body name")
#	if body == $KinematicBody2D_slacker:
#		print ("slacker")
#	if body == $KinematicBody2D_worker:
#		print ("worker")
	pass	



#
#func _on_Button_pressed():
#	var corp_tax=float($LineEdit.get_text())
#	self.get_tree().reload_current_scene()
#	_corporate_tax_rate=corp_tax
#	yield(get_tree().create_timer(0.5), "timeout")
#	$Label_corporate_tax_rate.set_text(str(corp_tax))
#	pass # Replace with function body.
func reset():
	self.get_tree().reload_current_scene()
	
func set_corporate_tax(var corp_tax_arg):
	_corporate_tax_rate=corp_tax_arg
#	$Label_corporate_tax_rate.set_text(str(corp_tax_arg))
	$KinematicBody2D_worker.set_corporate_tax_rate(corp_tax_arg)
	if(self._tax_labour_only):
		$KinematicBody2D_slacker.set_corporate_tax_rate(0.0)
	else:
		$KinematicBody2D_slacker.set_corporate_tax_rate(corp_tax_arg)	

func set_tax_labour_only(var tax_labour_only_arg):
	self._tax_labour_only = tax_labour_only_arg
	if(self._tax_labour_only):
		$KinematicBody2D_slacker.set_corporate_tax_rate(0.0)
	else:
		$KinematicBody2D_slacker.set_corporate_tax_rate(self._corporate_tax_rate)	


func set_VAT(var VAT_arg):
	_value_added_tax=VAT_arg

#	$Label_value_added_tax_rate.set_text(str(_value_added_tax))
	$StaticBody2D_shop.set_value_added_tax_rate(_value_added_tax)


func _on_Button_pay_taxes_pressed():
	pass # Replace with function body.

func set_automatic_mode(var automatic_mode_arg):
	$KinematicBody2D_slacker.set_automatic_mode(automatic_mode_arg)
	$KinematicBody2D_worker.set_automatic_mode(automatic_mode_arg)
	$StaticBody2D_shop.set_automatic_mode(automatic_mode_arg)
	
func get_GDP():
	return _GDP
	
	
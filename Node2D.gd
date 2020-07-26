extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (float) var _corporate_tax_rate = 0.25
export (float) var _value_added_tax = 0.6

const MyNode2D_CoinResource = preload("res://Node2D_Coin.tscn")
const MyArea2D_oreResource = preload("res://Area2D_ore.tscn")
const MyArea2D_candyResource = preload("res://Area2D_candy.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Label_corporate_tax_rate.set_text(str(_corporate_tax_rate))
	$KinematicBody2D_worker.set_corporate_tax_rate(_corporate_tax_rate)
	
	$Label_value_added_tax_rate.set_text(str(_value_added_tax))
	$StaticBody2D_shop.set_value_added_tax_rate(_value_added_tax)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _process(delta):
#	if Input.is_action_pressed("ui_right"):
#		$AnimationPlayer_worker.play("Walk")
#	else:
#		$AnimationPlayer_worker.stop()
		

#	if Input.is_action_just_pressed("ui_left"):
#		$KinematicBody2D_worker.send_money(1.0,$StaticBody2D_shop)
#		
#	if Input.is_action_just_pressed("ui_down"):
#		var ore = MyArea2D_oreResource.instance()
#		add_child(ore)
#		ore.set_origin_destiny($Area2D_mine,$KinematicBody2D_worker)
#		ore.set_value(1.0)
#
#	if Input.is_action_just_pressed("ui_right"):
#		self.get_tree().reload_current_scene()

		
#		$KinematicBody2D_worker.send_ore(1.0,$StaticBody2D_shop)
	pass	
		
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
	$Label_corporate_tax_rate.set_text(str(corp_tax_arg))


func set_VAT(var VAT_arg):
	_value_added_tax=VAT_arg
	$Label_value_added_tax_rate.set_text(str(VAT_arg))
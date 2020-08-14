extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const _main_scene_res = preload("res://Node2D.tscn")

export (bool) var _automatic_mode = false
export (bool) var _tax_labour_only = true

# Called when the node enters the scene tree for the first time.
func _ready():
	set_main_scene_parameters()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_Button_pressed():
#	pass

func get_main_scene():
	for node in self.get_children():
		if(node.is_in_group("main_scene_group")):
			return node
			
	if ($Node2D):
		return $Node2D
	
	print("main_scene not found in get_main_scene()")
	return null		
	

func _on_Button_reset_pressed():
	
	
#	Delete and create main node	
#	$Node2D.reset()
	for node in self.get_children():
		if(node.is_in_group("main_scene_group")):
			node.queue_free()
	if ($Node2D):
		$Node2D.queue_free()
	var new_main_scene = _main_scene_res.instance()

	self.add_child(new_main_scene)
	new_main_scene.add_to_group("main_scene_group")

	set_main_scene_parameters()
	
func set_main_scene_parameters():
#	Configuration parameters	
	var corp_tax_text_percentage = $SpinBox_corp_tax.get_line_edit().get_text()
	var corp_tax_value = float(corp_tax_text_percentage)/100
#	var VAT_text = $LineEdit_VAT.get_text()
	var VAT_text_percentage = $SpinBox_VAT.get_line_edit().get_text()
	var VAT_value = float(VAT_text_percentage)/100
	
	if(get_main_scene()):
		get_main_scene().set_corporate_tax(corp_tax_value)
		get_main_scene().set_VAT(VAT_value)
		get_main_scene().set_automatic_mode(_automatic_mode)
		get_main_scene().set_tax_labour_only(_tax_labour_only)


func _on_Button_pause_pressed():
	
	if (get_tree().paused):
		get_tree().paused = false;
	else:
		get_tree().paused = true;
	
	pass # Replace with function body.


func _on_CheckButton_automatic_mode_toggled(button_pressed):
	_automatic_mode = button_pressed
	if(get_main_scene()):
		get_main_scene().set_automatic_mode(_automatic_mode)
	

	

func _on_SpinBox_VAT_value_changed(value):
	if(get_main_scene()):
		var VAT_text_percentage = value
		var VAT_value = float(VAT_text_percentage)/100
		get_main_scene().set_VAT(VAT_value)

func _on_SpinBox_corp_tax_value_changed(value):
	if(get_main_scene()):
		var corp_tax_text_percentage = value
		var corp_tax_value = float(corp_tax_text_percentage)/100
		get_main_scene().set_corporate_tax(corp_tax_value)
		


func _on_CheckButton_tax_labour_only_toggled(button_pressed):
	_tax_labour_only = button_pressed
	if(get_main_scene()):
		get_main_scene().set_tax_labour_only(_tax_labour_only)

	
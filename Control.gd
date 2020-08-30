extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const _main_scene_res = preload("res://Node2D.tscn")

export (bool) var _automatic_mode = false
export (bool) var _tax_labour_only = true

# Called when the node enters the scene tree for the first time.
func _ready():
	var screenSize = get_viewport().get_visible_rect().size
#	print(screenSize)
#	$Panel.set_size(screenSize)
	$Panel/Label_reso.set_text(str(screenSize))
	
	set_main_scene_parameters()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_Button_pressed():
#	pass

func get_main_scene():
	for node in $Panel/ScrollContainer/Panel.get_children():
		if(node.is_in_group("main_scene_group")):
			return node
			
	if ($Panel/ScrollContainer/Panel/Node2D):
		return $Panel/ScrollContainer/Panel/Node2D
	
	print("main_scene not found in get_main_scene()")
	return null

func _on_Button_reset_pressed():
	
	
	for node in $Panel/ScrollContainer/Panel.get_children():
		if(node.is_in_group("main_scene_group")):
			node.remove_from_group("main_scene_group")
			node.queue_free()
			
	if ($Panel/ScrollContainer/Panel/Node2D):
		$Panel/ScrollContainer/Panel/Node2D.remove_from_group("main_scene_group")
		$Panel/ScrollContainer/Panel/Node2D.queue_free()
	var new_main_scene = _main_scene_res.instance()

	$Panel/ScrollContainer/Panel.add_child(new_main_scene)
#	self.add_child(new_main_scene)
	new_main_scene.add_to_group("main_scene_group")

	call_deferred("set_main_scene_parameters")
	
func set_main_scene_parameters():
#	Configuration parameters	
	var corp_tax_text_percentage = $Panel/SpinBox_corp_tax.get_line_edit().get_text()
	var corp_tax_value = float(corp_tax_text_percentage)/100
#	var VAT_text = $LineEdit_VAT.get_text()
	var VAT_text_percentage = $Panel/SpinBox_VAT.get_line_edit().get_text()
	var VAT_value = float(VAT_text_percentage)/100
	
	if(get_main_scene()):
		get_main_scene().set_corporate_tax(corp_tax_value)
		get_main_scene().set_VAT(VAT_value)
		get_main_scene().set_automatic_mode(_automatic_mode)
		get_main_scene().set_tax_labour_only(_tax_labour_only)


func _on_Button_pause_pressed():
	
	if (get_tree().paused):
		get_tree().paused = false;
		$Panel/Button_pause/Label_paused.hide()
	else:
		get_tree().paused = true;
		$Panel/Button_pause/Label_paused.show()
	
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

#func _on_CheckButton_tax_labour_only_toggled(button_pressed):
#	_tax_labour_only = button_pressed
#	if(get_main_scene()):
#		get_main_scene().set_tax_labour_only(_tax_labour_only)


func _on_CheckButton_tax_subsidies_too_toggled(button_pressed):
	if (button_pressed):
		_tax_labour_only = false
	else:
		_tax_labour_only = true
	if(get_main_scene()):
		get_main_scene().set_tax_labour_only(_tax_labour_only)

func _gui_input(event):
	if ($CheckButton_show_debug_log.is_pressed()):
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT and event.pressed:
				print("I've been clicked D:")
				
		if event is InputEventMagnifyGesture:
			var factor = event.get_factor()
			print("Magnifying: "+str(factor))
		
		$CheckButton_show_debug_log/ItemList_log.add_item(event.as_text())
		$CheckButton_show_debug_log/ItemList_log.select($CheckButton_show_debug_log/ItemList_log.get_item_count()-1)
		$CheckButton_show_debug_log/ItemList_log.ensure_current_is_visible()
		

func _on_CheckButton_show_debug_log_toggled(button_pressed):
	if (button_pressed==false):
		$CheckButton_show_debug_log/ItemList_log.hide()
		$CheckButton_show_debug_log/ItemList_log.clear()
	else:
		$CheckButton_show_debug_log/ItemList_log.show()
	pass # Replace with function body.

extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const _main_scene_res = preload("res://Node2D.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


#func _on_Button_pressed():
#	pass


func _on_Button_reset_pressed():
	
	
#	Delete and create main node	
#	$Node2D.reset()
	for node in self.get_children():
		if(node.is_in_group("main_scene_group")):
			node.queue_free()
	if ($Node2D):
		$Node2D.queue_free()
	var new_main_scene = _main_scene_res.instance()

#	Configuration parameters	
	var corp_tax_text = $LineEdit_corp_tax.get_text()
	var corp_tax_value = float(corp_tax_text)
	var VAT_text = $LineEdit_VAT.get_text()
	var VAT_value = float(VAT_text)
	
	new_main_scene.set_corporate_tax(corp_tax_value)
	new_main_scene.set_VAT(VAT_value)
	self.add_child(new_main_scene)
	new_main_scene.add_to_group("main_scene_group")

	pass # Replace with function body.

func _on_Button_pause_pressed():
	
	if (get_tree().paused):
		get_tree().paused = false;
	else:
		get_tree().paused = true;
	
	pass # Replace with function body.

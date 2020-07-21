extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const main_scene_res = preload("res://Node2D.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	var corp_tax_text = $LineEdit.get_text()
	var corp_tax_value = float(corp_tax_text)
#	$Node2D.reset()
	for node in self.get_children():
		if(node.is_in_group("main_scene_group")):
			node.queue_free()
	if ($Node2D):
		$Node2D.queue_free()
	var new_main_scene = main_scene_res.instance()
	self.add_child(new_main_scene)
	new_main_scene.add_to_group("main_scene_group")
	new_main_scene.set_corporate_tax(corp_tax_value)
	pass # Replace with function body.

extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(get_GDP()>0):
		var tax_pressure_rate = get_revenue()/get_GDP()
		var tax_pressure_rate_percentage = tax_pressure_rate*100
		var tax_pressure_rate_percentage_round = stepify(tax_pressure_rate_percentage,0.1)
		$Label_revenue_per_GDP.set_text(str(tax_pressure_rate_percentage_round))

func set_GDP(var value_arg):
	var valure_rounded = stepify(value_arg,0.01)
	$Label_GDP.set_text(str(valure_rounded))

func get_GDP():
	var GDP_text = $Label_GDP.get_text()
	var GDP_value = float(GDP_text)
	return GDP_value

func set_revenue(var value_arg):
	var value_arg_rounded = stepify(value_arg, 0.01)
	$Label_revenue.set_text(str(value_arg_rounded))

func get_revenue():
	var revenue_text = $Label_revenue.get_text()
	var revenue_value = float(revenue_text)
	return revenue_value

extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _origin:Node2D = null
var _destiny:Node2D = null
var _amount:float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(_origin!=null):
		var current_pos:Vector2 = self.get_position()
		var param_speed = 100.0
		var destiny_pos = _destiny.get_position()
		var advance = param_speed*current_pos.direction_to(destiny_pos).normalized()*delta
		self.set_position(current_pos+advance)

func _on_Timer_Coin_timeout():
	pass

func set_origin_destiny(var origin_arg, var destiny_arg):
	_origin = origin_arg
	_destiny = destiny_arg
	var origin_pos = _origin.get_position()
	self.set_position(origin_pos)
	$Timer_Coin.start()
	$Timer_Coin.connect("timeout",self,"_on_Timer_Coin_timeout")
	$AnimationPlayer_Coin.play("rotate")
	pass

func get_value():
	return self._amount

func set_value(var value_arg):
	var value_rounded = stepify(value_arg, 0.01)
	$Label.set_text(str(value_rounded))
	self._amount = value_arg

func _on_Area2D_body_entered(body):
	if (body==_destiny):
		body.hit_money(get_value(),_origin,_destiny)
		self.queue_free()

extends CanvasLayer


var default_layer := -2
var shake_layer := 2
func _ready():
		layer = default_layer
		assert(signals.connect("shake_started",self,"_on_shake_started")==OK)
		assert(signals.connect("shake_finished",self,"_on_shake_finished")==OK)

func _on_shake_started():
		layer = shake_layer
		
func _on_shake_finished():
		layer = default_layer

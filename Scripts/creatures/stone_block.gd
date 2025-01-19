extends Persistent
onready var animation_player = $AnimationPlayer

var shakes := 0
# Called when the node enters the scene tree for the first time.
func _ready():
		assert(signals.connect("shake_started",self,"_on_shake")==OK)
		
func _on_shake():
		shakes += 1
		print(shakes)
		if shakes == 1:
				animation_player.play("drop1")
		elif shakes == 2:
				print("play drop")
				animation_player.play("drop2")

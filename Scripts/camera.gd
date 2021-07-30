extends Camera2D


onready var shake_timer = $timer
onready var tween = $tween

export var shake_duration: float = 0
export var shake_strenght: int = 0


func _ready():
	set_process(false)


func _process(delta):
	# Causes Shaking
	offset = Vector2(rand_range(-shake_strenght, shake_strenght), rand_range(shake_strenght, -shake_strenght)) * delta


func shake():
	# Starts Shaking
	shake_timer.wait_time = shake_duration
	
	tween.stop_all()
	set_process(true)
	shake_timer.start()


func _on_timer_timeout():
	# Stops Shaking
	set_process(false)
	tween.interpolate_property(self, "offset", offset, Vector2(0,0), 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

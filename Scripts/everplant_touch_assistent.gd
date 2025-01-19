extends Control

export var input_left: String = "walk_left"
export var input_right: String = "walk_right"
export var input_up: String = "jump"

onready var input_start: Position2D = $input_start
onready var input_end: CPUParticles2D = $input_end


func _ready():
	set_process(false)


func _input(event):
		if event is InputEventScreenTouch:
				if event.pressed:
						input_start.position = get_local_mouse_position()
						set_process(true)
				else:
						input_end.emitting = false
						Input.action_release(input_left)
						Input.action_release(input_right)
						Input.action_release(input_up)
						
						if event.position.distance_to(input_start.position) < 20:
								print("simulate enter")
								Input.action_press("enter")
								signals.emit_signal("touch_enter")


						set_process(false)


func _process(_delta):
		input_end.position = get_local_mouse_position()
		
		if not input_end.emitting and abs(input_start.position.distance_to(input_end.position)) > 20:
				input_end.emitting = true

		if input_end.emitting:
				var distance: Vector2 = Vector2(0,0)
				distance.x = input_end.position.x - input_start.position.x #- 50
				distance.y = input_end.position.y - input_start.position.y #- 50
				
				if distance.x > 0 and 2*abs(distance.x) > abs(distance.y):
						Input.action_press(input_right)
				else:
						Input.action_release(input_right)
								
				if distance.x < 0 and 2*abs(distance.x) > abs(distance.y):
						Input.action_press(input_left)
				else:
						Input.action_release(input_left)

				if distance.y < 0 and 2*abs(distance.y) > abs(distance.x):
						Input.action_press(input_up)
				else:
						Input.action_release(input_up)

extends Control

export var input_left: String = "walk_left"
export var input_right: String = "walk_right"
export var input_up: String = "jump"

export var climb_up: String = "climb_up"
export var climb_down: String = "climb_down"

onready var input_start: Position2D = $input_start
onready var input_end: CPUParticles2D = $input_end

var freeze: bool = false

func _ready():
		set_process(false)
		assert(signals.connect("pause_mode_changed_to",self,"_on_pause_mode_changed") == OK)


func _input(event):
		if freeze:
			return
			
		if event is InputEventScreenTouch:
				if event.pressed:
						input_start.position = get_local_mouse_position()
						set_process(true)
				else:
						input_end.emitting = false
						Input.action_release(input_left)
						Input.action_release(input_right)
						Input.action_release(input_up)
						Input.action_release(climb_up)
						Input.action_release(climb_down)
						
						if event.position.distance_to(input_start.position) < 20:
								signals.emit_signal("open_inventory_on_touch")

						set_process(false)


func _process(_delta):
		if freeze:
			return
			
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
						Input.action_press(climb_up)
				else:
						Input.action_release(input_up)
						Input.action_release(climb_up)
				
				if distance.y > 0 and 2*abs(distance.y) > abs(distance.x):
						Input.action_press(climb_down)
				else:
						Input.action_release(climb_down)


func _on_pause_mode_changed(new_pause_mode: bool):
	$touchCoffee.paused = new_pause_mode
	
	if new_pause_mode == true:
		return
		
	freeze = true
	simulate_mouse_click()
	yield(get_tree().create_timer(0.1), "timeout")
	freeze = false


func simulate_mouse_click():
	var event = InputEventMouseButton.new()
	event.position = paths.player.position
	event.button_index = BUTTON_LEFT
	event.pressed = true
	Input.parse_input_event(event)
	
	yield(get_tree().create_timer(0.1), "timeout")
	
	event.pressed = false
	Input.parse_input_event(event)

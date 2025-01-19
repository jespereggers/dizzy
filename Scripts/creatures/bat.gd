extends Persistent

export var wait_times := [0.5,2.5]
export var speed := 5.0
export var initial_unit_offset := 0.3

onready var timer := 0.0
onready var routes := [$Path1/Follow,$Path2/Follow,$Path3/Follow]
onready var bat_bodies = [$Path1/Follow/BatBody,$Path2/Follow/BatBody,$Path3/Follow/BatBody]

#onready var current_route:PathFollow2D = routes[0]
#onready var next_route:PathFollow2D = routes[0]

onready var current_route := 0
onready var next_route := 0

onready var reverse_dir := false

func start_flight():
		bat_bodies[current_route].visible = false
		bat_bodies[current_route].get_node("death_area/shape_of_death").disabled = true
		current_route = next_route
		bat_bodies[current_route].visible = true
		bat_bodies[current_route].get_node("death_area/shape_of_death").disabled = false
		bat_bodies[current_route].get_node("AnimatedSprite").play("flying")
		if reverse_dir:
			routes[current_route].unit_offset = 1.0
			speed = - abs(speed)
		else:
			routes[current_route].unit_offset = 0.0
			speed = abs(speed)

func land():
		bat_bodies[current_route].get_node("AnimatedSprite").play("idle")
		timer = wait_times[tools.rng.randi()%wait_times.size()]

enum RestingPos{
	LEFT,
	MIDDLE,
	RIGHT
		}

func choose_next_route():
		var resting_pos:int
		match current_route:
			0:
					if reverse_dir:
						resting_pos = RestingPos.LEFT
					else:
						resting_pos = RestingPos.MIDDLE
			1:
					if reverse_dir:
						resting_pos = RestingPos.LEFT
					else:
						resting_pos = RestingPos.RIGHT
			2:
					if reverse_dir:
						resting_pos = RestingPos.MIDDLE
					else:
						resting_pos = RestingPos.RIGHT
			var error: push_error("unknown route index")
		var value:int = tools.rng.randi()%2
		match resting_pos:
			RestingPos.LEFT:
					reverse_dir = false
					if value:
						next_route = 0
					else:
						next_route = 1
			RestingPos.MIDDLE:
					if value:
						next_route = 0
						reverse_dir = true
					else:
						next_route = 2
						reverse_dir = false
			RestingPos.RIGHT:
					reverse_dir = true
					if value:
						next_route = 1
					else:
						next_route = 2
			var error: push_error("unknown resting pos")

func _ready():
		#start_flight()
		routes[current_route].unit_offset = initial_unit_offset

func _physics_process(delta):
	if timer > 0.0:
		timer -= delta
		if timer <= 0.0:
			start_flight()
	else:#if bat_bodies[current_route].get_node("AnimatedSprite").animation == "flying":
		routes[current_route].offset = routes[current_route].offset + speed * delta
		if routes[current_route].unit_offset == 1.0 or routes[current_route].unit_offset == 0.0: 
			land()
			choose_next_route()


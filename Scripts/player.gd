class_name Player
extends Area2D

onready var animations: AnimationPlayer = $animations
onready var texture: Sprite = $texture
onready var item_detector: Area2D = $item_detector

onready var ceiling_sensor: Sensor = $CeilingSensor
onready var floor_sensor: Sensor = $FloorSensor
onready var wall_sensor_right: Sensor = $WallSensorRight
onready var wall_sensor_left: Sensor = $WallSensorLeft
onready var terrain_sensor: Sensor = $TerrainSensor

var state_machine: PlayerStateMachine

var animation_data := {
	"idle": [0,1],
	"salto": [8,15],
	"walk": [16,23],
	"jump": [24,31],
	"climb": [32,35]
}

var animation_first_frame: int
var animation_last_frame: int

var unlocked: bool = false
var action: Array = ["idle"]
var locked: bool = false

func _ready():
	yield(signals, "backend_is_ready")
	self.position = data.game_save.player.position

	if signals.connect("room_changed", self, "_on_room_changed") != OK:
		print("Error occured when trying to establish a connection")
	if signals.connect("player_died", self, "_on_player_died") != OK:
		print("Error occured when trying to establish a connection")
	if signals.connect("player_respawned", self, "_on_player_respawned") != OK:
		print("Error occured when trying to establish a connection")

	state_machine = PlayerStateMachine.new(self)

func _physics_process(_delta):
	if not locked:
		state_machine.update()

# Dizzy Animation
func change_animation(name:String):
	if not animation_data.has(name):
		push_error("No animation named " + name)
	if animation_first_frame == animation_data[name][0]:
		return
	animation_first_frame = animation_data[name][0] 
	texture.frame = animation_first_frame
	animation_last_frame = animation_data[name][1]

func advance_animation():
	texture.frame += 1
	if texture.frame > animation_last_frame:
		texture.frame = animation_first_frame

# Dizzy Movement
func is_inside_terrain() -> bool:
	if terrain_sensor.is_colliding():
		return true
	return false

func is_on_floor() -> bool:
	return floor_sensor.zero_distance() or is_inside_terrain()

func is_next_to_wall(dir:int, step_size:int) -> bool:
	match dir:
		-1:
			return wall_sensor_left.get_distance() < step_size
		1:
			return wall_sensor_right.get_distance() < step_size
		0:
			return false
		var val: 
			print("unknown direction: " + str(val))
	return false

func get_distance_to_ceiling() -> float:
	if is_inside_terrain():
		return 0.0
	return ceiling_sensor.get_distance()

func get_distance_to_floor() -> float:
	if is_inside_terrain():
		return 0.0
	return floor_sensor.get_distance()

#resembles behaviour of movement.gs
class PlayerStateMachine:
	const STEP_X_SIZE = 4
	const MAX_POWER = 7
	const INITIAL_JUMP_POWER = 7
	const INITIAL_FALL_POWER = 1

	var _player: Player
	var _power := 0 	#vertical speed, used for jumping and falling
	var _dir := 0 		# left: -1, front: 0, right: 1
	var _state 				# "idle", "walk", "jump", "fall"

	func _init(player):
		_player = player
		_enter_state("idle")

	func update():
		if ["idle","walk"].has(_state):
			_enter_key_state()
		_update_state()

		#check if dizzy should fall
		if ["idle","walk"].has(_state):
			if not _player.is_on_floor():
				_enter_state("fall")
				_power += 1
				_player.position.y += 1

		#fix collisions by rising Dizzy
		for i in 4:
			if _player.is_inside_terrain():
				_player.position.y -= 1
			else:
				break


	func _enter_key_state():
		_dir = 0
		if Input.is_action_pressed("walk_right"):
			_dir += 1
		if Input.is_action_pressed("walk_left"):
			_dir -= 1

		if Input.is_action_pressed("jump"):
			_enter_state("jump")
		elif _dir != 0:
			_enter_state("walk")
		else:
			_enter_state("idle")

		#update sprite orientation
		_player.texture.flip_h = (_dir == -1)

	func _enter_state(new_state:String):
		var _old_state = _state
		_state = new_state
		match(_state):
			"idle":
				_dir = 0
				_power = 0
				_player.change_animation("idle")
			"walk":
				_power = 0
				_player.change_animation("walk")
			"jump":
				_power = INITIAL_JUMP_POWER
				if _dir != 0:
					_player.change_animation("jump")
				else:
					_player.change_animation("salto")
			"fall":
				_power = INITIAL_FALL_POWER
				#do not change animation

	func _update_state():
		match _state:
			"walk","jump","fall":
				if not _player.is_next_to_wall(_dir,STEP_X_SIZE):
					_player.position.x += STEP_X_SIZE * _dir
				continue
			"walk","idle":
				_player.advance_animation()
			"jump":
				_player.position.y -= min(_power,_player.get_distance_to_ceiling())
				_power -= 1
				_player.advance_animation()
				if _power < 0: #jump ends
					if _player.is_on_floor():
						_enter_key_state()
					else:
						_enter_state("fall")
			"fall":
				var step_y = min(_power,_player.get_distance_to_floor())
				_player.position.y += step_y
				_player.advance_animation()
				if step_y < _power: #fall ends
					_enter_roll()
				else:
					_power +=1
					_power = min(_power,MAX_POWER)

	func _enter_roll():
		_power = 1
		if([_player.animation_data["jump"][0],_player.animation_data["salto"][0]].has(_player.animation_first_frame)): #only roll when jumping
			if _player.texture.frame != _player.animation_first_frame: #keep rolling until upright frame is reached
				return
		_enter_key_state()


func _on_player_respawned():
	locked = true
	state_machine._enter_state("idle")
	animations.play_backwards("death")
	yield(get_tree().create_timer(1.45), "timeout")
	animations.play("idle")
	$texture.show()
	$dizzy_death.hide()
	set_physics_process(true)
	locked = false


func _on_room_changed():
	set_physics_process(false)
	if state_machine._state in ["idle", "walk"] and not is_on_floor():
		self.position.y -= get_height()
	yield(get_tree().create_timer(0.2), "timeout")
	set_physics_process(true)


func _on_player_died(collision_object):
	audio.play("dead")
	# Play Death-animation
	set_physics_process(false)
	self.animations.play("death")
	yield(animations, "animation_finished")
	set_physics_process(true)

	paths.ui.death.start(collision_object)

func get_height() -> float:
	if $raycast.is_colliding():
		return self.position.distance_to($raycast.get_collision_point())
	return 99.99

func _on_unlocked_cooldown_timeout():
	unlocked = false

func _on_ticks_timeout():
	if is_on_floor() and not stats.current_room in data.game_save.visited_rooms:
		data.game_save.visited_rooms.append(stats.current_room)
		signals.emit_signal("new_room_touched")

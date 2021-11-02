class_name Player
extends Area2D

onready var animations: AnimationPlayer = $animations
onready var texture: Sprite = $texture
onready var item_detector: Area2D = $item_detector

onready var ceiling_sensor: Sensor = $CeilingSensor
onready var floor_sensor: Sensor = $FloorSensor
onready var wall_sensor_right: Sensor = $WallSensorRight
onready var wall_sensor_left: Sensor = $WallSensorLeft
onready var lower_terrain_sensor: Sensor = $LowerTerrainSensor
onready var upper_terrain_sensor: Sensor = $UpperTerrainSensor
onready var inner_ceiling_sensor: Sensor = $InnerCeilingSensor

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

const STUN_THRESHOLD = 2
const STEP_X_SIZE = 4
var stun_level := 0

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
		
	#unstuck dizzy after entering new room
	if is_inside_ceiling() and is_inside_floor():
		for i in 4:
			if is_inside_floor():
				position.y -= 2
			else:
				break

# Dizzy Animation
func change_animation(name:String):
	if not animation_data.has(name):
		push_error("No animation named " + name)
	if animation_first_frame == animation_data[name][0]:
		return
	animation_first_frame = animation_data[name][0] 
	animation_last_frame = animation_data[name][1]
	texture.frame = animation_first_frame

func advance_animation():
	texture.frame += 1
	if texture.frame > animation_last_frame: #loop
		texture.frame = animation_first_frame

# Dizzy Movement

func move_x(dir:int):
	if dir == 0:
		return
	if not is_next_to_wall(dir):
		position.x += STEP_X_SIZE * dir
		#fix collisions by rising Dizzy
		for i in 4:
			if is_inside_floor():
				position.y -= 2
			else:
				break

func is_stunned():
	return stun_level > 0

func is_inside_floor() -> bool:
	if lower_terrain_sensor.is_colliding():
		return true
	return false
	
func is_inside_ceiling() -> bool:
	if upper_terrain_sensor.is_colliding():
		return true
	return false

func is_on_floor() -> bool:
	return floor_sensor.zero_distance() or is_inside_floor()
	
func is_on_ceiling() -> bool:
	return ceiling_sensor.zero_distance() or is_inside_ceiling()

func is_next_to_wall(dir:int) -> bool:
	match dir:
		-1:
			return wall_sensor_left.is_colliding()
		1:
			return wall_sensor_right.is_colliding()
		0:
			return false
		var val: 
			print("unknown direction: " + str(val))
	return false

func get_distance_to_ceiling() -> float:
	if is_inside_ceiling():
		return inner_ceiling_sensor.get_distance()
	else:
		return ceiling_sensor.get_distance()

func get_distance_to_floor() -> float:
	if is_inside_floor():
		return 0.0
	return floor_sensor.get_distance()


class PlayerStateMachine:
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
		var new_state := _get_state_transition()
		if new_state:
			_enter_state(new_state)
		_update_state() 


	func _get_state_from_input():
		_dir = 0
		if Input.is_action_pressed("walk_right"):
			_dir += 1
		if Input.is_action_pressed("walk_left"):
			_dir -= 1

		if Input.is_action_pressed("jump"):
				return "jump"
		elif _dir != 0:
			return "walk"
		else:
			return "idle"

	func player_wants_to_keep_moving():
		match _dir:
			0: return false
			1: return Input.is_action_pressed("walk_right")
			-1: return Input.is_action_pressed("walk_left")

	func _get_state_transition() -> String:
		match _state:
			"idle","walk":
				if _player.is_on_floor():
					return _get_state_from_input()
				else:
					return("fall")
			"jump":
				if _jump_frame_counter == 8: #peak reached
					return "jump_fall"
			"jump_fall":
				if _player.is_on_floor() and _player.texture.frame == _player.animation_first_frame:
					return _get_state_from_input()
			"fall":
				if _player.is_on_floor():
					return _get_state_from_input()
		return ""
				
	func _enter_state(new_state:String):
		var old_state = _state
		_state = new_state
		match(_state):
			"idle":
				_player.change_animation("idle")
			"walk":
				_player.change_animation("walk")
			"jump":
				_jump_frame_counter = 0
				_player.stun_level = 0
				if _dir == 0:
					_player.change_animation("salto")
				else:
					_player.change_animation("jump")
			"jump_fall":
				pass
			"fall":
				_player.change_animation("walk")
	
	var _jump_frame_counter:int

	var _jump_moves := [-6,-4,-4,-4,-4,-4,-2,-2,2,2,4,4,4,4,4,6]
	const FALL_SPEED = 6
	
	func _update_state():
		_player.texture.flip_h = (_dir == -1)
		_player.advance_animation()
		match _state:
			"idle":
				pass
			"walk":
				_player.move_x(_dir)
			"jump":
				var step_y = _jump_moves[_jump_frame_counter]
				var distance_to_ceiling = _player.get_distance_to_ceiling()
				if abs(step_y) > distance_to_ceiling:
					step_y = - distance_to_ceiling
					_player.stun_level += 1
				_player.position.y += step_y
				continue
			"jump_fall":
				var step_y = _jump_moves[min(_jump_frame_counter,_jump_moves.size()-1)]
				if _player.is_stunned():
					_player.stun_level -= 1
				else:
					_player.position.y += min(step_y, _player.get_distance_to_floor())
				continue
			"jump","jump_fall":
				_player.move_x(_dir)
				if _player.is_on_floor():
					_player.stun_level = 0
				_jump_frame_counter += 1
			"fall":
				var step_y = min(FALL_SPEED,_player.get_distance_to_floor())
				_player.position.y += step_y
				if not _player.is_on_floor() or player_wants_to_keep_moving():
					_player.move_x(_dir)
					

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

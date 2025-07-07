class_name Player
extends Area2D

signal left_room

onready var animations: AnimationPlayer = $animations
onready var texture: Sprite = $texture
onready var dead_texture : Sprite = $dizzy_death
onready var respawn_texture : Sprite = $dizzy_respawn
onready var item_detector_shape: CollisionShape2D = $item_detector/shape
onready var interaction_detector: Area2D = $interaction_detector

onready var ceiling_sensor: Sensor = $CeilingSensor
onready var floor_sensor: Sensor = $FloorSensor
onready var wall_sensor_right: Sensor = $WallSensorRight
onready var wall_sensor_left: Sensor = $WallSensorLeft
onready var inner_wall_sensor_right: Sensor = $InnerWallSensorRight
onready var inner_wall_sensor_left: Sensor = $InnerWallSensorLeft
onready var lower_wall_sensor_right: Sensor = $LowerWallSensorRight
onready var lower_wall_sensor_left: Sensor = $LowerWallSensorLeft
onready var lower_terrain_sensor: Sensor = $LowerTerrainSensor
onready var center_terrain_sensor: Sensor = $CenterTerrainSensor
onready var upper_terrain_sensor: Sensor = $UpperTerrainSensor
onready var ladder_sensor = $LadderSensor

var state_machine: PlayerStateMachine


var animation_data := {
		"respawn_idle": [0,0],
		"idle": [0,1],
		"salto": [8,15],
		"walk": [16,23],
		"jump": [24,31],
		"climb": [32,35]
}

var animation_first_frame: int
var animation_last_frame: int
var walk_idle_shared_frame_counter := 0

const STEP_X_SIZE = 4
const STEP_Y_SIZE = 6
var stun_level := 0

var is_dead := false

#var respawn_position := Vector2(188,148)
#var respawn_room := Vector2(0,0)
#var possibly_unsafe_respawn_position := Vector2(188,149) # We do not immediately accept the new position, it could be dangerous.
#var possibly_unsafe_respawn_room := Vector2(0,0)

var script_locked:bool = false
var script_unlock_next_frame:bool = false
var pause_locked: bool = false
var paused: bool = false
var cause_of_death:String

func _ready():
		pause_mode = Node.PAUSE_MODE_PROCESS #resapwn and dying animations play when the world is paused
		assert(signals.connect("map_cleaned", self, "_on_map_cleaned") == OK)
		assert(signals.connect("map_loaded", self, "_on_map_loaded") == OK)
		state_machine = PlayerStateMachine.new(self)

const MAP_CHANGE_EXIT_BOTTOM = 176
const MAP_CHANGE_EXIT_TOP = 49
const MAP_CHANGE_ENTRY_BOTTOM = 163
const MAP_CHANGE_ENTRY_TOP = 49

const MAP_CHANGE_EXIT_LEFT = 20
const MAP_CHANGE_EXIT_RIGHT = 236
const MAP_CHANGE_ENTRY_LEFT = 20
const MAP_CHANGE_ENTRY_RIGHT = 236

func _physics_process(_delta):
		var old_position = position
		if script_unlock_next_frame and script_locked:
				script_unlock_next_frame = false
				script_locked = false
		elif not script_locked:
				script_unlock_next_frame = false
				if Input.is_action_just_pressed("pause"):
						if paused:
								pause_locked = false
						else:
								pause_locked = true
								paused = true
				if Input.is_action_just_pressed("resume"):
						pause_locked = false
						paused = false


				if not pause_locked:
						if not NoSpawnAreas.is_colliding($CollisionShape2D) and not stats.game_state.respawn_room == stats.game_state.current_room and not is_inside_floor():
								stats.game_state.respawn_position = position
								stats.game_state.respawn_room = stats.game_state.current_room
								signals.emit_signal("respawn_position_updated")
						state_machine.update()
						if not state_machine._state == "respawn_idle": # Dizzy should not die if he spawns inside a death_zone
								var death_check = DeathAreas.is_colliding($CollisionShape2D)
								if death_check.killed == true:
										_die(death_check.cause_of_death)
						if paused:
								pause_locked = true

				# Change room
				var new_room_dir := Vector2()
				var new_player_pos := position
				if position.x > MAP_CHANGE_EXIT_RIGHT:
						new_room_dir.x += 1
						new_player_pos.x = MAP_CHANGE_ENTRY_LEFT
				elif position.x < MAP_CHANGE_EXIT_LEFT:
						new_room_dir.x -= 1
						new_player_pos.x = MAP_CHANGE_ENTRY_RIGHT
				
				if position.y < MAP_CHANGE_EXIT_TOP:
						new_room_dir.y += 1
						new_player_pos.y = MAP_CHANGE_ENTRY_BOTTOM
				elif position.y > MAP_CHANGE_EXIT_BOTTOM:
						new_room_dir.y -= 1
						new_player_pos.y = MAP_CHANGE_ENTRY_TOP
				
				if new_room_dir:
						position = new_player_pos
						emit_signal("left_room",new_room_dir)
				
		if (position != old_position) and paused:
				print(position)

# Dizzy Animation
func change_animation(name:String):
		if not animation_data.has(name):
				push_error("No animation named " + name)
		if animation_first_frame == animation_data[name][0] and animation_last_frame == animation_data[name][1]: # This is the same animation
				return
		animation_first_frame = animation_data[name][0] 
		animation_last_frame = animation_data[name][1]
		texture.frame = animation_first_frame
		if name == "walk":
				texture.frame += walk_idle_shared_frame_counter % 8
		if name == "idle":
				texture.frame += walk_idle_shared_frame_counter % 2 #animation length

func advance_animation():
		texture.frame += 1
		walk_idle_shared_frame_counter += 1
		if texture.frame > animation_last_frame: #loop
				texture.frame = animation_first_frame

func set_animation_frame(frame:int):
		frame += animation_first_frame
		assert(frame <= animation_last_frame)
		texture.frame = frame

# Dizzy Movement
func move_x(dir:int):
		if dir == 0:
				return
		if position.y > 54:
				if not is_next_to_wall(dir) or center_terrain_sensor.is_colliding():
						position.x += STEP_X_SIZE * dir
		else:
				if not is_next_to_wall(dir) and not center_terrain_sensor.is_colliding(): # At <= 54 Dizzy is clipping into the highest row and moves upwards instead of to the side ...\o/
						position.x += STEP_X_SIZE * dir
func is_stunned():
		return stun_level > 0

func is_inside_floor() -> bool:
		if lower_terrain_sensor.is_colliding():
				return true
		return false
		
func is_inside_ceiling() -> bool:
		if upper_terrain_sensor.is_colliding() and position.y > 54: # At <= 54 Dizzy is clipping into the highest row of blocks and can enter the room above
				return true
		return false

func is_on_floor() -> bool:
		return floor_sensor.zero_distance() or is_inside_floor()
		
func is_on_ceiling() -> bool:
		return ceiling_sensor.zero_distance() or is_inside_ceiling()

func is_next_to_wall(dir:int) -> bool:
		match dir:
				-1:
						return wall_sensor_left.is_colliding() or inner_wall_sensor_left.is_colliding()
				1:
						return wall_sensor_right.is_colliding() or inner_wall_sensor_right.is_colliding()
				0:
						return false
				var val: 
						print("unknown direction: " + str(val))
		return false

func is_next_to_low_wall(dir:int) -> bool:
		match dir:
				-1:
						return lower_wall_sensor_left.is_colliding()
				1:
						return lower_wall_sensor_right.is_colliding()
				0:
						return false
				var val: 
						print("unknown direction: " + str(val))
		return false

func get_distance_to_ceiling() -> float:
		if is_inside_ceiling():
				return 0.0
		else:
				return ceiling_sensor.get_distance()

func get_distance_to_floor() -> float:
		if is_inside_floor():
				return 0.0
		return floor_sensor.get_distance()

func is_next_to_ladder():
		return ladder_sensor.is_next_to_ladder()

func is_above_ladder():
		return ladder_sensor.is_above_ladder()
								

class PlayerStateMachine:
		var chill_after_dialog = false

		var _player: Player
		
		var _jump_frame_counter:int
		var _jump_moves := [-6,-4,-4,-4,-4,-4,-2,-2,2,2,4,4,4,4,4,6]
		var _jump_corner_roll_final_raise = 0

		var _dir := 0 			# left: -1, front: 0, right: 1
		var _state := "respawn_idle"			# "idle", "walk", "jump", "jump_fall","jump_roll","fall", "
		var _jumped_through_floor

		var _climb_frame_counter := 0

		func _init(player):
				_player = player
				_enter_state("respawn_idle")

		func update():
				var new_state := _get_state_transition()
				if new_state:
						_enter_state(new_state)
				_update_state()
				#step up
				if not _state == "climb":
						for i in 8:
								if _player.is_inside_floor() and not _player.center_terrain_sensor.is_colliding():
										_player.position.y -= 1
								else:
										break

		func _get_state_from_input():
				_dir = 0
				if Input.is_action_pressed("walk_right"):
						_dir += 1
				if Input.is_action_pressed("walk_left"):
						_dir -= 1
				if _dir != 0:
						_player.texture.flip_h = (_dir == -1)
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
						"respawn_idle":
								# landing occurs during update_state(), calls _get_state_from_input()
								pass
						"idle":
								if (_player.is_above_ladder() and (Input.is_action_pressed("climb_down")) or 
											(_player.is_next_to_ladder() and Input.is_action_pressed("climb_up"))):
										return "climb"
								continue
						"idle","walk":
								if _player.is_on_floor():
										return _get_state_from_input()
								else:
										return("fall")
						"climb":
								if (int(_player.is_next_to_ladder()) ^  int(_player.is_above_ladder())):
										return "idle"
						"jump":
								if _jump_frame_counter == 8: #peak reached
										return "jump_fall"
						"jump_fall":
								# landing occurs during update_state(), transitions to "idle" or "jump_roll"
								pass
						"jump_roll":
								# landing occurs during update_state(), transitions to "idle"
								pass
						"fall":
								# landing occurs during update_state(), calls _get_state_from_input()
										pass
				return ""
		
		func _enter_state(new_state:String):
				_state = new_state
				match(_state):
						"respawn_idle":
								_player.script_locked = false
								_player.dead_texture.visible = false
								_player.respawn_texture.visible = false
								_player.texture.visible = true
								_player.is_dead = false
								_dir = 0
								_player.walk_idle_shared_frame_counter = 2
								_player.change_animation("respawn_idle")
								signals.emit_signal("player_respawned")
						"idle":
								_player.stun_level = 0
								_dir = 0
								_player.change_animation("idle")
						"walk":
								_player.change_animation("walk") #start with last frame
						"climb":
								_climb_frame_counter = 0
								_player.change_animation("climb")
						"jump":
								_jumped_through_floor = false
								_jump_frame_counter = 0
								_player.stun_level = 0
								if _dir == 0:
										_player.change_animation("salto")
								else:
										_player.change_animation("jump")
						"jump_fall","jump_roll":
								pass
						"fall":
								_player.change_animation("walk")

		func _update_state():
				if _dir != 0:
						_player.texture.flip_h = (_dir == -1)
				if not _state == "climb":
						_player.advance_animation()
				match _state:
						"respawn_idle":
								_player.position.y += STEP_Y_SIZE
								if _player.is_on_floor():
										_enter_state(_get_state_from_input())
										_player.move_x(_dir)
						"idle":
								pass
						"walk":
								_player.move_x(_dir)
						"jump":
								var step_y = _jump_moves[_jump_frame_counter]
								var distance_to_ceiling = _player.get_distance_to_ceiling()
								if abs(step_y) > distance_to_ceiling:
										step_y = - distance_to_ceiling
										_player.stun_level += 1     # Build up stun if moving upwards is blocked
								_player.position.y += step_y
								_player.move_x(_dir)
								_jump_frame_counter += 1
						"climb":
								var climb_dir = 0
								if Input.is_action_pressed("climb_up"):
										climb_dir = -1
								if Input.is_action_pressed("climb_down"):
										climb_dir = 1
								if climb_dir != 0:
										_player.position.y += climb_dir * 4
										_climb_frame_counter += 1
										if not _climb_frame_counter % 2:
												_player.advance_animation()
						"jump_fall":
								var step_y = _jump_moves[_jump_frame_counter]
								var distance_to_floor = _player.get_distance_to_floor()
								if _player.is_stunned():     # Use up stun before falling down
										_player.stun_level -= 1
								else:
										_player.position.y += min(step_y, distance_to_floor)
										if _player.is_on_floor() and (_player.is_next_to_wall(_dir) or _jumped_through_floor): # Bounce in corners and after jumping a room up through a floor
												_player.position.y -= step_y - distance_to_floor
								_jump_frame_counter += 1
								_player.move_x(_dir)
								
								if _jump_frame_counter >= _jump_moves.size() and _jump_frame_counter % 8 == 0: # End jump on standing frame
										if _player.is_on_floor() : #has_landed
												_enter_state("idle")
										elif _player.get_distance_to_floor() > 8:
												if(distance_to_floor == 0 and not _player.is_next_to_wall(_dir)): #had landed after vertical move, 
														_enter_state("idle")
												elif _player.is_next_to_low_wall(_dir) and not _player.is_next_to_wall(_dir):
														_enter_state("idle")
												else:
														_enter_state("jump_roll")
										else:  # distance <= 8:
												if _player.is_next_to_low_wall(_dir) and _player.is_next_to_wall(_dir):
														_enter_state("idle") # Switch to "idle" instead of "jump_roll" if very close to wall; see jump_close_to_wall.gif 
												else:
														_enter_state("jump_roll") # Roll over Treepot Room 5, Roll down stairs in rom 14
						"jump_roll":
								_player.position.y += min(_jump_moves.back(), _player.get_distance_to_floor())
								_player.move_x(_dir)
								if (_player.is_on_floor() or _player.is_next_to_low_wall(_dir)) and _player.texture.frame == _player.animation_first_frame:
										_enter_state("idle")
						"fall":
								var step_y = min(STEP_Y_SIZE,_player.get_distance_to_floor())
								_player.position.y += step_y
								if (not _player.is_on_floor() or player_wants_to_keep_moving()):# and not _player.is_next_to_wall(dir):
										_player.move_x(_dir)
								if _player.is_on_floor():
										return _enter_state(_get_state_from_input())

func _die(by: String):
		cause_of_death = by
#dying"
		script_locked = true
		script_unlock_next_frame = false
		is_dead = true#
		dead_texture.visible = true
		respawn_texture.visible = false
		texture.visible = false
		animations.play("death")
		animations.seek(0,true)
		signals.emit_signal("player_is_dying")
		dead_texture.visible = false
		yield(animations,"animation_finished")
#dead
		dead_texture.visible = false
		respawn_texture.visible = false
		texture.visible = false
		get_node("dizzy_death").visible = false
		signals.emit_signal("player_is_dead")

func _respawn():
		script_locked = true
		dead_texture.visible = false
		respawn_texture.visible = true
		texture.visible = false
		position = stats.game_state.respawn_position
		
		print("new room:")
		print(live.current_room)
		
		
#Move Dizzy so that he does not respawn behind the boundary, in room 10
		if stats.game_state.current_room == Vector2(1,0) and position.y == MAP_CHANGE_EXIT_TOP:
				position.y += 6
		animations.play("respawn")
		animations.seek(0,true)
		audio.play("theme")
		signals.emit_signal("player_is_respawning")
		yield(animations,"animation_finished")
		signals.emit_signal("player_is_respawning")
		state_machine._enter_state("respawn_idle")

func _on_map_loaded(): 
		if is_dead:
				pass
		else:
				script_locked = false
				visible = true
				if state_machine._state == "walk": #Emulator version skips a frame if walking offscreen
						advance_animation()
				state_machine._jumped_through_floor = (is_inside_floor() or floor_sensor.is_colliding()) and position.y == MAP_CHANGE_ENTRY_BOTTOM
				script_unlock_next_frame = true #wait until dizzy is drawn at the edge of screen before unlocking him

func _on_map_cleaned():
		script_locked = true
		visible = false

func get_height() -> float:
		if $raycast.is_colliding():
				return self.position.distance_to($raycast.get_collision_point())
		return 99.99

func get_detected_items() -> Array:
		var detected_items:Array = []
		for object in ItemCollision.get_colliding_items(item_detector_shape):
				assert(object is Item)
				detected_items.append(object)
		return detected_items
		
func get_detected_interactables() -> Array:
		return interaction_detector.interactables
		
func can_interact() -> bool:
			return is_on_floor() and state_machine._state == "idle" and not script_locked

func force_jump():
		state_machine._enter_state("jump")

func set_jump_frame_counter(n:int):
		state_machine._jump_frame_counter = n

func force_look_dir(dir,update_texture_flip = true):
		state_machine._dir = dir
		if update_texture_flip:
				texture.flip_h = (dir == -1)
		

func kill(msg: String):
	print(msg)

extends KinematicBody2D

onready var animations: AnimationPlayer = $animations
onready var texture: Sprite = $texture
onready var state_machine: Node = $state_machine
onready var collision: CollisionShape2D = $collision
onready var item_detector: Area2D = $item_detector

var motion: Vector2 = Vector2()
var unlocked: bool = false
var action: Array = ["idle"]
var locked: bool = false
var is_on_leaderbox: bool = false

const UP: Vector2 = Vector2(0, -1)
const GRAVITY: int  = 4
const MAXFALLSPEED: int = 35
const MAXSPEED: int = 40
const JUMPFORCE: int = 120
const ACCEL: int = 8


func _ready():
	yield(signals, "backend_is_ready")
	self.position = databank.game_save.player.position
	
	if signals.connect("room_changed", self, "_on_room_changed") != OK:
		print("Error occured when trying to establish a connection")
	if signals.connect("player_died", self, "_on_player_died") != OK:
		print("Error occured when trying to establish a connection")
	if signals.connect("player_respawned", self, "_on_player_respawned") != OK:
		print("Error occured when trying to establish a connection")


func _on_player_respawned():
	locked = true
	action = ["idle"]
	#self.position.y += get_height()
	animations.play_backwards("death")
	yield(get_tree().create_timer(1.45), "timeout")
	animations.play("idle")
	$texture.show()
	$dizzy_death.hide()
	set_physics_process(true)
	locked = false


func _on_room_changed():
	if animations.current_animation in ["idle", "walk"] and not is_on_floor():
		self.position.y -= get_height()


func _on_player_died(collision_object):
	audio.play("dead")
	# Play Death-animation
	set_physics_process(false)
	self.animations.play("death")
	yield(animations, "animation_finished")
	set_physics_process(true)

	paths.ui.death.start(collision_object)


func _physics_process(_delta):
	motion.y += GRAVITY
	
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)

	if is_on_leaderbox and "walk" in action and is_on_wall():
# warning-ignore:integer_division
		motion.y = -JUMPFORCE / 3
		
	if not locked or unlocked:
		if can_autojump():
# warning-ignore:integer_division
			motion.y = -JUMPFORCE / 2
			unlocked = true
			$unlocked_cooldown.start(1.0)

		if is_on_floor() or is_on_wall() or unlocked:
			action = []
				
			if Input.is_action_pressed("walk_left"):
				action = ["walk", "left"]
			elif Input.is_action_pressed("walk_right"):
				action = ["walk", "right"]
				
			if Input.is_action_pressed("jump"):
				if Input.is_action_pressed("walk_left"):
					action = ["jump", "left"]
				elif Input.is_action_pressed("walk_right"):
					action = ["jump", "right"]
				elif action != ["salto"]:
					Input.action_press("salto")
					action = ["salto"]
						
			elif Input.is_action_pressed("salto"):
				action = ["salto"]
				
			if action == []:
				action = ["idle"]
			
	if not is_on_wall():
		texture.flip_h = motion.x < 0
				
	state_machine.update_state(action[0])

	update_motion()

	motion = move_and_slide(motion, UP)


func update_motion():
	# action[0] -> action_name
	# action[1] -> action_direction
	
	match action[0]:
		"idle":
			motion.x = lerp(motion.x, 0, 0.2)
			
		"walk":
			if action[1] == "left":
				motion.x -= ACCEL
			else:
				motion.x += ACCEL
				
		"jump":
			if is_on_floor() and Input.is_action_pressed("jump"):
				motion.y = -JUMPFORCE
			if action[1] == "right":
				motion.x += ACCEL
			else:
				motion.x -= ACCEL
				
		"salto":
			if is_on_floor() and Input.is_action_pressed("salto"):
				motion.y = -JUMPFORCE
				Input.action_release("salto")
			motion.x = 0
			
		"climb":
			pass


func get_height() -> float:
	if $raycast.is_colliding():
		return self.position.distance_to($raycast.get_collision_point())
	return 99.99


func can_autojump() -> bool:
	if is_on_wall() and is_on_floor():
		if texture.flip_h:
			# Check autojump on left side
			if not $raycast_left_middle.is_colliding():
				return true
		else:
			# Check autojump on right side
			if not $raycast_right_middle.is_colliding():
				return true
	return false


func _on_unlocked_cooldown_timeout():
	unlocked = false


func _on_ticks_timeout():
	if is_on_floor() and not stats.current_room in databank.game_save.visited_rooms:
		databank.game_save.visited_rooms.append(stats.current_room)
		signals.emit_signal("new_room_touched")

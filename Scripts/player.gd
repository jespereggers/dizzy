extends KinematicBody2D

onready var animations: AnimationPlayer = $animations
onready var texture: Sprite = $texture
onready var state_machine: Node = $state_machine
onready var area: Area2D = $area

var motion: Vector2 = Vector2()
var unlocked: bool = false
var action: Array = ["idle"]
var locked: bool = false

const UP: Vector2 = Vector2(0, -1)
const GRAVITY: int  = 3
const MAXFALLSPEED: int = 35
const MAXSPEED: int = 40
const JUMPFORCE: int = 110
const ACCEL: int = 8


func _physics_process(delta):
	motion.y += GRAVITY
	
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	
	if not locked or unlocked:
		if can_autojump():
			motion.y = -JUMPFORCE / 2
			unlocked = true
			$unlocked_cooldown.start(1.0)

		if is_on_floor() or is_on_wall() or unlocked:
			action = []
				
			if Input.is_action_pressed("left"):
				action = ["walk", "left"]
			elif Input.is_action_pressed("right"):
				action = ["walk", "right"]
				
			if Input.is_action_pressed("jump"):
				if Input.is_action_pressed("left"):
					action = ["jump", "left"]
				elif Input.is_action_pressed("right"):
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
	update_motion(action)

	motion = move_and_slide(motion, UP)


func update_motion(action: Array):
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

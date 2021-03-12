extends KinematicBody2D

onready var animation: AnimatedSprite = $animation
var motion: Vector2 = Vector2()

const UP: Vector2 = Vector2(0, -1)
const GRAVITY: int  = 3
const MAXFALLSPEED: int = 40
const MAXSPEED: int = 30
const JUMPFORCE: int = 90
const ACCEL: int = 8


func _ready():
	yield(signals, "backend_is_ready")
	set_physics_process(true)
	animation.play("idle")


func _physics_process(delta):
	motion.y += GRAVITY
	
	if motion.y > MAXFALLSPEED:
		motion.y = MAXFALLSPEED
	
	motion.x = clamp(motion.x, -MAXSPEED, MAXSPEED)
	
	if Input.is_action_pressed("right"):
		motion.x += ACCEL
	elif Input.is_action_pressed("left"):
		motion.x -= ACCEL
	else:
		motion.x = lerp(motion.x, 0, 0.2)
			
	if Input.is_action_just_pressed("jump"):
		motion.y = -JUMPFORCE
		if Input.is_action_pressed("left"):
			motion.x += ACCEL
		if Input.is_action_pressed("right"):
			motion.x -= ACCEL
				
	elif Input.is_action_just_pressed("salto"):
		motion.y = -JUMPFORCE
		motion.x = 0
			
	animation.flip_h = motion.x < 0
	
	motion = move_and_slide(motion, UP)

func _input(event):
	$state_machine.update_state(motion)

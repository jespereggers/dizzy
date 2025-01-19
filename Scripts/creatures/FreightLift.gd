extends Persistent

var dir := 0

export var top_pos := 0
export var bottom_pos := 40;

onready var cannon_ball_item:PackedScene = preload("res://Scenes/items/item_heavy_cannonball.tscn")
onready var interaction_area:InteractionArea = $InteractionArea

func move_down():
		$CannonBallSprite.visible = true
		dir = 1
		interaction_area.queue_free()

func stop():
		dir = 0

func _physics_process(delta):
		if dir != 0:
				position.y += dir
				if position.y <= top_pos or position.y >= bottom_pos:
						stop()

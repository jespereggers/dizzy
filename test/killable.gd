extends Area2D


func _physics_process(delta):
		if Input.is_action_just_pressed("walk_right"):
				position += Vector2(4,0)
		if Input.is_action_just_pressed("walk_left"):
				position += Vector2(-4,0)
		if Input.is_action_just_pressed("ui_up"):
				position += Vector2(0,-4)
		if Input.is_action_just_pressed("ui_down"):
				position += Vector2(0,4)


func kill(who_did_it):
		print("I was killed")

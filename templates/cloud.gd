class_name Cloud
extends StaticBody2D

var frames_to_first_drop = 4
var frames_to_subsequent_drops = 8
var max_displacement = 7

var ray_cast :RayCast2D
var collision_shape : CollisionShape2D

var player_here_frame_counter := 0
var displacement := 0
var initial_pos_y : int

func _ready():
		initial_pos_y = int(position.y)
		#find collisionshape
		for child in get_children():
				if child is CollisionShape2D:
						collision_shape = child
						break
		assert(collision_shape)
		var shape:RectangleShape2D = collision_shape.shape
		assert(shape)
		#setup raycast
		ray_cast = RayCast2D.new()
		add_child(ray_cast)
		ray_cast.position.x = collision_shape.position.x - shape.extents[0]
		ray_cast.position.y = collision_shape.position.y - shape.extents[1] -1
		ray_cast.cast_to.x = shape.extents[0] * 2
		ray_cast.cast_to.y = 0
		
		ray_cast.collision_mask = 2 #player layer
		ray_cast.collide_with_bodies = false
		ray_cast.collide_with_areas = true
		ray_cast.enabled = true
		
func _physics_process(_delta):
		var player_is_here := ray_cast.is_colliding()
		if player_is_here:
				player_here_frame_counter += 1
		else:
				player_here_frame_counter = 0
		
		if player_is_here:
				if displacement == 0:
						if player_here_frame_counter == frames_to_first_drop:
								displacement = 1
								player_here_frame_counter = 0
				else:
						if player_here_frame_counter == frames_to_subsequent_drops:
								displacement += 1
								player_here_frame_counter = 0
				if displacement > max_displacement:
						displacement = 0    
						collision_shape.disabled = true
						yield(tools.create_physics_timer(0.5),"timeout")
						collision_shape.disabled = false
		else:
				displacement = 0
		position.y = initial_pos_y + displacement
	

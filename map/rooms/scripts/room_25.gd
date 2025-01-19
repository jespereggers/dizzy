extends Node2D

onready var collision_shape_2d = $Bridge/StaticBody2D/CollisionShape2D
onready var well_jump_start_height = $well_jump_start_height

# Called when the node enters the scene tree for the first time.
func _ready():
		if paths.player:
				print( paths.map.previous_room )
				if paths.player.position.y == paths.player.MAP_CHANGE_ENTRY_TOP and paths.map.previous_room == Vector2(-4,-2): #room 20
						paths.player.position.y = well_jump_start_height.global_position.y
						if paths.player.state_machine._dir == 0:
								paths.player.force_look_dir(0)
						paths.player.force_jump()

func _on_ActivateBridge_area_entered(area):
		if area is Player:
				collision_shape_2d.set_deferred("disabled", false)


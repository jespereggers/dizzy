class_name Sensor
extends Node2D

var raycasts := []

func _ready():
	for child in get_children():
		if child is RayCast2D:
			raycasts.append(child)
	

func _cast_ray(raycast: RayCast2D) -> float:
	raycast.force_raycast_update()
	if raycast.is_colliding():
		return (raycast.global_position - raycast.get_collision_point()).length()
	else:
		return INF

# returns shortest length of all children RayCast2D
func get_distance() -> float:
	var result = INF
	for raycast in raycasts:
		result = min(result, _cast_ray(raycast))
	return result

func is_colliding() -> bool:
	return get_distance() < INF

func zero_distance() -> bool:
	return get_distance() == 0

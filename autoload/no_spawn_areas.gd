extends Node

#Workoaround because Area2D collision detection does not work reliably when moving by setting position
# probably relateded:
#	 https://github.com/godotengine/godot/issues/53099
#  https://github.com/godotengine/godot/issues/54749
var _no_spawn_areas:Array

func new_no_spawn_area(area:NoSpawnArea):
		_no_spawn_areas.append(area)

func delete_no_spawn_area(area:Area2D):
		_no_spawn_areas.erase(area)

func is_colliding(shape_of_living):
		for area in _no_spawn_areas:
				if area.shape_of_no_spawn.shape.collide(area.shape_of_no_spawn.global_transform,shape_of_living.shape,shape_of_living.global_transform):
						return true
		return false

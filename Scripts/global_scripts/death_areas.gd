extends Node

#Workoaround because Area2D collision detection does not work reliably when moving by setting position
# probably relateded:
#	 https://github.com/godotengine/godot/issues/53099
#  https://github.com/godotengine/godot/issues/54749
var _death_areas:Array

func new_death_area(area:DeathArea):
	_death_areas.append(area)

func delete_death_area(area:Area2D):
	_death_areas.erase(area)

func is_colliding(shape_of_living):
	for area in _death_areas:
		if area.shape_of_death.shape.collide(area.shape_of_death.global_transform,shape_of_living.shape,shape_of_living.global_transform):
			return {"killed":true,"cause_of_death":area.cause_of_death}
	return {"killed":false,"cause_of_death":""}

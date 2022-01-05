extends Node

#Workoaround because Area2D collision detection does not work reliably when moving by setting position
# probably relateded:
#	 https://github.com/godotengine/godot/issues/53099
#  https://github.com/godotengine/godot/issues/54749
var _items:Array = []

func new_item(area:Item):
	_items.append(area)

func delete_item(item:Item):
	_items.erase(item)

func get_colliding_items(shape_of_detection):
	var colliding_items:= []
	for area in _items:
		if area.collision_shape.shape.collide(area.collision_shape.global_transform,shape_of_detection.shape,shape_of_detection.global_transform):
			colliding_items.append(area)
	return colliding_items

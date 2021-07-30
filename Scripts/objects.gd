extends Node2D

var unused_object_ids: Array

func _ready():
#	self.position += Vector2(8, 8)
	var untouched_room: bool = false
	
	if not stats.current_room in data.game_save.enviroment[stats.current_map]:
		untouched_room = true
		data.game_save.enviroment[stats.current_map][stats.current_room] = {"removed_objects": [], "objects": []}
	
	# Remove objects
	for object in get_children():
		if not object.name in data.game_save.enviroment[stats.current_map][stats.current_room].removed_objects and untouched_room and object.get("type"):
			# Generate untouched items
			if object.type in ["item", "coin", "shard"]:
				object.load_template()

			var new_id: String =  str(randi())
			unused_object_ids.append(new_id)
			object.id = new_id
			object.origin = object.name
			#object.position += Vector2(8, 49)
			var properties: Dictionary = tools.get_object_properties(object)
			data.game_save.enviroment[stats.current_map][stats.current_room].objects.append(properties)
		object.queue_free()

	#Add objects
	for properties in data.game_save.enviroment[stats.current_map][stats.current_room].objects:
		match properties.type:
			"item":
				var item: KinematicBody2D = load("res://templates/item.tscn").instance()
				item.set_properties(properties)
				item.load_template()
				if properties.id in unused_object_ids:
					item.used = false
					#item.update_pos()
				self.add_child(item)
			"coin":
				var coin: Sprite = load("res://templates/coin.tscn").instance()
				coin.set_properties(properties)
				self.add_child(coin)
			"shard":
				var shard: Sprite = load("res://templates/shard.tscn").instance()
				shard.set_properties(properties)
				self.add_child(shard)

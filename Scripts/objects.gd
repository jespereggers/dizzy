extends Node2D

var unused_object_ids: Array

func _ready():

	# Remove objects
	for object in get_children():
		match object.type:
			"item":
				object.load_template()
		var properties: Dictionary = tools.get_object_properties(object)
		if not properties.id in databank.game_save.enviroment[stats.current_map][stats.current_room].removed_objects and not properties.id in databank.game_save.enviroment[stats.current_map][stats.current_room].objects:
			var new_id: String =  str(randi())
			unused_object_ids.append(new_id)
			properties.id = new_id
			databank.game_save.enviroment[stats.current_map][stats.current_room].objects.append(properties)
		object.queue_free()
	
	#Add objects
	for properties in databank.game_save.enviroment[stats.current_map][stats.current_room].objects:
		if not properties.id in databank.game_save.enviroment[stats.current_map][stats.current_room].removed_objects:
			match properties.type:
				"item":
					print("ACCESS TO ", properties.id)
					var item: KinematicBody2D = load("res://templates/item.tscn").instance()
					item.set_properties(properties)
					item.load_template()
					if properties.id in unused_object_ids:
						item.used = false
					self.add_child(item)
				"coin":
					var coin: Sprite = load("res://templates/coin.tscn").instance()
					coin.set_properties(properties)
					self.add_child(coin)

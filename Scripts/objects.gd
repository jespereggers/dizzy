extends Node2D


func _ready():
	# Remove objects
	for object in get_children():
		object.load_template()
		var properties: Dictionary = tools.get_object_properties(object)
		if not properties.id in databank.game_save.enviroment[stats.current_map][stats.current_room].removed_objects:
			properties.id = str(randi())
			databank.game_save.enviroment[stats.current_map][stats.current_room].objects.append(properties)
		object.queue_free()
	
	#Add objects
	for properties in databank.game_save.enviroment[stats.current_map][stats.current_room].objects:
		match properties.type:
			"item":
				var item: KinematicBody2D = load("res://templates/item.tscn").instance()
				item.set_properties(properties)
				item.load_template()
				self.add_child(item)
			"coin":
				var coin: Sprite = load("res://templates/coin.tscn").instance()
				coin.set_properties(properties)
				self.add_child(coin)

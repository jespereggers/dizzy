extends Node2D


func _ready():
	var childs: Array
	# Create list of all child-names
	for item in get_children():
		childs.append(item.name)

	# Remove default items, if neccessary
	for object in get_children():
		object.load_preset()
		if object.name in databank.game_save.enviroment[stats.current_map][stats.current_room].removed_items:
			get_node(object.name).queue_free()

	# Add added_items
	for properties in databank.game_save.enviroment[stats.current_map][stats.current_room].added_items:
		var new_item: KinematicBody2D = load("res://templates/item.tscn").instance()
		new_item.load_template("collectable_item", properties.id, properties.item_name, properties.position, properties.height, properties.color, properties.collectable, properties.texture, properties.shape)
		new_item.unused = false
		self.add_child(new_item, true)

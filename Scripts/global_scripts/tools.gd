extends Node


func add_item_to_game_save(item):
	var properties: Dictionary = get_collectable_item_properties(item)
#	if not properties in databank.game_save.enviroment[stats.current_map][stats.current_room].added_items:
	databank.game_save.enviroment[stats.current_map][stats.current_room].added_items.append(properties)


func remove_item_from_game_save(item):
	var properties: Dictionary = get_collectable_item_properties(item)
	for added_item in databank.game_save.enviroment[stats.current_map][stats.current_room].added_items:
		if str(properties) == str(added_item):
			databank.game_save.enviroment[stats.current_map][stats.current_room].added_items.erase(added_item)


func load_file(path: String):
	path = path.replace("user://", OS.get_user_data_dir() + "/")

	if not File.new().file_exists(path):
		printerr("An unexpected error occured when trying to open " + path)
		return
		
	var file = File.new()
	file.open(path, File.READ)
	var content
	
	match path.split(".")[-1]:
		"txt":
			content = file.get_var(true)
		"json":
			content = JSON.parse(file.get_as_text()).result
		"dizzy":
			content = file.get_var(true)
	file.close()

	return content


func save_file(path: String, content):
	path = path.replace("user://", OS.get_user_data_dir() + "/")
	
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_var(content, true)
	file.close()


func get_collectable_item_properties(item: KinematicBody2D) -> Dictionary:
	return {"type": "collectable_item", "id": item.id, "item_name": item.item_name, "position": item.position, "height": item.height, "color": item.color, "collectable": item.collectable, "texture": item.texture, "shape": item.shape}

extends Node


func add_object(object):
	var properties: Dictionary = get_object_properties(object)
	databank.game_save.enviroment[stats.current_map][stats.current_room].added_items.append(properties)


func remove_object(object):
	var properties: Dictionary = get_object_properties(object)
	databank.game_save.enviroment[stats.current_map][stats.current_room].objects.erase(get_object_properties(properties))


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


func get_object_properties(object) -> Dictionary:
	match object.type:
		"item":
			return {"type": "item", "id": object.id, "item_name": object.item_name, "color": object.color, "shape_extents": object.shape_extents, "height": object.height, "collectable": object.collectable, "texture": object.texture, "position": object.position}
		"coin":
			return {"type": "coin", "id": object.id, "position": object.position}
	return {}

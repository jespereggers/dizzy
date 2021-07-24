extends Node


func add_object(object):
	var properties: Dictionary = get_object_properties(object)
	databank.game_save.enviroment[stats.current_map][stats.current_room].objects.append(properties)


func remove_object(object):
	var properties: Dictionary = get_object_properties(object)
	for object in databank.game_save.enviroment[stats.current_map][stats.current_room].objects:
		if str(properties) == str(object):
			databank.game_save.enviroment[stats.current_map][stats.current_room].objects.erase(object)


func load_file(path: String):
	path = path.replace("user://", OS.get_user_data_dir() + "/")

	if not File.new().file_exists(path):
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


func get_files(path: String, format: String) -> Array:
	var files : Array = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with("."+format):
			file = file.replace("."+format,"")
			files.append(file)
	dir.list_dir_end()
	return files


func save_file(path: String, content):
	path = path.replace("user://", OS.get_user_data_dir() + "/")
	
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_var(content, true)
	file.close()


func get_object_properties(object) -> Dictionary:
	match object.type:
		"item":
			return {"type": "item", "origin": object.origin, "id": object.id, "item_name": object.item_name, "color": object.color, "shape_extents": object.shape_extents, "height": object.height, "collectable": object.collectable, "texture": object.texture, "position": object.position}
		"coin":
			return {"type": "coin", "origin": object.origin, "id": object.id, "position": object.position}
		"shard":
			return {"type": "shard", "origin": object.origin, "id": object.id, "position": object.position}
			
	return {}

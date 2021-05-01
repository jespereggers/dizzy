extends Node


func add_item_to_game_save(item_instance):
	if not item_instance in databank.game_save.enviroment[stats.current_map].added_items:
		databank.game_save.enviroment[stats.current_map].added_items.append(item_instance)
	if item_instance in databank.game_save.enviroment[stats.current_map].removed_items:
		databank.game_save.enviroment[stats.current_map].removed_items.remove(item_instance)


func remove_item_from_game_save(item_instance):
	if not item_instance in databank.game_save.enviroment[stats.current_map].removed_items:
		databank.game_save.enviroment[stats.current_map].removed_items.append(item_instance)
	if item_instance in databank.game_save.enviroment[stats.current_map].added_items:
		databank.game_save.enviroment[stats.current_map].added_items.remove(item_instance)


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

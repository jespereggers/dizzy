extends Node


func import(mod_path: String):
	if not Directory.new().dir_exists(mod_path + "/items"):
		return
	else:
		data.items.clear()
	
	# Load Dialogues
	for file_name in tools.get_files(mod_path + "/items", "json"):
		data.items[file_name] = tools.load_file(mod_path + "/items/" + file_name + ".json")

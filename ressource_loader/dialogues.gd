extends Node


func import(mod_path: String):
	if not Directory.new().dir_exists(mod_path + "/dialogues"):
		return
	else:
		databank.dialogues.clear()
	
	# Load Dialogues
	for file_name in tools.get_files(mod_path + "/dialogues", "json"):
		databank.dialogues[file_name] = tools.load_file(mod_path + "/dialogues/" + file_name + ".json").dialogue

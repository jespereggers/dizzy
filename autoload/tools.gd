extends Node


var rng := RandomNumberGenerator.new()
func _ready():
				rng.randomize()

func create_physics_timer(t:float) -> PhysicsTimer:
	var new_timer := PhysicsTimer.new()
	add_child(new_timer)
	assert(new_timer.connect("timeout",new_timer,"queue_free")==OK)
	new_timer.start(t)
	return new_timer

func load_file(path: String):
	path = path.replace("user://", OS.get_user_data_dir() + "/")

	if not File.new().file_exists(path):
		return
		
	var file = File.new()
	file.open(path, File.READ)
	var content
	
	match path.split(".")[-1]:
		"txt":
			print("TXT")
			content = file.get_var(true)
		"json":
			print("JSON")
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


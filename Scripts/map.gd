extends Node2D

onready var root: Node2D = get_parent()
signal maps_cleaned
signal map_loaded

export var default_respawn: Vector2 = Vector2(220,134)
#export var custom_respawn_correction: Vector2 = Vector2(8, 48)

const BLACKSCREEN_DURATION = 0.4 #map change

func _ready():
	yield(signals, "backend_is_ready")
	_load_map()
	
func change_room(new_room_coords:Vector2):
	if not data.maps[stats.current_map].keys().has(new_room_coords):
		push_error("Error: Can't load nonexisting room")
	stats.current_room = new_room_coords
	_update_map()
	paths.display.update_display()

func _update_map():
	_clean_maps()
	yield(get_tree().create_timer(BLACKSCREEN_DURATION), "timeout") #blackscreen
	_load_map()

func _clean_maps():
	for room in get_children():
		#if str(room.filename) != data.maps[stats.current_map][stats.current_room].path and room.name != "user_interface":
		if room.name != "user_interface":
			room.queue_free()
	emit_signal("maps_cleaned")


func _load_map():
	var map: Node2D = load(data.maps[stats.current_map][stats.current_room].path).instance()
	add_child(map)
	emit_signal("map_loaded")

func add(properties: Dictionary):
	var object
	
	match properties.type:
		"item":
			object = load("res://templates/item.tscn").instance()
			object.set_properties(properties)
			object.load_template()
			object.update_pos()
	tools.add_object(object)
	
	for node in get_children():
		if "room" in node.name:
			node.get_node("objects").add_child(object)
			break


func remove(object):
	for node in get_children():
		if "room" in node.name:
			node.get_node("objects").remove_child(object)
			break


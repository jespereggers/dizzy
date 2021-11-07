extends Node2D

onready var root: Node2D = get_parent()
signal maps_cleaned
signal map_loaded

export var default_respawn: Vector2 = Vector2(220,134)
#export var custom_respawn_correction: Vector2 = Vector2(8, 48)

const BLACKSCREEN_DURATION = 0.35 #map change

func _ready():
	yield(signals, "backend_is_ready")
	load_map()


func update_map():
	clean_maps()
	yield(get_tree().create_timer(BLACKSCREEN_DURATION), "timeout") #blackscreen
	load_map()

func clean_maps():
	for room in get_children():
		if str(room.filename) != data.maps[stats.current_map][stats.current_room].path and room.name != "user_interface":
			room.queue_free()
	emit_signal("maps_cleaned")


func load_map():
	var map: Node2D = load(data.maps[stats.current_map][stats.current_room].path).instance()
#	if connect("tree_entered", self, "_on_map_enters_tree", [map]) != OK:
#		print("Error occured when trying to establish a connection")
#	call_deferred("add_child", map)
	add_child(map)
	emit_signal("map_loaded")



#func _on_map_enters_tree(map_instance: Node2D):
#	emit_signal("room_entered_tree")
#	yield(get_tree().create_timer(0.2), "timeout")
#
#	if map_instance == null:
#		return
#	for node in map_instance.get_children():
#		if node.get_class() == "Area2D":
#			node.monitoring = true


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


func respawn_player():
	var new_pos: Vector2
	for child in get_children():
		if "room_" in child.name:
			if child.has_node("respawn_point"):
				new_pos = child.get_node("respawn_point").global_position 
				#new_pos += custom_respawn_correction
			else:
				new_pos = default_respawn
				
	root.player.position = new_pos
	
	signals.emit_signal("player_respawned")

extends Node2D

onready var root: Node2D = get_parent()
signal room_entered_tree

func _ready():
	yield(signals, "backend_is_ready")
	update_map()


func update_map():
	clean_maps()
	
	var map: Node2D = load(databank.maps[stats.current_map][stats.current_room].path).instance()
	map.connect("tree_entered", self, "_on_map_enters_tree", [map])
	call_deferred("add_child", map)


func _on_map_enters_tree(map_instance: Node2D):
	emit_signal("room_entered_tree")
	yield(get_tree().create_timer(0.2), "timeout")
	if map_instance == null:
		return
	for node in map_instance.get_children():
		if node.get_class() == "Area2D":
			node.monitoring = true


func add_tile(tile_name: String):
	tile_name = tile_name.split("#")[0]
	var tile_instance = load("res://Scenes/tiles/" + tile_name + ".tscn").instance()
	tile_instance.name = tile_name + "#" + str(randi())
	tile_instance.position = paths.player.position
	tile_instance.position -= Vector2(8, 49)
	tile_instance.position.y += paths.player.get_height()
	tile_instance.position.y -= tile_instance.get_node(tile_name + "/collision").shape.extents.y - 1
	
	for node in get_children():
		if "room" in node.name:
			node.add_child(tile_instance, false)
			return


func clean_maps():
	for room in get_children():
		if str(room.filename) != databank.maps[stats.current_map][stats.current_room].path and room.name != "user_interface":
			room.queue_free()


func respawn_player():
	root.player.locked = false
	root.player.action = ["idle"]
	
	if self.get_children()[0].has_node("respawn_point"):
		root.player.position = self.get_children()[0].get_node("respawn_point").position 
	else:
		root.player.position = get_viewport_rect().size / 2
	
	paths.player.scale = Vector2(1,1)
	paths.player.set_physics_process(true)
	paths.player.show()

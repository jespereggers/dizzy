extends Node2D

onready var root: Node2D = get_parent()


func _ready():
	yield(signals, "backend_is_ready")
	update_map()


func update_map():
	clean_maps()
	
	var map: Node2D = load(databank.maps[stats.current_map][stats.current_room].path).instance()
	map.connect("tree_entered", self, "clean_maps")
	call_deferred("add_child", map)


func clean_maps():
	for room in get_children():
		if str(room.filename) != databank.maps[stats.current_map][stats.current_room].path:
			room.queue_free()


func respawn_player():
	root.player.locked = false
	root.player.action = ["idle"]
	
	if self.get_children()[0].has_node("respawn_point"):
		root.player.position = self.get_children()[0].get_node("respawn_point").position 
	else:
		root.player.position = get_viewport_rect().size / 2

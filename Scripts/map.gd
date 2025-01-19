extends Node2D

var room_node:Node2D = null
var previous_room := Vector2()
const BLACKSCREEN_DURATION = 0.4 #map change

func _ready():
		pass
		
func change_room(new_room_coords:Vector2):
		_leave_room()
		#special case for well
		if stats.game_state.current_room == Vector2(-4,-2): #room 20 leads to room 25
				new_room_coords = Vector2(-4,-4)
		_enter_room(new_room_coords)

func serialize_persistents():
		for room in get_children():
				if room.name != "user_interface":
						_unload_items(room)
						_load_items(room_node)

func _leave_room():
		for room in get_children():
				if room.name != "user_interface":
						_unload_items(room)
						room.queue_free()
		previous_room = stats.game_state.current_room
		signals.emit_signal("map_cleaned")

func _enter_room(new_room_coords:Vector2):
		if not data.maps[stats.game_state.current_map].keys().has(new_room_coords):
				push_error("Error: Can't load nonexisting room")
		stats.game_state.current_room = new_room_coords
		paths.display.update_display()
		yield(tools.create_physics_timer(BLACKSCREEN_DURATION),"timeout") #blackscreen
		_load_map()

func _load_map():
		room_node = load(data.maps[stats.game_state.current_map][stats.game_state.current_room].path).instance()
		add_child(room_node)
		_load_items(room_node)
		room_node.material = ShaderMaterial.new()
		room_node.material.shader = preload("res://shaders/hide_behind_border.shader")
		signals.emit_signal("map_loaded")

func _unique_item_string(item:Node2D):
		return item.name + str(item.position)

func _load_items(room:Node):
		if not stats.game_state.current_map in stats.game_state.persistents: #first time on this map
				stats.game_state.persistents[stats.game_state.current_map] = {} 
		if not stats.game_state.current_room in stats.game_state.persistents[stats.game_state.current_map]: #first time in this room
				stats.game_state.persistents[stats.game_state.current_map][stats.game_state.current_room] = {"removed_items": [], "remembered_items": []}
		#remove and remember items
		for child in room.get_children():
				if (child is Persistent):
						var unique_item_string = _unique_item_string(child)
						if not stats.game_state.persistents[stats.game_state.current_map][stats.game_state.current_room].removed_items.has(unique_item_string):
								stats.game_state.persistents[stats.game_state.current_map][stats.game_state.current_room].removed_items.append(unique_item_string)
								stats.game_state.persistents[stats.game_state.current_map][stats.game_state.current_room].remembered_items.append(child.serialize())
						room.remove_child(child)
						child.queue_free()
				#place remembered items
		for dict in stats.game_state.persistents[stats.game_state.current_map][stats.game_state.current_room]["remembered_items"]:
				var _discard = Persistent.deserialize(dict,room) #create Persistent and make it a child of room, do not use return val
				
func _unload_items(room:Node):
		#forget items
		if stats.game_state.persistents.has(stats.game_state.current_map):
				stats.game_state.persistents[stats.game_state.current_map][stats.game_state.current_room].remembered_items = []
		#remember items 
		for child in room.get_children():
				if (child is Persistent):
						stats.game_state.persistents[stats.game_state.current_map][stats.game_state.current_room].remembered_items.append(child.serialize())
						room.remove_child(child)
						child.queue_free()


func remove(object):
		for node in get_children():
				if "room" in node.name:
						node.get_node("objects").remove_child(object)
						break

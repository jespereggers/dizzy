extends Persistent

signal flipped
export var speed := 4
enum PLAYER_ENTRY_DIR {LEFT=0,RIGHT}
export(PLAYER_ENTRY_DIR) var player_entry_direction
export var entry_offset := 36 # one way 148
export var max_offset := 140
export var disabled := true setget set_disabled
onready var sprite := get_node("boat_node/sprite")
onready var boat := get_node("boat_node")
onready var shape:CollisionPolygon2D = get_node("boat_node/boat_body/shape")
onready var boat_body:StaticBody2D = get_node("boat_node/boat_body")
onready var raycast:RayCast2D = get_node("boat_node/RayCast2D")

var flipped:bool = false setget set_flipped, get_flipped


func check_entry_direction():
		var apply := false
		if not paths.player:
				return
		match player_entry_direction:
				PLAYER_ENTRY_DIR.LEFT:
					if paths.player.position.x == paths.player.MAP_CHANGE_ENTRY_LEFT:
						apply = true
						print("LEFT")
				PLAYER_ENTRY_DIR.RIGHT:
					if paths.player.position.x == paths.player.MAP_CHANGE_ENTRY_RIGHT:
						apply = true
						print("RIGHT")
		if not apply:
				return
		if entry_offset < max_offset:
				boat.position.x = -entry_offset
				if sprite.flip_h:
						set_flipped(false)
		else:
				boat.position.x = -(max_offset - (entry_offset - max_offset))
				if not sprite.flip_h:
						set_flipped(true)
		
func _ready(): #first init
		if stats.game_state.shared_scene_data.has("barrel_boat_disabled"):
				set_disabled(stats.game_state.shared_scene_data["barrel_boat_disabled"])
		else:
				set_disabled(true)


func _enter_tree(): #subsequent inits
		return
		if boat != null:
				if stats.game_state.shared_scene_data.has("barrel_boat_disabled"):
						set_disabled(stats.game_state.shared_scene_data["barrel_boat_disabled"])
				else:
						set_disabled(true)


func _on_loaded():
	check_entry_direction()
	
	if live.current_room == Vector2(-2,0):
		pass
	
	self.visible = !stats.game_state.shared_scene_data["barrel_boat_disabled"]


func _exit_tree():
	stats.game_state.shared_scene_data["barrel_boat_disabled"] = disabled


func set_flipped(val:bool) -> void:
		if sprite.flip_h == val:
				return
		sprite.flip_h = val
		var flipped_polygon:PoolVector2Array = []#cannot manipulate it in place
		for vertice in shape.polygon:
				flipped_polygon.append(Vector2(-vertice.x,vertice.y))
		shape.set_deferred("polygon",flipped_polygon)
		emit_signal("flipped")

func get_flipped() -> bool:
	return sprite.flip_h
		
func _physics_process(_delta):
		#don't move into dizzy
		raycast.force_raycast_update()
		if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider is Player:
						return
						
		if is_visible_in_tree():
				if boat.position.x == 0 and sprite.flip_h:
						set_flipped(false)
				if boat.position.x == -140 and not sprite.flip_h:
						set_flipped(true)
						
				if not sprite.flip_h:
						boat.position.x -= speed
				else:
						boat.position.x += speed

func set_disabled(value):
		disabled = value
		visible = not value
		if shape:
				shape.disabled = value

func disable():
		set_disabled(true)

func enable():
		set_disabled(false)

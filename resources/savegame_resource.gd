class_name SaveGame
extends Resource
const MAX_EGGS = 2

export var eggs := 2 setget _set_eggs
export var coins := 0 setget _set_coins
export var shards := 0 setget _set_shards
export var has_artifact := false setget _set_has_artifact

export var current_map = "map_1"
export var current_room := Vector2(0,0)
export var respawn_position := Vector2(188,148)
export var respawn_room := Vector2(0,0)

export var inventory_capacity := 2

export var shared_scene_data:Dictionary = {}
export var inventory:Array = []
export var persistents:Dictionary = {} #[map][room]{remembered_items,removed_items}

#recorder related
export var events:Dictionary
export var player_states:Dictionary
export var walk_idle_shared_frame_counter:int
export var rng_state : int = 0

func get_deep_copy() -> SaveGame: #Resource.duplicate doesn't do the job https://github.com/godotengine/godot/issues/74918
	var new_savegame = get_script().new()
	new_savegame.eggs = eggs
	new_savegame.coins = coins
	new_savegame.shards = shards
	new_savegame.has_artifact = has_artifact

	new_savegame.current_map = current_map
	new_savegame.current_room = current_room
	new_savegame.respawn_position = respawn_position
	new_savegame.respawn_room = respawn_room

	new_savegame.inventory_capacity = inventory_capacity

	new_savegame.shared_scene_data = shared_scene_data.duplicate(true)
	new_savegame.inventory = inventory.duplicate(true)
	new_savegame.persistents = persistents.duplicate(true)

	new_savegame.events = events.duplicate(true)
	new_savegame.player_states = player_states.duplicate(true)
	new_savegame.rng_state = rng_state
	return new_savegame
	
func _set_eggs(value: int):
		eggs = value
# warning-ignore:narrowing_conversion
		eggs = clamp(eggs, 0, MAX_EGGS)
		signals.emit_signal("eggs_changed")

func _set_coins(value:int):
		coins = value
		signals.emit_signal("coins_changed")

func _set_shards(value:int):
		shards = value
		signals.emit_signal("shards_changed")

func _set_has_artifact(value:bool):
		has_artifact = value
		signals.emit_signal("has_artifact_changed")

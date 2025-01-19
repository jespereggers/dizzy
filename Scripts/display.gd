extends CanvasLayer

onready var coins_label: Label = $coins_label
onready var shards_label: Label = $shards_label
onready var egg_list: HBoxContainer = $egg_list
onready var room_label: Label = $room_label
onready var root: Node2D = get_parent()


func _ready():
		assert(signals.connect("coins_changed", self, "update_coins") == OK)
		assert(signals.connect("shards_changed", self, "update_shards") == OK)
		assert(signals.connect("eggs_changed", self, "update_eggs") == OK)
				
				
#  yield(signals, "backend_is_ready")
		update_display()


func update_display():
		set_room_name_to(data.maps[stats.game_state.current_map][stats.game_state.current_room].name)
		set_coins_label_to(stats.game_state.coins)
		set_shards_label_to(stats.game_state.shards)
		set_eggs_label_to(stats.game_state.eggs)


func update_coins():
		set_coins_label_to(stats.game_state.coins)


func update_shards():
		set_shards_label_to(stats.game_state.shards)


func set_shards_label_to(amount: int):
		shards_label.text = str(amount)
		if amount < 10:
			shards_label.text = "0" + shards_label.text


func update_eggs():
		set_eggs_label_to(stats.game_state.eggs)


func set_room_name_to(new_room_name: String):
		room_label.text = new_room_name


func set_coins_label_to(amount: int):
		coins_label.text = str(amount)
		if amount < 10:
			coins_label.text = "0" + coins_label.text


func set_eggs_label_to(amount: int):
		for egg in egg_list.get_children():
				egg.visible = (int(egg.name.replace("egg_", "")) <= amount)

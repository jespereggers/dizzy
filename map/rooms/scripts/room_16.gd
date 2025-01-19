extends Node2D

var coin_pos_before_shake := Vector2(176,20)
var coin_pos_after_shake := Vector2(176,56)

onready var no_shake_zone = $NoShakeZone

const TIME_TO_COLLAPSE = 2.6
func _ready():
		assert(signals.connect("shake_started",self,"_on_shake_started") == OK)
		if stats.game_state.shared_scene_data.has("room_16_rubble_collapsed"):
				no_shake_zone.queue_free()

		#create coin
		if stats.game_state.shared_scene_data.has("room_10_coin_dropped") and !stats.game_state.shared_scene_data.has("room_16_coin_created"):
			stats.game_state.shared_scene_data["room_16_coin_created"] = true
			var new_coin = preload("res://templates/coin.tscn").instance()
			add_child(new_coin)
			if stats.game_state.shared_scene_data.has("room_16_rubble_collapsed"):
					new_coin.position = coin_pos_after_shake
			else:
					new_coin.position = coin_pos_before_shake

func collapse():
		var shake_before := $RubbleRoom_16/shake_before
		var shake_after := $RubbleRoom_16/shake_after
		shake_before.visible = false
		shake_before.collision_layer = 0
		shake_after.visible = true
		shake_after.collision_layer = 1

func _on_shake_started():
		if stats.game_state.shared_scene_data.has("room_16_rubble_collapsed"):
				return
		yield(tools.create_physics_timer(TIME_TO_COLLAPSE),"timeout")
		no_shake_zone.queue_free()
		stats.game_state.shared_scene_data["room_16_rubble_collapsed"] = true
		collapse()
		if get_node_or_null("coin"):
			if stats.game_state.shared_scene_data.has("room_16_rubble_collapsed"):
					$coin.position = coin_pos_after_shake
			else:
					$coin.position = coin_pos_before_shake

extends Persistent
onready var interaction_area = $InteractionArea

export var coins_needed := 12

func drop_coins():
		stats.game_state.coins = 0
		queue_free()
		$"../WellBlockage".queue_free()

func _on_InteractionArea_area_entered(area):
		if area is Player:
				if stats.game_state.coins >= coins_needed and not get_node_or_null("../well_debris"):
						interaction_area.dialogue = ["box:room_11/message_coin_well","wait","call:CoinSlot:drop_coins"]
						interaction_area.needed_item = ""
				else:
						interaction_area.dialogue = []
						interaction_area.needed_item = "invalid"

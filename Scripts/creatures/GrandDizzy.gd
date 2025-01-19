extends Persistent
onready var interaction_area = $InteractionArea

var greeting_finished := false

func check_quest_progress():
		var coin_slot = $"../CoinSlot"
		if not coin_slot:
				interaction_area.dialogue = [
						"box:room_11/message_granddizzy_after",
						"wait"
						]
		elif stats.game_state.coins >= coin_slot.coins_needed:
				interaction_area.dialogue = [
						"box:room_11/message_coin_complete",
						"wait"
						]
		else:
				interaction_area.dialogue = [
						"box:room_11/message_coin_missing_1","wait",
						"box:room_11/message_coin_missing_2","wait",
						"box:room_11/message_coin_missing_3","wait"
						]

func end_greeting():
		greeting_finished = true
		$"../well_debris".queue_free()
		check_quest_progress()

func _on_InteractionArea_area_entered(_area):
		if not greeting_finished:
				interaction_area.dialogue = [
						"box:room_11/message_granddizzy_before_1","wait",
						"box:room_11/message_granddizzy_before_2","wait",
						"box:room_11/message_granddizzy_before_3","wait",
						"box:room_11/message_granddizzy_before_4","wait",
						"box:room_11/message_granddizzy_before_5","wait",
						"box:room_11/message_granddizzy_before_6","wait",
						"box:room_11/message_granddizzy_before_7","wait",
						"box:room_11/message_granddizzy_before_8","wait",
						"box:room_11/message_granddizzy_before_9","wait",
						"box:room_11/message_granddizzy_before_10","wait",
						"box:room_11/message_granddizzy_before_11","wait",
						"call:GrandDizzy:end_greeting"]
		else:
				check_quest_progress()

func let_dizzy_jump():
		paths.player.position.y = $"../well_jump_start_height".global_position.y
		if paths.player.state_machine._dir == 0: #if dizzy is idling while falling
				match paths.player.texture.flip_h:
						true: paths.player.force_look_dir(-1)
						false: paths.player.force_look_dir(1)
		
		# In der nächsten Zeile # entfernen um Dizzy immer nach rechts springen zu lassen
		#paths.player.force_look_dir(1)
		
		paths.player.force_jump()
		paths.player.set_jump_frame_counter(1)
		paths.player.set_animation_frame(1)

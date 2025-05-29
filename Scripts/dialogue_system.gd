extends Control

signal dialogue_accepted()
signal dialogue_ended()

var visible_boxes := []

func play_custom(procedure: PoolStringArray):
		print("play custom")
		for action in procedure:
				match action.rsplit(":")[0]:
						"clear":
								clear_boxes()
						"box_clear":
								clear_boxes()
								continue
						"box","box_clear":
								var node_name = action.rsplit(":")[1] + "_" + TranslationServer.get_locale()
								print("show box: ",node_name)
								if self.has_node(node_name):
										# Success
										var dialogue_box: Popup = get_node(action.rsplit(":")[1] + "_" + TranslationServer.get_locale())
										dialogue_box.popup()
										visible_boxes.append(dialogue_box)
								else:
										# Warning
										print("Unable to Access " + node_name)
										pass
						"timer":
								yield(tools.create_physics_timer(float(action.rsplit(":")[1])),"timeout")
						"wait":
								yield(self, "dialogue_accepted")
						"call":
								var node:Node2D = paths.map.room_node.get_node(action.rsplit(":")[1])
								assert(node)
								var method:String = action.rsplit(":")[2]
								assert(node.has_method(method))
								node.call(method)
						"move_player":
								var pos := Vector2(0,0)
								pos.x = float(action.rsplit(":")[1].rsplit(",")[0])
								pos.y = float(action.rsplit(":")[1].rsplit(",")[1])
								paths.player.position = pos
						"respawn":
								respawn()
						"destroy_item":
								for slot in stats.inventory:
										if slot.item_name == action.rsplit(":")[1]:
												stats.remove_item_from_inventory(slot)
						"get_item":
								var path = "res://" +  action.rsplit(":")[1]
								var new_item:Item = load(path).instance()
								stats.pick_up_item(new_item) 
						"increment_coins":
								stats.game_state.coins += 1
						"increment_shards":
								stats.game_state.shards += 1
						"decrease_eggs":
								decrease_eggs()
						"play":
								audio.play(action.rsplit(":")[1])
						"await":
								yield(signals,action.rsplit(":")[1])
						"game_over":
								signals.emit_signal("game_over")
						var err:
								push_error("unknown action: " + err)
		end()


func open(dialogue:Array):
		set_process_unhandled_input(true)
		show()
		play_custom(dialogue)

		
func clear_boxes():
		for box in visible_boxes:
				box.hide()
		visible_boxes.clear()

func end():
		if live.blocked:
			return

		clear_boxes()
		hide()
		set_process_unhandled_input(false)
		emit_signal("dialogue_ended")

func decrease_eggs():
		if not stats.infinite_eggs:
				stats.game_state.eggs -=1


func _get_respawn_duration():
		return paths.map.BLACKSCREEN_DURATION  + paths.player.animations.get_animation("respawn").length/paths.player.animations.playback_speed

func respawn():
		if stats.game_state.current_room is String:
				paths.map.change_room(stats.game_state.respawn_room)
		elif stats.game_state.respawn_room != stats.game_state.current_room:
				paths.map.change_room(stats.game_state.respawn_room)
		yield(tools.create_physics_timer(paths.map.BLACKSCREEN_DURATION),"timeout")
		paths.player._respawn()

		paths.player.show()


func _unhandled_input(event:InputEvent):
		if event.is_action_pressed("enter") or event is InputEventScreenTouch and event.pressed:
				if visible_boxes.size() > 0:
					if "death" in visible_boxes[0].name:
						return
					
				emit_signal("dialogue_accepted")
				
				get_tree().set_input_as_handled()
				
				if visible_boxes.size() > 0:
					if "artifact" in visible_boxes[0].name:
						end()
						live.block()
					else:
						print("no closure with ", visible_boxes[0].name)

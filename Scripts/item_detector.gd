extends Area2D

func _input(_event):
	if Input.is_action_just_released("enter") and paths.player.is_on_floor():
		var detected_items: Array	
		for object in ItemCollision.get_colliding_items($shape):
				if object is Item:
					detected_items.append(object)
		if not detected_items.empty():
			detected_items.sort_custom(Item.new(),"item_comparision")
			detected_items.back().get_picked_up() #pick up item with highest priority
		
		
#		for item in items_to_remove:
#			if item is Coin or item is Shard:
#				signals.emit_signal("countable_collected", item)
#
#			match item.type:
#				"item":
#					available_items.erase(item)
#					item.destroy()
#					if open_inventory:
#						paths.ui.inventory.open()
#				"shard":
#					data.game_save.enviroment[stats.current_map][stats.current_room].removed_objects.append(item.origin)
#					tools.remove_object(item)
#					signals.emit_signal("countable_collected", item)
#				"coin":
#					data.game_save.enviroment[stats.current_map][stats.current_room].removed_objects.append(item.origin)
#					tools.remove_object(item)
#					signals.emit_signal("countable_collected", item)
		
#		if full_inventory:
#			paths.ui.inventory.trying_to_hold_too_much = true
#			paths.ui.inventory.open()
#
#
#func check_detections(available_items):
#	var positions: Array = []
#
#	for item in available_items:
#		if item.position in positions:
#			# Decide which item to keep
#			var candidates: Array = []
#			# Get Candidates
#			for candidate in available_items:
#				if candidate.position == item.position:
#					candidates.append(candidate)
#			# Choose highest item
#			var highest_item = candidates[0]
#			for candidate in candidates:
#				if candidate.get_index() > highest_item.get_index():
#					highest_item = candidate
#			# Delete lower items
#			for candidate in available_items:
#				if candidate in candidates and not candidate == highest_item:
#					available_items.erase(candidate)
#		else:
#			# Decide which item to keep
#			# Everything is just fine
#			positions.append(item.position)

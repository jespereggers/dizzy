extends Area2D

var detected_items: Array


func _on_item_detector_area_entered(area):
	if area.get_parent().get("type") and area.get_parent().type in ["item", "shard", "coin"]:
		detected_items.append(area.get_parent())


func _on_item_detector_area_exited(area):
	if area.get_parent().get("type") and area.get_parent().type in ["item", "shard", "coin"]:
		detected_items.erase(area.get_parent())


func _input(_event):
	if Input.is_action_just_released("enter") and paths.player.is_on_floor():
		var available_items: Array = detected_items.duplicate()
		var open_inventory: bool = false
		var items_to_remove: Array
		var full_inventory: bool = false
		
		if not available_items.empty():
			open_inventory = true

		check_detections(available_items)

		for item in available_items:
			if item.get("type") and item.type in ["shard", "coin"]:
				items_to_remove = [item]
				break
				
			if item.get("type") and item.type in ["item", "shard", "coin"]:# and item.player_is_in_range:
				if stats.inventory.size() < 2:
					items_to_remove.append(item)
				else:
					full_inventory = true
				break
		
		for item in items_to_remove:
			match item.type:
				"item":
					available_items.erase(item)
					item.destroy()
					if open_inventory:
						paths.ui.inventory.open()
				"shard":
					data.game_save.enviroment[stats.current_map][stats.current_room].removed_objects.append(item.origin)
					tools.remove_object(item)
					signals.emit_signal("countable_collected", item)
				"coin":
					data.game_save.enviroment[stats.current_map][stats.current_room].removed_objects.append(item.origin)
					tools.remove_object(item)
					signals.emit_signal("countable_collected", item)
		
		if full_inventory:
			paths.ui.inventory.trying_to_hold_too_much = true
			paths.ui.inventory.open()


func check_detections(available_items):
	var positions: Array = []
	
	for item in available_items:
		if item.position in positions:
			# Decide which item to keep
			var candidates: Array = []
			# Get Candidates
			for candidate in available_items:
				if candidate.position == item.position:
					candidates.append(candidate)
			# Choose highest item
			var highest_item = candidates[0]
			for candidate in candidates:
				if candidate.get_index() > highest_item.get_index():
					highest_item = candidate
			# Delete lower items
			for candidate in available_items:
				if candidate in candidates and not candidate == highest_item:
					available_items.erase(candidate)
		else:
			# Decide which item to keep
			# Everything is just fine
			positions.append(item.position)

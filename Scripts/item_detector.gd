extends Area2D

var detected_items: Array


func _on_item_detector_area_entered(area):
	if area.get_parent().get("type") and area.get_parent().type == "item":
		detected_items.append(area.get_parent())


func _on_item_detector_area_exited(area):
	if area.get_parent().get("type") and area.get_parent().type == "item":
		detected_items.erase(area.get_parent())


func _input(_event):
	if Input.is_action_just_released("enter") and paths.player.is_on_floor():
		var open_inventory = false
		if not detected_items.empty():
			open_inventory = true
			
		for item in detected_items:
			if item.get("type") and item.type == "item" and item.player_is_in_range and item.collectable:
				if stats.inventory.size() < 2:
					item.destroy()
					detected_items.erase(item)
				else:
					paths.ui.inventory.trying_to_hold_too_much = true
		
		if open_inventory:
			paths.ui.inventory.open()

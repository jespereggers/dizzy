extends Area2D

func _input(_event):
	if Input.is_action_just_released("enter") and paths.player.is_on_floor() and paths.player.state_machine._state == "idle":
		var detected_items: Array
		for object in ItemCollision.get_colliding_items($shape):
				print("-> ", object.name)
				if object is Item:
					detected_items.append(object)
		if not detected_items.empty():
			detected_items.sort_custom(Item.new(),"item_comparision")
			detected_items.back().get_picked_up() #pick up item with highest priority


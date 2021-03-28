extends Popup

onready var item_list_panel: Panel = $item_list
onready var choose_item_dialogue: Panel = $choose_item_dialogue
onready var full_inventory_dialogue: Panel = $full_inventory_dialogue

var selected_item_instance: Button

func _ready():
	item_list_panel.self_modulate = Color(databank.colors.green)
	choose_item_dialogue.self_modulate = Color(databank.colors.white)
	full_inventory_dialogue.self_modulate = Color(databank.colors.white)


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if $item_list/content/hint.is_visible_in_tree():
			close()
			
	if Input.is_action_just_pressed("enter"):
		if self.is_visible_in_tree():
			close()
		else:
			if not get_parent().death.visible and not get_parent().locked and paths.player.is_on_floor():
				if paths.player.area.colliding_area != null:
					if paths.player.area.colliding_area.name in databank.available_items:
						if stats.inventory.size() < 3:
							stats.inventory.append(paths.player.area.colliding_area.name)
							paths.player.area.colliding_area.get_parent().queue_free()
							paths.player.area.colliding_area = null
					else:
						return
				open()


func _on_item_pressed(item_name: String):
	if is_visible_in_tree() and item_name.to_lower() in databank.available_items:
		paths.map.add_tile(item_name.to_lower())
		for item in stats.inventory.size():
			if stats.inventory[item] == item_name.to_lower():
				stats.inventory.remove(item)
				break
		close()


func open():
	item_list_panel.set_process_input(true)
	get_tree().paused = true
	paths.player.visible = false
	self.visible = true
	item_list_panel.load_items()


func close():
	item_list_panel.set_process_input(false)
	selected_item_instance = null
	get_tree().paused = false
	paths.player.visible = true
	self.visible = false


func _on_close_pressed():
	close()


func _on_inventory_popup_hide():
	selected_item_instance = null

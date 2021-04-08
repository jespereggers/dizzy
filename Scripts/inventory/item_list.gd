extends Panel

onready var root: Popup = get_parent()
onready var list_instance: VBoxContainer = $content/item_list
onready var hint_instance: Label = $content/hint


func select_item(item_instance: Button):
	if root.selected_item_instance != null and item_instance != null and item_instance.get_class() == "Button" and item_instance != root.selected_item_instance:
		root.selected_item_instance.pressed = false
		item_instance.pressed = true
		root.selected_item_instance = item_instance


func load_items():
	# Clear-Up
	for item in list_instance.get_children():
		list_instance.remove_child(item)
			
	# Instance new items to the inventory
	for item_name in stats.inventory:
		if list_instance.get_child_count() < 2:
			var item_instance: Button = load("res://Scenes/templates/item_template.tscn").instance()
			item_instance.load_template(item_name)
			list_instance.add_child(item_instance)
			item_instance.connect("pressed", get_parent(), "_on_item_pressed", [item_instance.text])
	
	get_parent().get_node("choose_item_dialogue").hide()
	get_parent().get_node("full_inventory_dialogue").hide()
	
	if list_instance.get_child_count() < 1:
		# Empty inventory
		self.set_process_input(false)
		hint_instance.show()
	else:
		# Inventory includes items
		hint_instance.hide()
		
		var item_instance: Button = load("res://Scenes/templates/item_template.tscn").instance()
		item_instance.load_template("exit and don't drop")
		list_instance.add_child(item_instance)
		item_instance.grab_focus()

		if stats.inventory.size() > 2:
			self.set_process_input(false)
			get_parent().get_node("full_inventory_dialogue").show()
		else:
			self.set_process_input(true)
			get_parent().get_node("choose_item_dialogue").show()
	
	# Connect focuses
	for button in list_instance.get_children():
		if button.get_index() - 1 >= 0:
			button.focus_neighbour_left = list_instance.get_child(button.get_index() - 1).get_path()
			button.focus_neighbour_top = list_instance.get_child(button.get_index() - 1).get_path()
		else:
			button.focus_neighbour_left = list_instance.get_child(list_instance.get_child_count() - 1).get_path()
			button.focus_neighbour_top = list_instance.get_child(list_instance.get_child_count() - 1).get_path()
	
		if button.get_index() + 1 <= list_instance.get_child_count() - 1:
			button.focus_neighbour_right = list_instance.get_child(button.get_index() + 1).get_path()
			button.focus_neighbour_bottom = list_instance.get_child(button.get_index() + 1).get_path()
		else:
			button.focus_neighbour_right = list_instance.get_child(0).get_path()
			button.focus_neighbour_bottom = list_instance.get_child(0).get_path()
	
	if list_instance.get_child_count() > 0:
		yield(get_tree().create_timer(0.2), "timeout")
		if not list_instance.get_child(list_instance.get_child_count() - 1).is_connected("button_up", get_parent(), "close"):
			list_instance.get_child(list_instance.get_child_count() - 1).connect("button_up", get_parent(), "close")

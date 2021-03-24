extends Panel

onready var root: Popup = get_parent()
onready var list_instance: VBoxContainer = $content/item_list
onready var action_instance: Label = $content/action
onready var hint_instance: Label = $content/hint


func _input(event):
	if not event is InputEventMouse and is_visible_in_tree() and list_instance.get_child_count() > 0:
		
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right"):
			if root.selected_item_instance == null:
				root.selected_item_instance = list_instance.get_child(0)
				root.selected_item_instance.pressed = true

			elif list_instance.get_child_count() > root.selected_item_instance.get_index() + 1:
				select_item(list_instance.get_child(root.selected_item_instance.get_index() + 1))
			else:
				root.selected_item_instance.pressed = false
				root.selected_item_instance = null
		
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left"):
			if root.selected_item_instance == null:
				root.selected_item_instance = list_instance.get_child(list_instance.get_child_count() - 1)
				root.selected_item_instance.pressed = true
				
			elif root.selected_item_instance.get_index() > 0:
				select_item(list_instance.get_child(root.selected_item_instance.get_index() - 1))
			else:
				root.selected_item_instance.pressed = false
				root.selected_item_instance = null


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
	
	get_parent().get_node("choose_item_dialogue").hide()
	get_parent().get_node("full_inventory_dialogue").hide()
	
	if list_instance.get_child_count() < 1:
		# Empty inventory
		self.set_process_input(false)
		hint_instance.show()
		action_instance.hide()
	else:
		# Inventory includes items
		hint_instance.hide()
		action_instance.show()
		
		if stats.inventory.size() > 2:
			self.set_process_input(false)
			get_parent().get_node("full_inventory_dialogue").show()
		else:
			self.set_process_input(true)
			get_parent().get_node("choose_item_dialogue").show()
		
		if paths.player.area.colliding_area != null and paths.player.area.colliding_area.name in databank.available_items:
			# Player stands on a collectable item
			return

		root.selected_item_instance = list_instance.get_children()[0]
		root.selected_item_instance.pressed = true

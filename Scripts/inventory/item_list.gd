extends Panel

onready var root: Popup = get_parent()
onready var item_list_instance: VBoxContainer = $content/item_list


func _input(event):
	if not event is InputEventMouse and is_visible_in_tree() and item_list_instance.get_child_count() > 1:
		
		if Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right"):
			if root.selected_item_instance == null:
				root.selected_item_instance = item_list_instance.get_child(0)
				root.selected_item_instance.pressed = true

			elif item_list_instance.get_child_count() - 1 > root.selected_item_instance.get_index() + 1:
				select_item(item_list_instance.get_child(root.selected_item_instance.get_index() + 1))
			else:
				root.selected_item_instance.pressed = false
				root.selected_item_instance = null
		
		if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left"):
			if root.selected_item_instance == null:
				root.selected_item_instance = item_list_instance.get_child(item_list_instance.get_child_count() - 2)
				root.selected_item_instance.pressed = true
				
			elif root.selected_item_instance.get_index() - 1 >= 0:
				select_item(item_list_instance.get_child(root.selected_item_instance.get_index() - 1))
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
	for item in item_list_instance.get_children():
		if item.name != "action":
			item_list_instance.remove_child(item)
			
	# Instance new items to the inventory
	root.get_node("choose_item_dialogue").show()
	for item_name in stats.inventory:
		if item_list_instance.get_child_count() < 3:
			var item_instance: Button = load("res://Scenes/templates/item_template.tscn").instance()
			item_instance.load_template(item_name)
			item_list_instance.add_child(item_instance)
		else:
			root.get_node("choose_item_dialogue").hide()
			root.get_node("full_inventory_dialogue").show()
			break
			
	
	if item_list_instance.get_child_count() > 1:
		var action_instance: Label = item_list_instance.get_node("action")
		get_node("content/item_list").remove_child(item_list_instance.get_node("action"))
		get_node("content/item_list").add_child(action_instance)
		item_list_instance.get_node("action").show()
	else:
		item_list_instance.get_node("action").hide()
	
	if item_list_instance.get_child_count() < 2:
		get_node("content/hint").show()
		root.get_node("choose_item_dialogue").hide()
	else:
		get_node("content/hint").hide()
		if paths.player.area.colliding_area != null and paths.player.area.colliding_area.name in databank.available_items:
			# Player stands on a collectable item
			return
		root.selected_item_instance = item_list_instance.get_child(0)
		root.selected_item_instance.pressed = true

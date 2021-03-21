extends Popup

onready var item_list_panel: Panel = $item_list
onready var item_list_instance: VBoxContainer = $item_list/content/item_list
onready var choose_item_dialogue: Panel = $choose_item_dialogue
onready var full_inventory_dialogue: Panel = $full_inventory_dialogue

var selected_item_instance: Button

func _ready():
	item_list_panel.self_modulate = Color(databank.colors.green)
	choose_item_dialogue.self_modulate = Color(databank.colors.white)
	full_inventory_dialogue.self_modulate = Color(databank.colors.white)


func _input(_event):
	if is_visible_in_tree() and item_list_instance.get_child_count() > 1:
		
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_right"):
			if selected_item_instance == null:
				selected_item_instance = item_list_instance.get_child(0)
				selected_item_instance.pressed = true

			elif item_list_instance.get_child_count() - 1 > selected_item_instance.get_index() + 1:
				select_item(item_list_instance.get_child(selected_item_instance.get_index() + 1))
			else:
				selected_item_instance.pressed = false
				selected_item_instance = null
		
		if Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left"):
			if selected_item_instance == null:
				selected_item_instance = item_list_instance.get_child(item_list_instance.get_child_count() - 2)
				selected_item_instance.pressed = true
				
			elif selected_item_instance.get_index() - 1 >= 0:
				select_item(item_list_instance.get_child(selected_item_instance.get_index() - 1))
			else:
				selected_item_instance.pressed = false
				selected_item_instance = null
		
	
	if Input.is_action_just_pressed("enter"):
		var is_visible: bool = is_visible_in_tree()
		get_tree().paused = not is_visible
		paths.player.visible = is_visible
		self.visible = not is_visible
		item_list_panel.visible = not is_visible
		
		if is_visible:
			# Close inventory
			pass
		else:
			# Open inventory
			load_items()


func load_items():
	# Clear-Up
	for item in item_list_instance.get_children():
		if item.name != "action":
			item_list_instance.remove_child(item)
			
	# Instance new items to the inventory
	for item_name in stats.inventory:
		var item_instance: Button = load("res://Scenes/templates/item_template.tscn").instance()
		item_instance.load_template(item_name)
		item_list_instance.add_child(item_instance)
	
	if item_list_instance.get_child_count() > 1:
		var action_instance: Label = item_list_instance.get_node("action")
		item_list_panel.get_node("content/item_list").remove_child(item_list_instance.get_node("action"))
		item_list_panel.get_node("content/item_list").add_child(action_instance)
		item_list_instance.get_node("action").show()
	else:
		item_list_instance.get_node("action").hide()
	
	if item_list_instance.get_child_count() < 2:
		item_list_panel.get_node("content/hint").show()
	else:
		selected_item_instance = item_list_instance.get_child(0)
		selected_item_instance.pressed = true
		item_list_panel.get_node("content/hint").hide()
	
	full_inventory_dialogue.visible = item_list_instance.get_child_count() > 3
	choose_item_dialogue.visible = item_list_instance.get_child_count() < 4


func select_item(item_instance: Button):
	if selected_item_instance != null and item_instance != null and item_instance.get_class() == "Button" and item_instance != selected_item_instance:
		selected_item_instance.pressed = false
		item_instance.pressed = true
		selected_item_instance = item_instance
		

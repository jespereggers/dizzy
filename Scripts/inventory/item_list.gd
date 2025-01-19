extends NinePatchRect

onready var list_instance: VBoxContainer = $item_list
onready var empty_inv_hint: Label = $empty_inv_hint

var items_by_buttons:Dictionary
var close_button:Button

func load_items():
		# Clear-Up
		items_by_buttons.clear()
		for item in list_instance.get_children():
				list_instance.remove_child(item)
		
		# Create buttons from inventory items
		for item in stats.inventory:
				var button_instance: Button = load("res://Scenes/templates/item_template.tscn").instance()
				button_instance.load_template(item.item_name)
				list_instance.add_child(button_instance)
				items_by_buttons[button_instance] = item
				
		var close_button_instance: Button = load("res://Scenes/templates/item_template.tscn").instance()
		close_button_instance.load_template("exit and don't drop")
		list_instance.add_child(close_button_instance)
		close_button = close_button_instance
		
		var buttons := list_instance.get_children()
		for i in buttons.size():
				var button:Button = buttons[i]
				button.focus_neighbour_top = buttons[posmod(i-1,buttons.size())].get_path()
				button.focus_neighbour_bottom = buttons[posmod(i+1,buttons.size())].get_path()
		
		if list_instance.get_child_count() == 1: # there a no items except the close button
				empty_inv_hint.show()
				list_instance.hide()
		else:
				empty_inv_hint.hide()
				list_instance.show()

func get_selected_item() -> Item:
		var button = get_focus_owner()
		if button == close_button or button == null:
				return null
		else:
				assert(items_by_buttons.has(button))
				return items_by_buttons[button]
				

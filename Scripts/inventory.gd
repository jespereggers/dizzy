extends Popup

onready var item_list_panel: Panel = $item_list
onready var choose_item_dialogue: Panel = $choose_item_dialogue
onready var full_inventory_dialogue: Panel = $full_inventory_dialogue

var selected_item_instance: Button

func _ready():
	item_list_panel.self_modulate = Color(databank.colors.green)
	choose_item_dialogue.self_modulate = Color(databank.colors.white)
	full_inventory_dialogue.self_modulate = Color(databank.colors.white)


func _input(_event):
	if Input.is_action_just_pressed("enter"):
		if paths.player.area.colliding_area != null and not paths.player.area.colliding_area.name in databank.available_items:
			return
			
		if is_visible_in_tree():
			if selected_item_instance != null:
				paths.map.add_tile(selected_item_instance.name)
				
				for i in stats.inventory.size():
					if stats.inventory[i] == selected_item_instance.name:
						stats.inventory.remove(i)
						break
			close()
		else:
			if paths.player.area.colliding_area == null:
				open()
			else:
				if stats.inventory.size() < 3:
					stats.inventory.append(paths.player.area.colliding_area.name)
				open()
				if stats.inventory.size() < 3:
					paths.player.area.colliding_area.get_parent().queue_free()
					paths.player.area.colliding_area = null


func open():
	get_tree().paused = true
	paths.player.visible = false
	self.visible = true
	item_list_panel.load_items()


func close():
	selected_item_instance = null
	get_tree().paused = false
	paths.player.visible = true
	self.visible = false


func _on_inventory_popup_hide():
	selected_item_instance = null

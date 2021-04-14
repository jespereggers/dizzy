extends Popup

onready var item_list_panel: Panel = $item_list
onready var choose_item_dialogue: Panel = $choose_item_dialogue
onready var full_inventory_dialogue: Panel = $full_inventory_dialogue

var selected_item_instance: Button


func _ready():
	item_list_panel.self_modulate = Color(databank.colors.green)
	choose_item_dialogue.self_modulate = Color(databank.colors.white)
	full_inventory_dialogue.self_modulate = Color(databank.colors.white)
	
	signals.connect("item_collected", self, "_on_item_collected")


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if $item_list/content/hint.is_visible_in_tree():
			close()
			
	if Input.is_action_just_pressed("enter"):
		if self.is_visible_in_tree():
			yield(get_tree().create_timer(0.1), "timeout")
			close()
		else:
			if not get_parent().death.visible and not get_parent().locked and paths.player.is_on_floor():
				open()
				
				
func _on_item_collected(item_instance):
	if stats.inventory.size() < 3:
		stats.inventory.append(item_instance.duplicate())
		item_instance.queue_free()
	open()


func _on_item_pressed(item_instance: KinematicBody2D):
	if is_visible_in_tree():
		paths.map.add_tile(item_instance)
		for item in stats.inventory.size():
			if stats.inventory[item] == item_instance:
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

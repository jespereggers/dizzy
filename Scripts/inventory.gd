extends Popup

onready var item_list_panel: Panel = $item_list
onready var choose_item_dialogue: Panel = $choose_item_dialogue
onready var full_inventory_dialogue: Panel = $full_inventory_dialogue

var selected_item_instance: Button
var trying_to_hold_too_much: bool = false

func _ready():
	item_list_panel.self_modulate = Color(databank.colors.green)
	choose_item_dialogue.self_modulate = Color(databank.colors.white)
	full_inventory_dialogue.self_modulate = Color(databank.colors.white)


func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if $hint.is_visible_in_tree():
			close()
			
			# Secure
			set_process_input(false)
			yield(get_tree().create_timer(0.2), "timeout")
			set_process_input(true)
			
	if Input.is_action_just_pressed("enter") and not paths.settings.visible:
		if self.is_visible_in_tree():
			if get_node("hint").visible:
				close()
		elif paths.player.item_detector.detected_items.empty() and not get_parent().death.visible and not get_parent().locked and paths.player.is_on_floor():
			if not get_parent().get_node("found_coin").visible:
				open()
			
		# Secure
		set_process_input(false)
		yield(get_tree().create_timer(0.2), "timeout")
		set_process_input(true)


func _on_item_pressed(object_properties: Dictionary):
	if is_visible_in_tree():
		for item_properties in stats.inventory:
			if item_properties == object_properties:
				stats.inventory.erase(item_properties)
				break
		paths.map.add(object_properties)
		close()


func open():
	signals.emit_signal("pause_mode_changed_to", true)
	get_parent().locked = true
	item_list_panel.set_process_input(true)
	get_tree().paused = true
	paths.player.visible = false
	self.visible = true
	item_list_panel.load_items()
	
	# Secure
	set_process_input(false)
	yield(get_tree().create_timer(0.2), "timeout")
	set_process_input(true)


func close():
	trying_to_hold_too_much = false
	signals.emit_signal("pause_mode_changed_to", false)
	get_parent().locked = false
	item_list_panel.set_process_input(false)
	selected_item_instance = null
	get_tree().paused = false
	paths.player.visible = true
	self.visible = false
	
	# Secure
	set_process_input(false)
	yield(get_tree().create_timer(0.2), "timeout")
	set_process_input(true)


func _on_close_pressed():
	close()


func _on_inventory_popup_hide():
	selected_item_instance = null

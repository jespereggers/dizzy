extends Popup

onready var item_list_panel: Panel = $item_list
onready var choose_item_dialogue: Panel = $choose_item_dialogue
onready var full_inventory_dialogue: Panel = $full_inventory_dialogue

var selected_item_instance: Button
var trying_to_hold_too_much: bool = false

func _ready():
	item_list_panel.self_modulate = Color(data.colors.green)
	choose_item_dialogue.self_modulate = Color(data.colors.white)
	full_inventory_dialogue.self_modulate = Color(data.colors.white)
	item_list_panel.connect("finished_showing_full_inventory",self,"_on_finished_showing_full_inventory")

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
		elif ItemCollision.get_colliding_items(paths.player.get_node("item_detector/shape")).empty() and not get_parent().death.visible and paths.player.is_on_floor() and paths.player.state_machine._state == "idle":
			if not get_parent().locked:
				if not get_parent().get_node("found_countable").visible:
					open()

		# Secure
		set_process_input(false)
		yield(get_tree().create_timer(0.2), "timeout")
		set_process_input(true)


func _on_item_pressed(item: Item):
	if is_visible_in_tree():
		item.get_dropped()
		stats.remove_item_from_inventory(item)
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

func _on_finished_showing_full_inventory():
	close()

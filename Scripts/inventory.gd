extends Popup

signal closed

onready var item_list_2_item: NinePatchRect = $item_list_2_item
onready var item_list_4_item: NinePatchRect = $item_list_4_item
onready var choose_item_dialogue: NinePatchRect = $choose_item_dialogue
onready var full_inventory_dialogue: NinePatchRect = $full_inventory_dialogue

export var DURATION_SHOWING_FULL_INVENTORY := 2.45

var selected_item_instance: Button
var trying_to_hold_too_much: bool = false

var can_drop_items := true
var item_to_remove_from_world_upon_close:Item


func _unhandled_input(event:InputEvent):
		if event.is_action_pressed("enter"):
			print("close")
			close()
			get_tree().set_input_as_handled()


func _ready():
	assert(signals.connect("touch_while_paused",self,"_on_touch_while_paused") == OK)


func _on_touch_while_paused():
	print("visible when touched while paused")

	if self.visible:
		if stats.inventory.empty():
			return
		close()
	else:
		if not live.blocked:
			open()


func open_just_to_show_increased_capacity():
#		print("inventory opened to show capacity")
		visible = true
		item_list_2_item.hide()
		item_list_4_item.show()
		item_list_4_item.load_items()
		if stats.inventory.empty():
				full_inventory_dialogue.hide()
				choose_item_dialogue.hide()
				live.block(DURATION_SHOWING_FULL_INVENTORY)
				yield(tools.create_physics_timer(DURATION_SHOWING_FULL_INVENTORY),"timeout")
				close()
		else:
				full_inventory_dialogue.hide()
				choose_item_dialogue.show()
				set_process_unhandled_input(true)
				item_list_4_item.set_process_input(true)
				item_list_4_item.close_button.grab_focus()


func open():
		if live.blocked:
			return false

		var item_list:NinePatchRect
		match stats.game_state.inventory_capacity:
				2:
						item_list = item_list_2_item
						item_list.show()
						item_list_4_item.hide()
				4: 
						item_list = item_list_4_item
						item_list.show()
						item_list_2_item.hide()
				_:assert(0)
		visible = true
		#pickup
		item_to_remove_from_world_upon_close = null
		var detected_items: Array = paths.player.get_detected_items()
		var items_to_swap := {}
		if not detected_items.empty(): #pickup
				detected_items.sort_custom(Item.new(),"item_comparision") #sort by priority
				var priority_item:Item = detected_items.back() 
				priority_item.get_picked_up()
				signals.emit_signal("picked_up_item",priority_item.name)
				if priority_item.goes_to_inventory:
						items_to_swap = stats.pick_up_item(priority_item)
						if items_to_swap.empty():
								item_to_remove_from_world_upon_close = priority_item
				else:
						close()
						return
		
		item_list.load_items()
		if stats.inventory.empty():
				full_inventory_dialogue.hide()
				choose_item_dialogue.hide()
				live.block(DURATION_SHOWING_FULL_INVENTORY)
				yield(tools.create_physics_timer(DURATION_SHOWING_FULL_INVENTORY),"timeout")
				close()
		elif !items_to_swap.empty():
				full_inventory_dialogue.show()
				choose_item_dialogue.hide()
				live.block(DURATION_SHOWING_FULL_INVENTORY)
				yield(tools.create_physics_timer(DURATION_SHOWING_FULL_INVENTORY),"timeout")
				var to_keep:Item = items_to_swap["to_keep"]
				to_keep.get_parent().remove_child(to_keep)
				drop_item_beneath_player(items_to_swap["to_drop"])
				close()
		else:
				full_inventory_dialogue.hide()
				choose_item_dialogue.show()
				set_process_unhandled_input(true)
				item_list.set_process_input(true)
				item_list.close_button.grab_focus()
		
		return true

func drop_item_beneath_player(item:Item):
		if item.get_parent():
				item.get_parent().remove_child(item)
		paths.map.room_node.add_child(item)
		item.position = (paths.player.position + Vector2(-8,8) - paths.map.position)
		item.snap_to_position()

func close():
		live.block()
		print("block 3")
		var item_list:NinePatchRect
		match stats.game_state.inventory_capacity:
				2:
						item_list = item_list_2_item
						item_list.show()
						item_list_4_item.hide()
				4: 
						item_list = item_list_4_item
						item_list.show()
						item_list_2_item.hide()
				_:assert(0)
		var selected_item:Item = item_list.get_selected_item()
		if selected_item: #drop or use item
				var item_used := false
				for interactable in paths.player.get_detected_interactables():
						if interactable.needed_item == selected_item.item_name:
								signals.emit_signal("dialogue_triggered",interactable.dialogue)
								item_used = true
								if interactable.consumes_item:
										stats.remove_item_from_inventory(selected_item)
								
				if not item_used and can_drop_items:
						print("drop item 1")
						selected_item.get_dropped()
						drop_item_beneath_player(selected_item)
						if selected_item == item_to_remove_from_world_upon_close:
								item_to_remove_from_world_upon_close = null
						stats.remove_item_from_inventory(selected_item)
				
		set_process_unhandled_input(false)
		visible = false
		item_list.set_process_input(false)
		if item_to_remove_from_world_upon_close:
				assert(item_to_remove_from_world_upon_close.get_parent())
				item_to_remove_from_world_upon_close.get_parent().remove_child(item_to_remove_from_world_upon_close)
		
		emit_signal("closed")


func _on_close_pressed():
		close()

func _on_inventory_popup_hide():
		selected_item_instance = null

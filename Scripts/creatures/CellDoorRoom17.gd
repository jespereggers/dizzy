extends Persistent

onready var interaction_area = $InteractionArea


func _on_InteractionArea_area_entered(area):
		if area is Player:
				if stats.inventory_has_item("a stainless key"):
						interaction_area.needed_item = "a stainless key"
						interaction_area.consumes_item = true
						interaction_area.dialogue = ["box:room_17/message_open_cell_door","wait","call:CellDoorRoom17:queue_free"]
				elif stats.inventory_has_item("a rusty key"):
						interaction_area.needed_item = "a rusty key"
						interaction_area.dialogue = ["box:room_17/message_wrong_cell_key","wait"]
						interaction_area.consumes_item = false
				else:
						interaction_area.needed_item = "invalid"
						interaction_area.dialogue = []


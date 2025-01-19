extends Persistent

onready var interaction_area = $InteractionArea

func _on_InteractionArea_area_entered(area):
		if area is Player:
				if stats.inventory_has_item("a sturdy crowbar"):
						interaction_area.needed_item = "a sturdy crowbar"
						interaction_area.dialogue = ["box:room_3/message_open_door","wait","call:StuckDoor:queue_free"]
				else:
						interaction_area.needed_item = ""
						interaction_area.dialogue = ["box:room_3/message_stuck_door","wait"]       

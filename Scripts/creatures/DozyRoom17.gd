extends Persistent

onready var interaction_area = $InteractionArea
onready var coin_given := false

var initial_dialogue_finished := false
func _ready():
		pass # Replace with function body.

func end_greeting():
		initial_dialogue_finished = true
		update_dialogue()

func wake_dozy():
		$dozy_sleep.visible = false
		$dozy_wake.visible = true
		
func let_dozy_sleep():
		$dozy_sleep.visible = true
		$dozy_wake.visible = false
		
func show_coin():
		$"../coin".position = Vector2(160,104)
		coin_given = true
		update_dialogue()

func update_dialogue():
		if coin_given:
				interaction_area.needed_item = ""
				interaction_area.dialogue = ["box:room_17/message_dozy_wake_up_end","wait"]
		elif stats.inventory_has_item("a bucket of water"):
				interaction_area.needed_item = "a bucket of water"
				interaction_area.dialogue = [
						"call:DozyRoom17:wake_dozy","box:room_17/message_dozy_awake_1","wait",
						"box:room_17/message_dozy_awake_2","wait",
						"box:room_17/message_dozy_awake_3","wait",
						"box:room_17/message_dozy_awake_4","wait",
						"box:room_17/message_dozy_awake_5","wait",
						"box:room_17/message_dozy_awake_6","wait",
						"box:room_17/message_dozy_awake_7","wait",
						"box:room_17/message_dozy_awake_8","wait",
						"call:DozyRoom17:let_dozy_sleep","call:DozyRoom17:show_coin"]
		else:
				interaction_area.needed_item = ""
				interaction_area.dialogue = ["box:room_17/message_dozy_wake_up","wait"]
				
						

func _on_InteractionArea_area_entered(area):
		if area is Player:
				if !initial_dialogue_finished:
						interaction_area.dialogue = ["box:room_17/message_dozy_wake","wait","box:room_17/message_dozy_wake_up","wait","call:DozyRoom17:end_greeting"]
				else:
						update_dialogue()
						

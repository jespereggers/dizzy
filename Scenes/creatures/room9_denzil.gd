extends Persistent

var state:String = "greeting"
onready var interaction_area = $InteractionArea
onready var denzil_sad = $denzil_sad
onready var denzil_happy = $denzil_happy


func end_greeting():
  state = "wait_for_headphone"
  update_wait_for_headphone_dialogue()
  
func receive_headphones():
  state = "headphone_received"
  denzil_sad.visible = false
  denzil_happy.visible = true
  interaction_area.needed_item = ""
  interaction_area.dialogue = [
    "box:room_9/message_denzil_after_1","wait",
    "box:room_9/message_denzil_after_2","wait",
    "box:room_9/message_denzil_after_3","wait",
    "box:room_9/message_denzil_after_4","wait",
    "clear",
    "call:room9_denzil:start_shake"
  ]
  
func start_shake():
  assert(signals.connect("shake_finished",self,"_on_shake_finished") == OK)
  paths.camera.call_deferred("shake")
  
func _on_shake_finished():
  signals.disconnect("shake_finished",self,"_on_shake_finished")
  signals.emit_signal("dialogue_triggered",
  [
    "box:room_9/message_strange_thing_1","wait",
    "box:room_9/message_strange_thing_2","wait",
    "box:room_9/message_strange_thing_3","wait",
    "box:room_9/message_strange_thing_4","wait",
    "box:room_9/message_strange_thing_5","wait",
    "box:room_9/message_strange_thing_6","wait",
    "box:room_9/message_strange_thing_7","wait",
    "box:room_9/message_strange_thing_8","wait",
    "call:room9_denzil:drop_strange_thing",
  ])
  
  
func drop_strange_thing():
  $"../item_mystical_artifact".position = Vector2(64,120)
  interaction_area.dialogue = ["box:room_9/message_denzil_ignore_you","wait"]

func update_wait_for_headphone_dialogue():
  if stats.inventory_has_item("dusty headphones"):
    interaction_area.needed_item = "dusty headphones"
    interaction_area.dialogue = [
      "box:room_9/message_denzil_found_1","wait",
      "box:room_9/message_denzil_found_2","wait",
      "box:room_9/message_denzil_found_3","wait",
      "box:room_9/message_denzil_found_4","wait",
      "call:room9_denzil:receive_headphones"]
  else:
    interaction_area.needed_item = ""
    interaction_area.dialogue = ["box:room_9/message_denzil_no_found","wait"]


func _on_InteractionArea_area_entered(area):
  if area is Player:
    if state == "wait_for_headphone":
      update_wait_for_headphone_dialogue() 
      


extends Persistent

func _on_Area2D_area_entered(area):
  if area is Player:
    signals.emit_signal("dialogue_triggered",[
      "box:room_11/message_granddizzy_warning",
      "wait",
      "call:GrandDizzy:let_dizzy_jump"
      ])

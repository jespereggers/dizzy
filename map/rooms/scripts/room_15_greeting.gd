extends Persistent

export var dialogue:PoolStringArray = ["box:room_15/greeting_1","wait","box:room_15/greeting_2","wait","box:room_15/greeting_3","wait"]

func _ready():
  assert(connect("area_entered",self,"_on_area_entered") == OK)

func _on_area_entered(area):
  if area.name == "player":
   signals.emit_signal("dialogue_triggered",dialogue)
   disconnect("area_entered",self,"_on_area_entered")
   queue_free()

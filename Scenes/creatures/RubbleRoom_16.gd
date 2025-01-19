extends Persistent
onready var shake_before = $shake_before
onready var shake_after = $shake_after
onready var item_rusty_key = $"../item_rusty_key"
onready var no_shake_zone = $"../NoShakeZone"

func _ready():
  signals.connect("shake_halftime",self,"_on_shake_halftime")
  
func collapse():
  shake_before.visible = false
  shake_before.collision_layer = 0
  shake_after.visible = true
  shake_after.collision_layer = 1

func _on_shake_halftime():
  collapse()
  item_rusty_key.visible
  no_shake_zone.queue_free()
  stats.game_state.shared_scene_data["room_16_rubble_collapsed"] = true
  

extends Persistent

export var dialogue:PoolStringArray = ["box:room_24/message_rockwart_caught_1","call:RockwartActivate:_turn_rockwart","wait","box:room_24/message_rockwart_caught_2","wait","box:room_24/message_rockwart_caught_3","wait"]

func _ready():
		assert(connect("area_entered",self,"_on_area_entered") == OK)

func _turn_rockwart():
		$"../Rockwart/Sprite".flip_h = not $"../Rockwart/Sprite".flip_h

func _on_area_entered(area):
		if area.name == "player":
				signals.emit_signal("dialogue_triggered",dialogue)
				disconnect("area_entered",self,"_on_area_entered")
				queue_free()

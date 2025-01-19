extends Persistent

export var dialogue:PoolStringArray = ["box:room_24/message_rockwart_1","wait","call:RockwartAnnoy:let_dizzy_jump"]

func _ready():
		assert(connect("area_entered",self,"_on_area_entered") == OK)

func _on_area_entered(area):
		if area.name == "player":
				signals.emit_signal("dialogue_triggered",dialogue)

func let_dizzy_jump():
#  if paths.player.is_on_floor():
#    print("is on floor")
#    paths.player.position.y -= 6
		paths.player.position.y -= 6
		paths.player.force_look_dir(1)
		
		paths.player.force_jump()
		paths.player.set_jump_frame_counter(1)
		paths.player.set_animation_frame(1)

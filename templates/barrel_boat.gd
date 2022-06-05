extends Sprite

export var room: int = 0


func _ready():
	print("GO")
	move_towards(data.clock.barrel_boat_state, data.clock.barrel_boat_target)
	data.clock.connect("barrel_state_changed", self, "move_towards")


func move_towards(dir: String, target_room: int):
	self.visible = (room == target_room)
	
	match dir:
		"left":
			$animator.play("swim_left_" + str(room))
		"right":
			$animator.play("swim_right_" + str(room))


func _on_player_detector_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name == "player":
		#pass
		paths.player.stick_to_boat = true

func _on_player_detector_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.name == "player":
		paths.player.stick_to_boat = false


func _on_barrel_boat_visibility_changed():
	if self.visible and not data.barrel_boat_placed:
		data.barrel_boat_placed = true
		data.clock.move_barrel_boat()

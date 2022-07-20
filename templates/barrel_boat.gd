extends Sprite

export var room: int = 0
var touches_player: bool = false


func _on_player_detector_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name != "player":
		return
	
	touches_player = true
	if visible:
		paths.player.automove = true


func _on_player_detector_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area.name != "player":
		return
		
	paths.player.automove = false
	touches_player = false


func _on_barrel_boat_visibility_changed():
	if visible and touches_player:
		paths.player.automove = true

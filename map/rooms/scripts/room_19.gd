extends Node2D

func _on_ResetDizzysDir_area_entered(area):
	if area is Player:
		(area as Player).force_look_dir(0,false)

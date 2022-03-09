extends Area2D

func _on_water_area_body_entered(body):
	if body.name == "player":
		stats.change_eggs_by(-1)

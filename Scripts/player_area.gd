extends Area2D

var colliding_area


func _on_area_area_entered(area):
	if area.name != "screen_area":
		colliding_area = area


func _on_area_area_exited(area):
	if area.name != "screen_area":
		colliding_area = null

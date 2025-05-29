class_name NoShakeZone
extends Area2D

func _ready():
	assert(connect("area_entered",self,"_on_NoShakeZone_area_entered") == OK)
	assert(connect("area_exited",self,"_on_NoShakeZone_area_exited") == OK)

func _on_NoShakeZone_area_entered(area):
	if area is Player:
		paths.camera.no_shake_zone = true


func _on_NoShakeZone_area_exited(area):
	if area is Player:
		paths.camera.no_shake_zone = false

extends Area2D

var findings: Array = []


func _on_interaction_detector_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if not area in findings:
		if area.name == "interaction_area":
			findings.append(area)


func _on_interaction_detector_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area in findings:
		findings.erase(area)

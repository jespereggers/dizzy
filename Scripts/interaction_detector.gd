extends Area2D

var interactables: Array = []

func _on_interaction_detector_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
  if not area in interactables:
    if area is InteractionArea:
      interactables.append(area)


func _on_interaction_detector_area_shape_exited(_area_rid, area, _area_shape_index, _local_shape_index):
  interactables.erase(area)
  

extends Area2D

var colliding_leaderboxes: Array 


func _on_leaderbox_detector_area_entered(area):

  if "leaderbox" in area.name:
    if not area in colliding_leaderboxes:
      colliding_leaderboxes.append(area)
      
    get_parent().is_on_leaderbox = true


func _on_leaderbox_detector_area_exited(area):
  if "leaderbox" in area.name:
    if not area in colliding_leaderboxes:
      colliding_leaderboxes.erase(area)
    
    if colliding_leaderboxes.empty():
      get_parent().is_on_leaderbox = false

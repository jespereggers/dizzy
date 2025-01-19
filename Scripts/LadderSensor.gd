extends Node2D
onready var next_to_ladder_sensor = $NextToLadderSensor
onready var above_ladder_sensor = $AboveLadderSensor

func is_next_to_ladder():
  return next_to_ladder_sensor.is_colliding()
  
func is_above_ladder():
  return above_ladder_sensor.is_colliding()

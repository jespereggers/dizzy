extends Node2D

onready var water_death = $water_death

func _ready():
		if stats.game_state.shared_scene_data.has("room_16_rubble_collapsed"):
				water_death.position.x = 600    

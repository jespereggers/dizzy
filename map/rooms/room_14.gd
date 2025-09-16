extends Node2D


func _ready():
	signals.connect("barrel_boat_disabled_changed", self, "_on_barrel_boat_disabled_changed")
		
	if stats.game_state.shared_scene_data.has("barrel_boat_disabled"):
		$barrel_boat.disabled = stats.game_state.shared_scene_data["barrel_boat_disabled"]


func _on_barrel_boat_disabled_changed():
	if $barrel_boat.disabled:
		$animations.play("disable_boat")
	else:
		$animations.play("move_boat")

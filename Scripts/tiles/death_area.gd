extends Area2D

export var colliding_object: String = ""


func _on_death_area_body_entered(body):
	if body.name == "player":
		signals.emit_signal("player_died", colliding_object)

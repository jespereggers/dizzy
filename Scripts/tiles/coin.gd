extends Sprite

var overlaping_with_player: bool = false
var properties: Dictionary = {}


func _input(_event):
	if Input.is_action_just_pressed("enter"):
		if overlaping_with_player:
			databank.game_save.enviroment[stats.current_map][stats.current_room].removed_items.append(name)
			signals.emit_signal("coin_collected", self)


func load_preset():
	pass


func _on_area_body_entered(body):
	if body.name == "player":
		overlaping_with_player = true


func _on_area_body_exited(body):
	if body.name == "player":
		overlaping_with_player = false

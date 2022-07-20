extends Node2D


func _ready():
	if signals.connect("object_got_shown", self, "_on_object_visibility_got_changed", [true]) != OK:
		print("Error")
	if signals.connect("object_got_hidden", self, "_on_object_visibility_got_changed", [false]) != OK:
		print("Error")
	
	# Show Shown Objects
	for object in data.game_save.enviroment[stats.current_map][stats.current_room].shown_objects:
		if self.has_node(object):
			self.get_node(object).show()
	# Hide Hidden Objects
	for object in data.game_save.enviroment[stats.current_map][stats.current_room].hidden_objects:
		if self.has_node(object):
			self.get_node(object).hide()
	
	if "barrel_boat" in data.game_save.enviroment[stats.current_map][Vector2(-1,0)].shown_objects:
		$barrel_boat/animator.play("move_14")
		$barrel_boat/animator.advance(25.0)
		$barrel_boat.show()


func switch_automove_dir(new_dir: int):
	paths.player.automove_dir = new_dir


func _on_object_visibility_got_changed(object_name: String, _room: Vector2, visible: bool):
	# Special Actions
	if visible and object_name == "barrel_boat":
		$barrel_boat/animator.play("move_14")

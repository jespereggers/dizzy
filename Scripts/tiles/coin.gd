extends Sprite

export var type: String = "coin"
export var item_name: String = "coin"
var overlaping_with_player: bool = false
var origin: String

var id: String


func _input(_event):
	if Input.is_action_just_pressed("enter"):
		pass
		#if overlaping_with_player:
			#data.game_save.enviroment[stats.current_map][stats.current_room].removed_objects.append(origin)
			#tools.remove_object(self)
			#signals.emit_signal("countable_collected", self)


func load_template():
	origin = self.name


func set_properties(properties: Dictionary):
	id = properties.id
	origin = properties.origin
	self.position = properties.position


func _on_area_body_entered(body):
	if body.name == "player":
		overlaping_with_player = true


func _on_area_body_exited(body):
	if body.name == "player":
		overlaping_with_player = false

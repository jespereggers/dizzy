extends KinematicBody2D
tool

export var item_name: String
export var color: Color = "ffffff"
export var collectable: bool = true
export var texture: Texture

var player_is_in_range: bool = false
var size: Vector2 = Vector2(10,10)


func _ready():
	self.modulate = color
	$texture.texture = texture
	size = $texture.texture.get_size()
	$area/collision.shape.extents = size


func reload_data():
	$texture.texture = texture
	size = $texture.texture.get_size()
	$area/collision.shape.extents = size


func load_template(new_item_name: String, new_collectable: bool, new_texture: Texture):
	$texture.texture = new_texture
	size = $texture.texture.get_size()
	$area/collision.shape.extents = size
	
	item_name = new_item_name
	collectable = new_collectable
	texture = new_texture


func _input(_event):
	if Input.is_action_just_released("enter") and player_is_in_range and paths.player.is_on_floor():
		signals.emit_signal("item_collected", self)


func _on_area_body_entered(body):
	if body.name == "player":
		paths.ui.locked = true
		player_is_in_range = true


func _on_area_body_exited(body):
	if body.name == "player":
		paths.ui.locked = false
		player_is_in_range = false

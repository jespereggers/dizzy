extends KinematicBody2D
tool

export var item_name: String
export var color: Color = "ffffff"
export var collectable: bool = true
export var texture: Texture
export var auto_radius: bool = true
export var shape_radius: int
export var auto_height: bool = true
export var height: float
var player_is_in_range: bool = false


func _ready():
	if auto_height == true:
		height = $texture.texture.get_size().y - 2
		
	if auto_radius == true:
		shape_radius = $texture.texture.get_size().y * 0.8
		
	if shape_radius != 0 and $area/collision.shape.get_class() == "CircleShape2D":
		$area/collision.shape.radius = shape_radius
	
	self.modulate = color
	$texture.texture = texture


func _input(_event):
	if Input.is_action_just_released("enter") and player_is_in_range and paths.player.is_on_floor() and collectable:
		signals.emit_signal("item_collected", self)


func _on_area_area_entered(area):
	if area.name == "item_detector":
		paths.ui.locked = true
		player_is_in_range = true


func _on_area_area_exited(area):
	if area.name == "item_detector":
		paths.ui.locked = false
		player_is_in_range = false

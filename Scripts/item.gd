extends KinematicBody2D
tool

var player_is_in_range: bool = false
var used: bool = true
var origin: String
# Relevant to the Saving-System
const type = "item"
var id: String 
export var item_name: String
export var color: Color = "ffffff"
export var shape_extents: Vector2
export var height: float
export var collectable: bool = true
export var texture : Texture


func _ready():
	$sprite.texture = texture


func load_template():
	self.modulate = color
	
	for child in get_children():
		child.queue_free()
	
	var area: Area2D = Area2D.new()
	area.name = "area"
	var collision: CollisionShape2D = CollisionShape2D.new()
	collision.name = "collision"
	collision.shape = RectangleShape2D.new()
	collision.shape.extents = shape_extents
	self.add_child(area)
	area.add_child(collision)
	
	area.connect("area_entered", self, "_on_area_entered")
	area.connect("area_exited", self, "_on_area_exited")

	# Texture
	var sprite: Sprite = Sprite.new()
	sprite.name = "sprite"
	sprite.texture = texture
	self.add_child(sprite)


func set_properties(properties: Dictionary):
	id = properties.id
	origin = properties.origin
	item_name = properties.item_name
	color = properties.color
	shape_extents = properties.shape_extents
	height = properties.height
	collectable = properties.collectable
	texture = properties.texture
	
	self.position = properties.position
	self.position.y += (self.height/2)
	self.modulate = properties.color


func _input(_event):
	if Input.is_action_just_released("enter") and player_is_in_range and paths.player.is_on_floor() and collectable:
		signals.emit_signal("item_collected", self)


func _on_area_entered(area):
	if area.name == "item_detector":
		paths.ui.locked = true
		player_is_in_range = true


func _on_area_exited(area):
	if area.name == "item_detector":
		paths.ui.locked = false
		player_is_in_range = false


func build():
	update_pos()
	paths.map.add(self)
	tools.add_object(self)
	
	for object in stats.inventory.size():
		if stats.inventory[object] == tools.get_object_properties(self):
			stats.inventory.remove(object)
			break


func destroy():
	if stats.inventory.size() < 3:
		if not used:
			databank.game_save.enviroment[stats.current_map][stats.current_room].removed_objects.append(origin)
		tools.remove_object(self)
		paths.map.remove(self)
		stats.inventory.append(tools.get_object_properties(self))


func update_pos():
	self.position = paths.player.position
	self.position -= Vector2(8, 49)
	self.position.y += paths.player.get_height()
	self.position.y -= (self.height/2)

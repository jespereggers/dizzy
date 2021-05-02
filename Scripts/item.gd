extends KinematicBody2D
tool

var unused: bool = true
var player_is_in_range: bool = false
var properties: Dictionary

# Relevant to the Saving-System
var type: String = "collectable_item"
export var item_name: String
var id: String 
export var color: Color = "ffffff"
var shape: Shape2D
export var collectable: bool = true
export var texture : StreamTexture
export var shape_radius: int
export var height: float


signal finished_loading_preset()

func load_preset():
	id = self.name
	self.modulate = color
	get_node("texture").texture = texture
	
	if shape_radius != 0 and $area/collision.shape.get_class() == "CircleShape2D":
		$area/collision.shape.radius = shape_radius
	
	properties = tools.get_collectable_item_properties(self)
	emit_signal("finished_loading_preset")


func load_template(_new_type: String, new_id: String, new_item_name: String, new_pos: Vector2, new_height: float, new_color: Color, new_collectable: bool, new_texture: Texture, new_shape: Shape2D):
	id = new_id
	self.name = new_id
	item_name = new_item_name
	self.position = new_pos
	color = new_color
	self.modulate = color
	shape = new_shape
	height = new_height
	collectable = new_collectable
	texture = new_texture
	$texture.texture = texture
	$area/collision.shape = new_shape
	
	properties = tools.get_collectable_item_properties(self)


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


func build():
	unused = false
	update_pos()
	paths.map.add_tile(self)
	tools.add_item_to_game_save(self.duplicate())
	$texture.texture = self.texture
	for item in stats.inventory.size():
		if stats.inventory[item] == self:
			stats.inventory.remove(item)
			break


func destroy():
	if unused:
		unused = false
		databank.game_save.enviroment[stats.current_map][stats.current_room].removed_items.append(name)
		name = str(randi())
	else:
		tools.remove_item_from_game_save(self.duplicate())

	if stats.inventory.size() < 3:
		paths.map.remove_tile(self)
		stats.inventory.append(self.duplicate()) # DUPLICATE??


func update_pos():
	self.position = paths.player.position
	self.position -= Vector2(8, 49)
	self.position.y += paths.player.get_height()
	self.position.y -= (self.height/2)

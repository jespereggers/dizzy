class_name Item
extends Area2D

onready var collision_shape:CollisionShape2D = $CollisionShape2D as CollisionShape2D

export var item_name := "Item"
export var item_priority := 0

func _enter_tree():
	snap_to_position(position)
	ItemCollision.new_item(self)

func _exit_tree():
	ItemCollision.delete_item(self)

func snap_to_position(new_position:Vector2):
	var snapped_position = new_position.snapped(Vector2(8,8))
	if snapped_position.x > new_position.x:
		snapped_position.x -= 8
	position = snapped_position


func get_picked_up():
	get_parent().remove_child(self)
	var item_pushed_out_of_inventory = stats.add_item_to_inventory(self)
	if item_pushed_out_of_inventory:
		item_pushed_out_of_inventory.drop_beneath_player()
		paths.ui.inventory.trying_to_hold_too_much = true
	paths.ui.inventory.open()

func get_dropped():
	drop_beneath_player()

func drop_beneath_player():
	assert(get_parent() == null)
	paths.map.room_node.add_child(self)
	snap_to_position(paths.player.position + Vector2(-8,8) - paths.map.position)
func item_comparision(a:Item,b:Item):
	return a.item_priority < b.item_priority

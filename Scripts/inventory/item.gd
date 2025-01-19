class_name Item
extends Persistent

onready var collision_shape:CollisionShape2D = $CollisionShape2D as CollisionShape2D

export var item_name := "Item"
export var item_priority := 0
export var goes_to_inventory := true
export var collision_layer := 7

func _ready():
		properties_to_save = ["name","position","item_priority","item_name","visible"]
		collision_layer = 7

func _enter_tree():
		ItemCollision.new_item(self)

func _exit_tree():
		ItemCollision.delete_item(self)

func snap_to_position():
		var snapped_position = position.snapped(Vector2(8,8))
		if snapped_position.x > position.x:
				snapped_position.x -= 8
		#special treatment for the table in room 6
		if stats.game_state.current_room == Vector2(0,2):
				if snapped_position.y == 96 or snapped_position.y == 104:
						snapped_position.y = 100
		position = snapped_position

		

func get_picked_up():
		pass
		
func get_dropped():
		pass
		
func item_comparision(a:Item,b:Item):
		return a.item_priority < b.item_priority

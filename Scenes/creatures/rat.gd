extends Persistent

onready var rat = $rat
onready var ray_cast_2d = $rat/RayCast2D

var dir := -1 setget set_dir
var speed := 4
var turning_points := []
var fleeing := false
var flee_dir := 0
var heading_for_food := false
func set_dir(new_dir:int):
		dir = new_dir
		if new_dir != 0:
				rat.flip_h = (dir == -1)

var apple_bounds := []

func _ready():
		for child in get_children():
				if child is Position2D:
						turning_points.append(int(child.position.x))
		turning_points.sort()

func _physics_process(_delta):
		if rat.position.x >= 500 or rat.position.x < -100:
				queue_free()
		if fleeing:
				self.dir = flee_dir

		for step in speed:
				#hit food or player -> stop
				ray_cast_2d.cast_to.x = abs(ray_cast_2d.cast_to.x)*dir
				ray_cast_2d.force_raycast_update()
				#stop at apple
				if heading_for_food and int(rat.global_position.x) in apple_bounds:
						break
						
				#stop at player
				if ray_cast_2d.is_colliding():
						var collider = ray_cast_2d.get_collider()
						if collider is Player:
								break
				
				#turn at turning_point
				if not (heading_for_food or fleeing):  #walking randomly
						var turning_point_index = turning_points.find(int(rat.position.x))
						if turning_point_index != -1:
								var is_first_or_last_turning_point = turning_point_index == 0 or turning_point_index == turning_points.size()-1
								if is_first_or_last_turning_point: 
										self.dir *= -1
								else:
										if tools.rng.randi()%2:
												self.dir *= -1
														
				rat.position.x += dir
				
func _on_FoodDetector_area_entered(area):
		if area is Item:
				if area.item_name == "a bitten apple":
						signals.emit_signal("dialogue_triggered",["box:room_6/message_rat_feeding","wait"])
						print(paths.player.position.x - $rat.position.x)
						print(rat.position.x)
						print(paths.player.position.x)
						flee_dir = sign($rat.position.x - paths.player.position.x)
						dir = 0 #stop
						fleeing = true
						area.queue_free()
						$rat/rat_death.queue_free()


func _on_smell_food_area_area_entered(area):
		if area is Item:
				if area.item_name == "a bitten apple":
						self.dir = int(sign(area.global_position.x - rat.global_position.x))
						apple_bounds = [
								int(area.global_position.x + 16 +15),
								int(area.global_position.x -15)
							]
						heading_for_food = true


func _on_smell_food_area_area_exited(area):
		if area is Item:
				if area.item_name == "a bitten apple":
						heading_for_food = false

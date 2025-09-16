class_name NoSpawnArea
extends Area2D

var shape_of_no_spawn:CollisionShape2D

func _ready():
	for child in get_children():
		if child is CollisionShape2D:
			shape_of_no_spawn = child

func _enter_tree():
  NoSpawnAreas.new_no_spawn_area(self)

func _exit_tree():
  NoSpawnAreas.delete_no_spawn_area(self)

# replaced with above workaround, see Scripts/global_scripts/death_areas.gd

#	if self.connect("area_entered",self,"_on_death_area_area_entered") != OK:
#		push_error("failed to etablish connection")
#
#func _on_death_area_area_entered(area):
#	print("entered")
#	if area.has_method("kill"):
#		area.die(cause_of_death)


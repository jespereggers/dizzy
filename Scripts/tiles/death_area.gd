class_name DeathArea
extends Area2D

onready var shape_of_death = $shape_of_death

export var cause_of_death: String = ""

func _enter_tree():
  DeathAreas.new_death_area(self)

func _exit_tree():
  DeathAreas.delete_death_area(self)

# replaced with above workaround, see Scripts/global_scripts/death_areas.gd

#	if self.connect("area_entered",self,"_on_death_area_area_entered") != OK:
#		push_error("failed to etablish connection")
#
#func _on_death_area_area_entered(area):
#	print("entered")
#	if area.has_method("kill"):
#		area.die(cause_of_death)


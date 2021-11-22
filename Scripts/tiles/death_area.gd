extends Area2D

export var colliding_object: String = ""

func _ready():
	if self.connect("area_entered",self,"_on_death_area_area_entered") != OK:
		push_error("failed to etablish connection")

func _on_death_area_area_entered(area):
	if area.has_method("kill"):
		area.kill(colliding_object)
		
		

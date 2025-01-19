class_name NoItemDropZone
extends Area2D

func _ready():
		connect("area_entered",self,"_on_NoItemDropZone_area_entered")
		connect("area_exited",self,"_on_NoItemDropZone_area_exited")

func _on_NoItemDropZone_area_entered(area):
		if area is Player:
			paths.ui.inventory.can_drop_items = false


func _on_NoItemDropZone_area_exited(area):
		if area is Player:
			paths.ui.inventory.can_drop_items = true

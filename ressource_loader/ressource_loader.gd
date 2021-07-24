extends Node


func _ready():
	for child in get_children():
		child.import_res()

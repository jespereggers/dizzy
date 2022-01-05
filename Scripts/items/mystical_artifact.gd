extends Item


func get_dropped():
	paths.camera.shake()
	drop_beneath_player()

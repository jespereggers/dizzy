extends Node


func enter():
	paths.player.animations.play("walk")
	
	
func _on_animation_finished():
	pass

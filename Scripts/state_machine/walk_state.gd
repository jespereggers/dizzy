extends Node


func enter():
	stats.player.animations.play("walk")
	
	
func _on_animation_finished():
	pass

extends Node


func enter():
	paths.player.animations.play("idle")
	
	
func _on_animation_finished():
	pass

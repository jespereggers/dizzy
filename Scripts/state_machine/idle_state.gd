extends Node

onready var player: KinematicBody2D = get_parent().get_parent()


func enter():
	player.animation.play("idle")
	
	
func _on_animation_finished():
	pass

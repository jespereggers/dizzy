extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.func _ready():
func _ready():
	$rat_animation.play("walk")

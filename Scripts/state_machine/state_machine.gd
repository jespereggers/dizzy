extends Node

onready var player: KinematicBody2D = get_parent()
onready var states: Dictionary = {
	"idle": get_node("idle_state"),
	"walk": get_node("walk_state"),
	"jump": get_node("jump_state"),
	"salto": get_node("salto_state"),
	"climb": get_node("climb_state")
}
var state: String = "idle"


func update_state(new_state: String):
	if player.locked:
		return
	
	state = new_state
	
	for state in states:
		player.get_node(state + "_collision").disabled = (state != new_state)
	
	states[new_state].enter()


func _on_animation_animation_finished(anim_name):
	update_state("idle")
	#print("Try")
	#if get_parent().is_on_floor() or get_parent().can_autojump(false):
		#print(get_parent().can_autojump(false))
	#	print("Switch")
	#	update_state("idle")

	if anim_name in states.keys():
		states[anim_name]._on_animation_finished()

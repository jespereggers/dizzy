class_name PhysicsTimer
extends Node

signal timeout

export(float) var wait_time: float = 1.0
export(bool) var one_shot: bool = true
export(bool) var autostart: bool = false

var timer_elapsed: float = 0.0
var timer_active: bool = false

func _ready():
				pause_mode = Node.PAUSE_MODE_PROCESS
				if autostart:
								start()
				connect("timeout",self,"_on_timeout")
				connect("tree_exiting",self,"_on_tree_exited")

func _on_timeout():
	pass	
	#print("PhysicsTimer "+str(name)+" "+str(wait_time)+"s finished.")

func _on_tree_exited():
	pass
	#print("PhysicsTimer "+str(name)+" "+str(wait_time)+"s exited tree.")


func start(time: float = -1.0):
				if time > 0:
								wait_time = time
				timer_elapsed = 0.0
				timer_active = true
				#print("PhysicsTimer "+str(name)+" "+str(wait_time)+"s started.")

func stop():
				timer_active = false

func is_active() -> bool:
				return timer_active

func _physics_process(delta: float) -> void:
				if timer_active:
								timer_elapsed += delta
								if timer_elapsed >= wait_time:
												timer_active = false
												emit_signal("timeout")
												if not one_shot:
																start()  # Restart the timer if it's not one-shot

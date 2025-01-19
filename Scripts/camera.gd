extends Camera2D

onready var animation_player = $AnimationPlayer

export var max_displacement:int
export var x_weight := 1
export var y_weight := 1
export var diagonal_weight := 3

var no_shake_zone := false

func randi_range(min_val:int,max_val:int) -> int:
		return tools.rng.randi() % (max_val - min_val + 1) + min_val

func apply_random_offset():
		var weight_sum := x_weight + y_weight + diagonal_weight
		var val = tools.rng.randi_range(1,weight_sum)
		if val <= x_weight:
				offset.x = tools.rng.randi_range(-max_displacement,max_displacement)
		elif val <= x_weight + y_weight:
				offset.y = tools.rng.randi_range(-max_displacement,max_displacement)
		elif val <= x_weight + y_weight + diagonal_weight:
				offset.x = tools.rng.randi_range(-max_displacement,max_displacement)
				offset.y = tools.rng.randi_range(-max_displacement,max_displacement)

func shake():
		animation_player.play("shake")

func _physics_process(_delta):
		if animation_player.is_playing():
				assert(animation_player.current_animation == "shake")
				apply_random_offset()

func _on_AnimationPlayer_animation_finished(anim_name):
		assert(anim_name == "shake")
		paths.player.script_locked = false
		paths.player.visible = true
		offset = Vector2(0,0)
		
		signals.emit_signal("shake_finished") 


func _on_AnimationPlayer_animation_started(anim_name):
		assert(anim_name == "shake")
		paths.player.script_locked = true
		paths.player.visible = false
		signals.emit_signal("shake_started")
		yield(tools.create_physics_timer(animation_player.get_animation("shake").length/2),"timeout")
		signals.emit_signal("shake_halftime")

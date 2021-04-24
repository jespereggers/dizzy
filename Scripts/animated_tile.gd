extends Sprite

export var fps: int = 4


func _ready():
	# Connect signals
	signals.connect("pause_mode_changed_to", self, "_on_pause_mode_changed_to")
	
	# Setup animation
	var idle_animation: Animation = Animation.new()
	var max_frame: int = hframes * vframes
	idle_animation.length = float(str(max_frame)) / float(fps)
	idle_animation.step = 1.0 / fps
	idle_animation.loop = true
	
	var anim_key: int = idle_animation.add_track(Animation.TYPE_BEZIER, -1)
	idle_animation.track_set_path(anim_key, ":frame")

	idle_animation.bezier_track_insert_key(anim_key, 0.0, 0)
	#$animation_player.get_animation("idle").bezier_track_insert_key(anim_key, 1.0 / float(fps) * (max_frame - 1), 3)
	idle_animation.bezier_track_insert_key(anim_key, (1.0 / fps) * (max_frame - 1), max_frame - 1)
	
	# Start animation
	$animation_player.add_animation("idle", idle_animation)
	get_node("animation_player").play("idle")
	

func _on_pause_mode_changed_to(paused: bool):
	if paused:
		$animation_player.stop()
	else:
		$animation_player.play("idle")

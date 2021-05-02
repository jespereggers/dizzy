extends Sprite

export var fps: int = 4


func _ready():
	# Connect signals
	signals.connect("pause_mode_changed_to", self, "_on_pause_mode_changed_to")
	
	# Setup animation
	var max_frame: int = hframes * vframes
	$animation_player.get_animation("idle").length = float(str(max_frame)) / float(fps)
	$animation_player.get_animation("idle").step = 1.0 / fps
	$animation_player.get_animation("idle").loop = true
	
	var anim_key: int = $animation_player.get_animation("idle").add_track(Animation.TYPE_BEZIER, -1)
	$animation_player.get_animation("idle").track_set_path(anim_key, ":frame")

	$animation_player.get_animation("idle").bezier_track_insert_key(anim_key, 0.0, 0)
	#$animation_player.get_animation("idle").bezier_track_insert_key(anim_key, 1.0 / float(fps) * (max_frame - 1), 3)
	$animation_player.get_animation("idle").bezier_track_insert_key(anim_key, (1.0 / fps) * (max_frame - 1), max_frame - 1)
	
	# Start animation
	get_node("animation_player").play("idle")
	

func _on_pause_mode_changed_to(paused: bool):
	if paused:
		$animation_player.stop()
	else:
		$animation_player.play("idle")

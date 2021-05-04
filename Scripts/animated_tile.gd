extends Sprite

var anim_player: AnimationPlayer
export var fps: int = 4


func _ready():
	# Connect signals
	signals.connect("pause_mode_changed_to", self, "_on_pause_mode_changed_to")

	# Setup animation
	var animation: Animation = Animation.new()
	
	var max_frame: int = hframes * vframes
	animation.length = float(str(max_frame)) / float(fps)
	animation.step = 1.0 / fps
	animation.loop = true
	
	var anim_key: int = animation.add_track(Animation.TYPE_BEZIER, -1)
	animation.track_set_path(anim_key, ":frame")

	animation.bezier_track_insert_key(anim_key, 0.0, 0)
	animation.bezier_track_insert_key(anim_key, (1.0 / fps) * (max_frame - 1), max_frame - 1)
	
	# Acutally add the animation
	anim_player = AnimationPlayer.new()
	anim_player.add_animation("idle", animation)
	
	self.add_child(anim_player)
	
	# Start animation
	anim_player.play("idle")
	

func _on_pause_mode_changed_to(paused: bool):
	if paused:
		anim_player.stop()
	else:
		anim_player.play("idle")

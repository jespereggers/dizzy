extends Persistent

onready var animation_player = $AnimationPlayer

func _ready():
		signals.connect("shake_started",self,"_on_shake_started")

func _on_shake_started():
		if not stats.game_state.shared_scene_data.has("room_10_coin_dropped"):
				animation_player.play("drop")
				stats.game_state.shared_scene_data["room_10_coin_dropped"] = true

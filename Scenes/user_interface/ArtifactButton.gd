extends TextureButton

export var cooldown := 88.0
var timer:PhysicsTimer
var reload_countdown = 10

var disabled_texture := preload("res://Assets/tiles/menu/artifact/artifact_off.png")
var loading_textures := []
var enabled_texture := preload("res://Assets/tiles/menu/artifact/artifact_on.png")

func _ready() -> void:
		loading_textures.resize(11)
		for i in range(0,10):
				loading_textures[i] = load("res://Assets/tiles/menu/artifact/artifact_load_" + str(i+1) + ".png")
		texture_normal = enabled_texture

func disable_and_start_cooldown():
		texture_normal = disabled_texture
		var step_cooldown := cooldown/11.0

		while reload_countdown > 0:
				yield(tools.create_physics_timer(step_cooldown),"timeout")  
				if get_parent().get_node("dialogue_system").visible_boxes == []:
					texture_normal = loading_textures[10-reload_countdown]
					reload_countdown -= 1
				elif not "artifact" in get_parent().get_node("dialogue_system").visible_boxes[0].name:
					texture_normal = loading_textures[10-reload_countdown]
					reload_countdown -= 1
		
		reload_countdown = 10
		
		yield(tools.create_physics_timer(step_cooldown),"timeout")
		texture_normal = enabled_texture

func _input(event):
	if event.is_action_pressed("activate_artifact"):
		_on_ArtifactButton_pressed()

func _on_ArtifactButton_pressed():
		if not paths.player.can_interact():
				return
		live.block()
		
		if texture_normal != enabled_texture:
				signals.emit_signal("dialogue_triggered",["box:artifact_dialog_off","wait"])
		else:
				# Starts Shaking
				if !paths.camera.no_shake_zone:
						paths.camera.shake()
						yield(signals,"shake_finished")
						disable_and_start_cooldown()
				else:
						signals.emit_signal("dialogue_triggered",["box:room_16/message_artifact_no_shake","wait"])

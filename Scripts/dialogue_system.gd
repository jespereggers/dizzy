extends Control

var input_block: bool = true
var running: bool = false
var dialogues: Dictionary = {
	"coin": ["box:found_coin", "wait", "end"],
	"shard": ["box:found_shard", "wait", "end"],
	"water_death": ["box:death_dialog_water", "timer:10", "respawn"],
	"torchfire_death": ["box:death_dialog_torch", "timer:10", "respawn"],
	"rat_death": ["box:death_dialog_rat", "timer:10", "respawn"],
	"bat_death": ["box:death_dialog_bat", "timer:10", "respawn"],
	"spikes_death": ["box:death_dialog_spikes", "timer:10", "respawn"],
	"barrel_triggered": ["box:message_barrel", "wait", "end"]
}

signal dialogue_accepted()


func _ready():
	signals.connect("countable_collected", self, "_on_countable_collected")
	signals.connect("player_died", self, "_on_player_died")
	

func _on_countable_collected(item: String = ""):
	if item in ["coin", "shard"]:
		play(item)


func _on_player_died(by: String = ""):
	if by in ["water", "torchfire", "rat", "bat", "spikes"]:
		play(by + "_death")


func play(event: String = ""):
	print("Play ", event)
	if not event in dialogues:
		return
	
	start()
	
	for phase in dialogues[event]:
		yield(perform_action(phase), "completed")
		
	end(event)


func play_custom(procedure: PoolStringArray):
	start()
	
	for step in procedure:
		yield(perform_action(step), "completed")
		
	end()


func perform_action(action: String):
	yield(get_tree(), "idle_frame")
	
	match action.rsplit(":")[0]:
		"box":
			print(action.rsplit(":")[1] + "_" + TranslationServer.get_locale())
			if self.has_node(action.rsplit(":")[1] + "_" + TranslationServer.get_locale()):
				# Success
				var dialogue_box: Popup = get_node(action.rsplit(":")[1] + "_" + TranslationServer.get_locale())
				dialogue_box.popup()
			else:
				# Warning
				print("Unable to Access " + action.rsplit(":")[1] + "_" + TranslationServer.get_locale())
		"timer":
			yield(get_tree().create_timer(float(int(action.rsplit(":")[1]))), "timeout")
		"wait":
			input_block = false
			yield(self, "dialogue_accepted")
			input_block = true
		"show":
			var node_name: String = action.rsplit(":")[1]
			if paths.map.room_node.has_node(node_name):
				paths.map.room_node.get_node(node_name).show()
				# Store Shown Object
				if not node_name in data.game_save.enviroment[stats.current_map][stats.current_room].shown_objects:
					data.game_save.enviroment[stats.current_map][stats.current_room].shown_objects.append(node_name)
					data.game_save.enviroment[stats.current_map][stats.current_room].hidden_objects.erase(node_name)
					signals.emit_signal("object_got_shown", node_name, stats.current_room)
		"hide":
			var node_name: String = action.rsplit(":")[1]
			if paths.map.room_node.has_node(node_name):
				paths.map.room_node.get_node(node_name).hide()
				# Store Hidden Object
				if not node_name in data.game_save.enviroment[stats.current_map][stats.current_room].hidden_objects:
					data.game_save.enviroment[stats.current_map][stats.current_room].hidden_objects.append(node_name)
					data.game_save.enviroment[stats.current_map][stats.current_room].shown_objects.erase(node_name)
					signals.emit_signal("object_got_hidden", node_name, stats.current_room)
	
		"move_player":
			var pos: Vector2
			pos.x = float(action.rsplit(":")[1].rsplit(",")[0])
			pos.y = float(action.rsplit(":")[1].rsplit(",")[1])
			paths.player.position = pos
		"respawn":
			respawn()


func start():
	running = true
	get_tree().paused = true
	get_parent().locked = true
	signals.emit_signal("pause_mode_changed_to", true)
	paths.player.hide()
	
	# Puffer
	set_process(false)
	yield(get_tree().create_timer(0.2), "timeout")
	set_process(true)


func end(event: String = ""):
	for box in self.get_children():
			box.hide()
			
	get_tree().paused = false
	get_parent().locked = false
	paths.player.show()
	running = false
	
	match event:
		"coin":
			stats.coins += 1
			signals.emit_signal("coins_changed")
		"shard":
			stats.shards += 1
			signals.emit_signal("shards_changed")

	audio.play("theme")


func respawn():
	if stats.eggs <= 0:
		# Game Over! Back to title.
		if get_tree().change_scene("res://Scenes/titlescreen.tscn") != OK:
				print("Error occured when trying to switch to tiltelscreen")
	else:
		if not stats.infinite_eggs:
			stats.eggs -=1
	
	if paths.player.respawn_room != stats.current_room:
		paths.map.change_room(paths.player.respawn_room) # A dead player respawns on signal 'map_loaded'
	
	yield(get_tree().create_timer(0.4), "timeout")
	paths.player.respawn()
	
	running = false
	get_tree().paused = false
	get_parent().locked = false
	signals.emit_signal("pause_mode_changed_to", false)
	paths.player.show()


func _process(_delta):
	if input_block:
		return
	if Input.is_action_just_released("select"):
		emit_signal("dialogue_accepted")
		yield(get_tree().create_timer(0.2), "timeout")

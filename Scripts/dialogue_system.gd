extends Control

var input_block: bool = true
var running: bool = false
var dialogues: Dictionary = {
	"coin": ["box:found_coin", "wait", "end"],
	"shard": ["box:found_shard", "wait", "end"],
	"water_death": ["box:death_dialog_water", "timer:9", "respawn"],
	"torchfire_death": ["box:death_dialog_torch", "timer:3", "end"],
	"rat_death": ["box:death_dialog_rat", "timer:3", "end"],
	"bat_death": ["box:death_dialog_bat", "timer:3", "end"],
	"spikes_death": ["box:death_dialog_spikes", "timer:3", "end"]
}

signal dialogue_accepted()


func _ready():
	signals.connect("countable_collected", self, "_on_countable_collected")
	signals.connect("player_died", self, "_on_player_died")
	

func _on_countable_collected(item: String = ""):
	if item in ["coin", "shard"]:
		play(item)


func _on_player_died(by: String = ""):
	if by in ["water", "torchfire", "rat", "spikes"]:
		play(by + "_death")


func play(event: String = ""):
	print(event)
	if not event in dialogues:
		return
	
	start()
	
	for phase in dialogues[event]:
		print(phase)
		match phase.rsplit(":")[0]:
			"box":
				print(phase.rsplit(":")[1] + "_" + TranslationServer.get_locale())
				if self.has_node(phase.rsplit(":")[1] + "_" + TranslationServer.get_locale()):
					# Success
					var dialogue_box: Popup = get_node(phase.rsplit(":")[1] + "_" + TranslationServer.get_locale())
					dialogue_box.popup()
				else:
					# Warning
					print("Unable to Access " + phase.rsplit(":")[1] + "_" + TranslationServer.get_locale())
			"timer":
				yield(get_tree().create_timer(float(int(phase.rsplit(":")[1]))), "timeout")
			"wait":
				input_block = false
				yield(self, "dialogue_accepted")
				input_block = true
			"respawn":
				respawn()
				
	end(event)


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

extends Node

signal recorder_started
signal recorder_stopped
signal replay_started
signal replay_stopped

var record_frame:int = 0
var recorded_events:Dictionary = {}

var recorded_player_states:Dictionary = {}

var replay_frame:int = 0
var is_replaying:bool = false
var is_recording:bool = false

var ghost:Sprite

var savegame:SaveGame
var save_dialog: WindowDialog
var line_edit: LineEdit

var load_dialog: WindowDialog
var load_list : ItemList
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	assert(signals.connect("game_started",self,"_on_game_started")==OK)
	
	save_dialog = WindowDialog.new()
	save_dialog.set_title("Enter Save Name")
	save_dialog.set_resizable(false)
	save_dialog.rect_min_size = Vector2(200, 75)
	
	#save dialog
	var vbox := VBoxContainer.new()
	save_dialog.add_child(vbox)
	line_edit = LineEdit.new()
	line_edit.rect_min_size = Vector2(180, 0)
	line_edit.set_placeholder("Enter filename...")
	vbox.add_child(line_edit)

	
	var save_button := Button.new()
	save_button.text = "Save"
	save_button.connect("pressed", self, "_on_SaveButton_pressed")
	vbox.add_child(save_button)
	
	add_child(save_dialog)
	#load_diag
	load_dialog = WindowDialog.new()
	
	load_dialog.set_title("Select Savegame")
	load_dialog.rect_min_size = Vector2(200, 100)
	
	var scroll_container := ScrollContainer.new()
	scroll_container.rect_min_size = Vector2(200, 100)
	load_dialog.add_child(scroll_container)
	
	load_list = ItemList.new()
	load_list.rect_min_size = Vector2(197, 100)
	load_list.connect("item_selected",self,"_on_load_list_item_selected")
	scroll_container.add_child(load_list)
	add_child(load_dialog)

func _physics_process(delta):
	record_frame += 1
	if is_recording:
		recorded_player_states[record_frame] = (serialize_player_state())
	if is_replaying:
		replay_events()
		replay_frame+=1
		
func _input(event:InputEvent):
	if !is_recording:
		if event.is_action("load_replay") and event.is_pressed():
				if is_replaying:
					stop_replay()
				load_list.clear()
				var dir = Directory.new()
				if dir.open("res://replays") == OK:
					dir.list_dir_begin()
					var file_name = dir.get_next()
					while file_name != "":
						if file_name.ends_with(".tres"):
								load_list.add_item(file_name)
						file_name = dir.get_next()
					dir.list_dir_end()
					load_dialog.popup_centered()
	if !is_replaying:
		if event.is_action("start_stop_recorder") and event.is_pressed():
			if is_recording:
				stop_recorder()
			else:
				start_recorder()
	if is_recording:
		if is_any_action(event,["start_stop_recorder","start_stop_recorder"]):
			if not recorded_events.has(record_frame):
				recorded_events[record_frame] = []
			recorded_events[record_frame].append(serialize_event(event))

func get_action_from_event(event:InputEvent):
	for action in InputMap.get_actions():
		if InputMap.event_is_action(event, action):
			return action
	return ""
	
func is_any_action(event:InputEvent,except:Array=[]) -> bool:
	for action in InputMap.get_actions():
		if InputMap.event_is_action(event, action) and !(action in except):
			return true
	return false

func serialize_event(event:InputEvent) -> Dictionary:
	var serialized_event = {}
	if event is InputEventKey:
		serialized_event = {
			"type": "key",
			"scancode": event.scancode,
			"pressed": event.pressed
		}
	elif event is InputEventMouseButton:
		serialized_event = {
			"type": "mouse_button",
			"button_index": event.button_index,
			"pressed": event.pressed,
			"position": event.position
		}
	elif event is InputEventMouseMotion:
		serialized_event = {
			"type": "mouse_motion",
			"position": event.position,
			"relative": event.relative,
			"speed": event.speed
		}
	elif event is InputEventJoypadButton:
		serialized_event = {
			"type": "joypad_button",
			"button_index": event.button_index,
			"pressed": event.pressed
		}
	elif event is InputEventJoypadMotion:
		serialized_event = {
			"type": "joypad_motion",
			"axis": event.axis,
			"value": event.value
		}
	return serialized_event
	
func deserialize_event(serialized_event:Dictionary) -> InputEvent:
	var event:InputEvent
	if serialized_event["type"] == "key":
		event = InputEventKey.new()
		event.scancode = serialized_event["scancode"]
		event.pressed = serialized_event["pressed"]
	elif serialized_event["type"] == "mouse_button":
		event = InputEventMouseButton.new()
		event.button_index = serialized_event["button_index"]
		event.pressed = serialized_event["pressed"]
		event.position = serialized_event["position"]
	elif serialized_event["type"] == "mouse_motion":
		event = InputEventMouseMotion.new()
		event.position = serialized_event["position"]
		event.relative = serialized_event["relative"]
		event.speed = serialized_event["speed"]
	elif serialized_event["type"] == "joypad_button":
		event = InputEventJoypadButton.new()
		event.button_index = serialized_event["button_index"]
		event.pressed = serialized_event["pressed"]
	elif serialized_event["type"] == "joypad_motion":
		event = InputEventJoypadMotion.new()
		event.axis = serialized_event["axis"]
		event.value = serialized_event["value"]
	return event

func serialize_player_state() -> Dictionary:
	var serialized_player_state:Dictionary = {}
	if paths.player:
		serialized_player_state["x"] = str(paths.player.position.x)
		serialized_player_state["y"] = str(paths.player.position.y)
		serialized_player_state["sprite_frame"] = str(paths.player.texture.frame)
		serialized_player_state["sprite_flip_h"] = str(paths.player.texture.flip_h)
	return serialized_player_state
	
func replay_events():
	#events
	if recorded_events.has(replay_frame):
		for serialized_event in recorded_events[replay_frame]:
			var new_event:InputEvent = deserialize_event(serialized_event)
			Input.parse_input_event(new_event)
	#		print("replay "+get_action_from_event(new_event))
		recorded_events.erase(replay_frame)
	#animate ghost
	if recorded_player_states.has(replay_frame+1):
		ghost.position.x = recorded_player_states[replay_frame+1].x.to_int()
		ghost.position.y = recorded_player_states[replay_frame+1].y.to_int()
		ghost.frame = recorded_player_states[replay_frame+1].sprite_frame.to_int()
		ghost.flip_h = recorded_player_states[replay_frame+1].sprite_flip_h == "True"
	
	if recorded_player_states.has(replay_frame):
		if paths.player.position.x != recorded_player_states[replay_frame].x.to_int() or paths.player.position.y  != recorded_player_states[replay_frame].y.to_int():
			push_error("replay out of sync")
		recorded_player_states.erase(replay_frame)
	
	if recorded_events.empty() and recorded_player_states.empty():
		stop_replay()

func start_replay(events:Dictionary,player_states:Dictionary):
	assert(!is_recording)
	recorded_events = events
	recorded_player_states = player_states
	replay_frame = 0
	is_replaying = true
	
	if ghost == null:
		ghost = paths.player.texture.duplicate()
		ghost.modulate = Color.orange
		paths.player.get_parent().add_child(ghost)
	ghost.visible = true
	
	
	print("Replay started")
	emit_signal("replay_started")

func stop_replay():
	assert(is_replaying)
	is_replaying = false
	ghost.visible = false
	print("Replay stopped")
	emit_signal("replay_stopped")

func start_recorder():
	assert(!is_replaying && !is_recording)
	is_recording = true
	record_frame = 0
	recorded_events.clear()
	recorded_player_states.clear()
	#save -- yeah ugly
	stats.save_game()
	savegame = stats.game_state.get_deep_copy()
	savegame.respawn_position = paths.player.position

	print("Recording started")
	emit_signal("recorder_started")

func get_remaining_replay_time():
	if !is_replaying:
		return 0.0
	else:
		return float(recorded_player_states.size())/Engine.iterations_per_second

func stop_recorder():
	assert(is_recording)
	is_recording = false
	
	savegame.events = recorded_events
	savegame.player_states = recorded_player_states

	save_dialog.popup_centered()

	print("Recording stopped\n  ",recorded_events.size()," events\n  ",recorded_player_states.size()," player states")
	emit_signal("recorder_stopped")

func _on_SaveButton_pressed():
	var filename = line_edit.text.strip_edges()
	if filename.empty():
			print("Filename cannot be empty.")
			return

	var path = "res://replays/" + filename + ".tres"
	var err = ResourceSaver.save(path, savegame)
	if err == OK:
		print("Savegame saved to %s" % path)
		save_dialog.hide()
	else:
		print("Failed to save the savegame. Error: %s" % err)

func _on_load_list_item_selected(index:int):
	load_list.get_item_text(index)
	load_dialog.hide()
	signals.emit_signal("game_to_load_selected",ResourceLoader.load("res://replays/" + load_list.get_item_text(index),"",true),false)
	pass


func _on_game_started():
	if !stats.game_state.events.empty():
		start_replay(stats.game_state.events,stats.game_state.player_states)

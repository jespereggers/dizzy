extends CanvasLayer

signal game_resumed
onready var main_menu_button = $MainMenuButton

onready var dialogue_system: Control = $dialogue_system
#onready var found_countable: Popup = $found_countable
onready var inventory: Popup = $inventory
onready var main_menu:= $MainMenu
var locked: bool = false
onready var artifact_button = $ArtifactButton

func _ready():
		assert(signals.connect("player_is_dead",self,"_on_player_is_dead") == OK)
		assert(signals.connect("open_inventory_on_touch",self,"_on_open_inventory_on_touch") == OK)
		assert(signals.connect("player_is_dying",self,"_on_player_is_dying") == OK)
		assert(signals.connect("dialogue_triggered",self,"_on_dialogue_triggered") == OK)
		assert(signals.connect("has_artifact_changed", self, "_on_has_artifact_changed") == OK)
		artifact_button.visible = stats.game_state.has_artifact
		assert(main_menu.connect("hide",self,"_try_to_resume_game") == OK)
		assert(dialogue_system.connect("dialogue_ended",self,"_try_to_resume_game") == OK)
		dialogue_system.set_process_unhandled_input(false)
		dialogue_system.hide()

		assert(inventory.connect("closed",self,"_try_to_resume_game") == OK)
		inventory.set_process_unhandled_input(false)
		inventory.hide()


func _on_open_inventory_on_touch():
	_on_enter_pressed()

	
	
func _unhandled_input(event:InputEvent):
		if event.is_action_pressed("escape"):
				_on_MainMenuButton_pressed()
		if event.is_action_pressed("enter"):
				print("enter detected at ui")
				_on_enter_pressed()


func _on_enter_pressed():
	if not inventory.is_visible_in_tree() and not main_menu.visible and paths.player.can_interact(): 
		var detected_items: Array = paths.player.get_detected_items()
		var detected_interactables: Array = paths.player.get_detected_interactables()
		var item_needed := false
		if !detected_interactables.empty():
			item_needed = detected_interactables.front().needed_item != ""
		if paths.player.can_interact() and !detected_interactables.empty() and !item_needed and detected_items.empty():
			_start_dialogue(detected_interactables.front().dialogue) #interact
		else:
			_open_inventory() #drop or use items; item usage is handled in inventory.close()
	get_tree().set_input_as_handled()


func _halt_game():
		main_menu_button.disabled = true
		paths.player.script_locked = true
		set_process_unhandled_input(false)
		signals.emit_signal("pause_mode_changed_to", true)
		get_tree().paused = true

func _open_inventory():
	if $dialogue_system.visible_boxes != []:
		return

	paths.player.visible = false
	_halt_game()
	inventory.open()
		
func open_inventory_just_to_show_increased_bag_capacity():
		paths.player.visible = false
		_halt_game()
		inventory.open_just_to_show_increased_capacity()
		
func _start_dialogue(dialogue):
		paths.player.visible = false
		_halt_game()
		dialogue_system.open(dialogue)


func _on_dialogue_triggered(dialogue:PoolStringArray):
		_start_dialogue(dialogue)

func _try_to_resume_game():
		if not inventory.is_visible_in_tree() and not dialogue_system.is_visible_in_tree():
				main_menu_button.disabled = false
				signals.emit_signal("pause_mode_changed_to", false)
				get_tree().paused = false
				if paths.player:
						paths.player.visible = true
						paths.player.script_locked = false
				set_process_unhandled_input(true)
				emit_signal("game_resumed")


func _on_player_is_dead():
		assert(audio.current_stream_player.name == "dead")
		var time_to_game_over = audio.get_remaining_stream_length()
		var time_to_respawn = audio.get_remaining_stream_length() - dialogue_system._get_respawn_duration()
		if stats.game_state.eggs > 0:
				signals.emit_signal("dialogue_triggered",["box:death_dialog_" + paths.player.cause_of_death,"timer:"+str(time_to_respawn),"clear","decrease_eggs","respawn","await:player_respawned"])
		else:
				signals.emit_signal("dialogue_triggered",["box:death_dialog_" + paths.player.cause_of_death,"timer:"+str(time_to_game_over),"game_over"])
				
func _on_player_is_dying():
		audio.play("dead")
		_halt_game()


func _on_MainMenuButton_pressed():
		if live.blocked:
			return
			
		if !main_menu.visible:
				if paths.player.can_interact():
						_halt_game()
						main_menu.visible = true
						paths.player.visible = false
		else:
				main_menu.visible = false


func reload_inventory_node(): #after changing language
		inventory.queue_free()
		inventory = load("res://Scenes/inventory.tscn").instance()
		add_child(inventory)
		assert(inventory.connect("closed",self,"_try_to_resume_game") == OK)
		inventory.set_process_unhandled_input(false)
		
func _on_has_artifact_changed():
		artifact_button.visible = stats.game_state.has_artifact
		#artifact_button.disable_and_start_cooldown()


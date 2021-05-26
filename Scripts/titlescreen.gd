extends Control

var current_menue: String


func _ready():
	$credits/background/back.connect("pressed", self, "load_menu", ["main"])
	if get_tree().current_scene.name == "titlescreen":
		databank.load_databanks()
		load_settings()
		load_menu("main")


func load_settings():
	# Sound
	var master_sound = AudioServer.get_bus_index("Master")
	if databank.settings.sound == true:
		AudioServer.set_bus_mute(master_sound, false)
	else:
		AudioServer.set_bus_mute(master_sound, true)
	
	# Language
	match databank.settings.language:
		"german":
			TranslationServer.set_locale("de")
		"english":
			TranslationServer.set_locale("en")


func load_menu(menu_name: String):
	current_menue = menu_name
	
	if menu_name == "on_credits":
		$settings.hide()
		$credits/background/back.load_template("back")
		$credits.show()
	else:
		$settings.show()
		$credits.hide()
		
	for button in $settings/background/main.get_children():
		button.queue_free()
		yield(button, "tree_exited")
		
	for button in databank.titlescreen[menu_name]:
		if button[0] == "back":
			var missing_buttons: int = 3 - $settings/background/main.get_child_count()
			for i in missing_buttons:
				var button_instance: Button = load("res://Scenes/templates/settings_button.tscn").instance() 
				button_instance.modulate.a = 0
				$settings/background/main.add_child(button_instance)
				
		if button[0] == "play" and get_tree().current_scene.name == "world":
			button = ["resume"]
			
		var button_template = get_button_instance(button[0])
		if button.size() > 1:
			button_template.connect("pressed", self, "load_menu", [button[1]])
		else:
			button_template.connect("pressed", self, "_on_setting_pressed", [button[0]])

			match button[0]:
				"resume":
					if not File.new().file_exists(OS.get_user_data_dir() + "/game_save.dizzy"):
						button_template.disable()
				"english":
					if databank.settings.language == "english":
						button_template.disable()
				"german":
					if databank.settings.language == "german":
						button_template.disable()
				"sound on":
					if databank.settings.sound == true:
						button_template.disable()
				"sound off":
					if databank.settings.sound == false:
						button_template.disable()
	
		$settings/background/main.add_child(button_template)


func get_button_instance(button_name: String) -> Button:
	var button: Button = load("res://Scenes/templates/settings_button.tscn").instance() #!
	button.load_template(button_name)
	return button


func _on_setting_pressed(button_name: String):
	match button_name:
		"new game":
			get_tree().paused = false
			databank.store_default_game_save()
			get_tree().change_scene("res://Scenes/world.tscn")
		"resume":
			if get_tree().current_scene.name == "world":
				get_tree().paused = false
				get_parent().hide()
				return
			get_tree().paused = false
			get_tree().change_scene("res://Scenes/world.tscn")
		"german":
			databank.settings.language = "german"
			load_menu("on_language")
		"english":
			databank.settings.language = "english"
			load_menu("on_language")
		"sound on":
			databank.settings.sound = true
			load_menu("on_sound")
		"sound off":
			databank.settings.sound = false
			load_menu("on_sound")
		"exit":
			databank.save_setttings()
			if get_tree().current_scene.name == "world":
				databank.save_game()
			yield(get_tree().create_timer(0.2), "timeout")
			get_tree().quit()
		
	load_settings()


func _on_titlescreen_visibility_changed():
	if is_visible_in_tree():
		load_menu("main")


func _on_close_pressed():
	if get_tree().current_scene.name == "world":
		get_tree().paused = false
		get_parent().hide()

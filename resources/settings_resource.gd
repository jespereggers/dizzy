class_name SettingsResource
extends Resource

signal language_changed
signal sound_on_changed

var save_path = "user://settings.tres"
export var language := "de" setget _set_language
export var sound_on := true setget _set_sound_on

func _set_language(new_language:String):
	language = new_language
	TranslationServer.set_locale(language)
	emit_signal("language_changed")

func _set_sound_on(new_value:bool):
	sound_on = new_value
	emit_signal("sound_on_changed")

func save():
 if ResourceSaver.save(save_path,self) != OK:
	 print_debug("save settings failed.")
 print_debug("save settings: ",sound_on," ",language)

func load():
	if File.new().file_exists(save_path):
		var loaded_resource = ResourceLoader.load(save_path)
		if loaded_resource:
			self.sound_on = loaded_resource.sound_on
			self.language = loaded_resource.language
			print_debug("load settings ",sound_on," ",language)
		else:
			push_error("Load settings failed")
	else:
		print_debug("No settings file found.")

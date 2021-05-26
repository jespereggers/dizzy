extends Button

var label: String


func load_template(new_label: String):
	label = TranslationServer.translate(new_label)
	
	$disabled.text = label
	$enabled.texture = load("res://Assets/tiles/menu/menue/" + label + ".png")


func disable():
	if File.new().file_exists("res://Assets/tiles/menu/menue/disabled_buttons/" + label + ".png"):
		$enabled.texture = load("res://Assets/tiles/menu/menue/disabled_buttons/" + label + ".png")
	else:
		self.disabled = true
		$enabled.hide()
		$disabled.show()

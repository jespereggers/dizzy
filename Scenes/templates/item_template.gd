extends Button

#func _ready():
	#self.custom_colors.font_color = Color(databank.colors.cyan)
	#self.custom_colors.font_color_pressed = Color(databank.colors.purple)


func load_template(item_name: String):
	self.text = item_name.capitalize()

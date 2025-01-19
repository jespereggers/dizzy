extends Button

func load_template(item_name: String):
	if item_name != "":
		self.name = item_name
		self.text = tr(item_name).capitalize()

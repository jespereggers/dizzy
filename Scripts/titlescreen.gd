extends Control

export var settings : Resource

func _ready():
		assert(settings.connect("language_changed",self,"_on_language_changed") == OK)

func _on_language_changed():
		for child in get_all_children(self):
				if child is TextureButton:
						child.texture_normal = load(child.texture_normal.resource_path)
						if child.texture_disabled != null:
								child.texture_disabled = load(child.texture_disabled.resource_path)
				if child is TextureRect:
						child.texture = load(child.texture.resource_path)
		if paths.ui:
				paths.ui.reload_inventory_node()
						
func _on_PlayButton_pressed():
		$background/Play.show()


func _on_OptionButton_pressed():
		$background/Option.show()


func _on_CreditButton_pressed():
		$background/Credit.show()

func get_all_children(node:Node) -> Array:
		var all_nodes:Array = []
		for child in node.get_children():
				all_nodes.append(child)
				for sub_child in get_all_children(child):
						all_nodes.append(sub_child)
		return all_nodes
				
func _on_ResumeButton_pressed():
		hide()


func _on_MainMenu_visibility_changed():
		$background/Main/ResumeButton.visible = (paths.player != null)


func _on_ExitButton_pressed():
		$background/Exit.show()

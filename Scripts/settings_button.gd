extends Button


func load_template(label: String, scene: String):
	label = TranslationServer.translate(label)

	$label.texture = load("res://Assets/tiles/menu/menue/" + label + ".png")
	
	$label.material = ShaderMaterial.new()
	
	#match scene:
		##"titlescreen":
		#	self.rect_size.x = 100
		#	$background.rect_size.x = 100
	#	"world":
		#	self.rect_size.x = 200
		##	$background.rect_position.x -= 50
	#		$background.rect_size.x = 200

func disable():
	self.disabled = true
	$label.material.shader = load("res://shaders/greyscale.shader")

func enable():
	self.disabled = false
	$label.material.shader = null


func change_background(transition: bool):
	if transition:
		$background.texture = load("res://Assets/tiles/menu/dialog_transition.png")
		#$background.margin_top = 12
		#$background.margin_bottom = 12
	else:
		$background.texture = load("res://Assets/tiles/menu/dialog.png")
		#$background.margin_top = 24
		#$background.margin_bottom = 24

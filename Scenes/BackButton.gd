extends TextureButton

func _ready():
  assert(connect("pressed",self,"_on_pressed") == OK)

func _on_pressed():
  get_parent().hide()

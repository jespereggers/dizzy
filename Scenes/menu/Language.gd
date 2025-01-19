extends Control

export var settings : Resource 

func _ready():
  assert(settings)
  assert(settings.connect("language_changed",self,"update_buttons") == OK)
  update_buttons()

func update_buttons():
  $EnglishButton.disabled = settings.language == "en" 
  $GermanButton.disabled = settings.language == "de"

func _on_EnglishButton_pressed():
  settings.language = "en"
  settings.save()
  update_buttons()

func _on_GermanButton_pressed():
  settings.language = "de"
  settings.save()
  update_buttons()

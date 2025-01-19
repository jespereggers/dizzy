extends Control

export var settings : Resource
func _ready():
  assert(settings)
  assert(settings.connect("sound_on_changed",self,"update_buttons") == OK)
  update_buttons()

func update_buttons():
  $OnButton.disabled = settings.sound_on
  $OffButton.disabled = !settings.sound_on


func _on_OnButton_pressed():
  settings.sound_on = true
  settings.save()
  update_buttons()

func _on_OffButton_pressed():
  settings.sound_on = false
  settings.save()
  update_buttons()

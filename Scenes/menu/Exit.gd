extends Control

func _on_YesButton_pressed():
  get_tree().quit()


func _on_NayButton_pressed():
  hide()

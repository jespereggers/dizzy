extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
		pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass


func _on_AboutUsButton_pressed():
		$AboutUsRect.show()
		$TapToClosePanel.show()


func _on_CopyRightButton_pressed():
		$CopyRightRect.show()
		$TapToClosePanel.show()


func _on_DonateButton_pressed():
		$DonateRect.show()
		$TapToClosePanel.show()

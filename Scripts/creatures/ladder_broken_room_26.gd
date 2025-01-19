extends Persistent


func _fix_ladder():
		$InteractionArea/CollisionShape2D.disabled = false
		$Sprite.visible = false
		$Ladder/CollisionShape2D.disabled = false

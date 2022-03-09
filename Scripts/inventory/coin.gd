class_name Coin
extends Item

func get_picked_up():
	queue_free()
	signals.emit_signal("countable_collected", "coin")

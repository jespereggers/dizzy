class_name Coin
extends Item

export var dialogue:Array =   ["box:found_coin","play:coin","increment_coins" ,"wait", "play:theme"]
func get_picked_up():
		queue_free()
		signals.emit_signal("dialogue_triggered",dialogue)

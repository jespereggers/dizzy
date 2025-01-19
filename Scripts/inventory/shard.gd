class_name Shard
extends Item

export var dialogue:Array =   ["box:found_shard","play:coin","await:sound_finished","increment_shards" ,"wait", "play:theme"]

func get_picked_up():
  queue_free()
  signals.emit_signal("dialogue_triggered",dialogue)

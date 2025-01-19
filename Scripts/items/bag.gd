extends Item

func get_picked_up():
  stats.game_state.inventory_capacity = 4
  queue_free()
  paths.ui.call_deferred("open_inventory_just_to_show_increased_bag_capacity")

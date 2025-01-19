class_name ItemUserArea
extends Area2D

export var needed_item: String
export var dialogue: PoolStringArray = ["box:room_14/message_barrel_water","wait","call:barrel_boat:enable","call:barrel_water:disable","move_player:112,140"]

func use_item():
  paths.ui.dialogue.play_custom(dialogue)

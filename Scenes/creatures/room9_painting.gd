extends Persistent

func activate():
  $Sprite.flip_h = false
  $Sprite.flip_v = false
  $InteractionArea.dialogue = ["box:room_9/message_painting_read","wait"]
  $"../coin2".position = Vector2(160,88)

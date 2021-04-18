extends CanvasLayer

onready var death: Popup = $death
onready var found_coin: Popup = $found_coin
onready var frozen_screen: TextureRect = $frozen_screen

var locked: bool = false
var player_on_item: bool = false


func apply_viewport_to_background():
	var old_clear_mode =get_viewport().get_clear_mode()
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	# Let two frames pass to make sure the screen was captured.
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	# Retrieve the captured image.
	var img = get_viewport().get_texture().get_data()
	# restore the previous value, as some part wont redraw after...
	get_viewport().set_clear_mode(old_clear_mode)

	# Create a texture for it.
	var tex = ImageTexture.new()
	tex.create_from_image(img)
	
	$frozen_screen.texture = tex
	$frozen_screen.show()


func take_screenshot():
	var old_clear_mode =get_viewport().get_clear_mode()
	get_viewport().set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
	# Let two frames pass to make sure the screen was captured.
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	# Retrieve the captured image.
	var img = get_viewport().get_texture().get_data()
	# restore the previous value, as some part wont redraw after...
	get_viewport().set_clear_mode(old_clear_mode)

	# Flip it on the y-axis (because it's flipped).
	img.flip_y()

   # I also want a thumbnail 1/3 size
	var s = img.get_size()
	var scale_reduce = 0.3
	img.resize(s.x * scale_reduce, s.y * scale_reduce)

	# I crop it to my need 
	var border = get_parent()#.get_node("border")
	var border_s = border.to_global(get_viewport().get_texture().get_size())
	var border_p = border.to_global(Vector2(0,0))
	var zone = Rect2(Vector2(0,0), border_s * scale_reduce)

	# copy to a new image, I need to create it first with the same size with create()
	var imgDest = Image.new()
	imgDest.create(zone.size.x, zone.size.y, false, img.get_format())
	imgDest.blit_rect(img, zone, Vector2.ZERO)

	# Create a texture for it.
	var tex = ImageTexture.new()
	tex.create_from_image(imgDest)

	# the texture can be assigned to a Sprite2D or a TextureRect
	$frozen_screen.texture = tex

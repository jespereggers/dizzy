extends Node2D


func _ready():
	if "barrel_boat" in data.game_save.enviroment[stats.current_map][Vector2(-1,0)].shown_objects:
		$barrel_boat/animator.play("move_13")
		$barrel_boat/animator.advance(28.75)
		$barrel_boat.show()


func switch_automove_dir(new_dir: int):
	if new_dir == paths.player.automove_dir:
		return 
	paths.player.automove_dir = new_dir
	if new_dir == 1:
		paths.player.position.x += 5
	if new_dir == -1:
		paths.player.position.x -= 5
	
	if new_dir == 1 and $barrel_boat.position.x < 220:
		paths.player.position.y -= 5

extends Control

var resume_game : SaveGame

func _ready():
	$ResumeButton.disabled = true
	if File.new().file_exists(stats.save_path):
		resume_game = ResourceLoader.load(stats.save_path)
		if resume_game:
			$ResumeButton.disabled = false      

func _on_NewGameButton_pressed():
	signals.emit_signal("game_to_load_selected",ResourceLoader.load("res://resources/new_game.tres","",true))


func _on_ResumeButton_pressed():
	signals.emit_signal("game_to_load_selected",resume_game)

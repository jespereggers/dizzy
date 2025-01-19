extends Node

var colors: Dictionary = {
		"black": Color("#000000"),
		"white": Color("#FFFFFF"),
		"red": Color("#68372B"),
		"cyan": Color("#70A4B2"),
		"purple": Color("#6F3D86"),
		"green": Color("#588D43"),
		"yellow": Color("#B8C76F")
}

var intro_screen_coord:= Vector2(-100,-100)
var main_menu_coord:= Vector2(-101,-101)

var maps: Dictionary = {
		"map_1": {
				#Intro
				intro_screen_coord:{    #IntroScreen
						"name": "tap or swipe to skip",
						"path": "res://map/rooms/intro_screen.tscn"
					},
				main_menu_coord:{    #MainMenu
						"name": "make a wise choice",
						"path": "res://map/rooms/title_screen.tscn"
					},
				#Etage 0
				Vector2(2,0): {
						"name": "the torture chamber",
						"path": "res://map/rooms/room_17.tscn"
				},
				Vector2(1,0): {
						"name": "rockwart's quarter",
						"path": "res://map/rooms/room_16.tscn"
				},
				Vector2(0,0): {
						"name": "the castle's dungeon",
						"path": "res://map/rooms/room_15.tscn"
				},
				Vector2(-1,0): {
						"name": "smuggler's hideout",
						"path": "res://map/rooms/room_14.tscn"
				},
				Vector2(-2,0): {
						"name": "the bat cave",
						"path": "res://map/rooms/room_13.tscn"
				},
				Vector2(-3,0): {
						"name": "the cargo warehouse",
						"path": "res://map/rooms/room_12.tscn"
				},
				Vector2(-4,0): {
						"name": "the wishing well",
						"path": "res://map/rooms/room_11.tscn"
				},
				Vector2(-5,0): {
						"name": "the amazing illusion",
						"path": "res://map/rooms/room_18.tscn"
				},
				#The Well
				Vector2(-4,-1): {
						"name": "down the well",
						"path": "res://map/rooms/room_19.tscn"
				},
				Vector2(-4,-2): {
						"name": "very deep down!",
						"path": "res://map/rooms/room_20.tscn"
				},
				Vector2(-5,-3): {
						"name": "a cotton-wool cloud",
						"path": "res://map/rooms/room_21.tscn"
				},
				Vector2(-4,-3): {
						"name": "cheerfully to cloudy",
						"path": "res://map/rooms/room_22.tscn"
				},
				Vector2(-3,-3): {
						"name": "the abandoned hut",
						"path": "res://map/rooms/room_23.tscn"
				},
				Vector2(-5,-4): {
						"name": "upper mine entrance",
						"path": "res://map/rooms/room_24.tscn"
				},
				Vector2(-4,-4): {
						"name": "the wooden bridge",
						"path": "res://map/rooms/room_25.tscn"
				},
				Vector2(-3,-4): {
						"name": "a mobile roadworks",
						"path": "res://map/rooms/room_26.tscn"
				},
				#Etage 1
				Vector2(-1,1): {
						"name": "moat and portcullis",
						"path": "res://map/rooms/room_8.tscn"
				},
				Vector2(0,1): {
						"name": "the entrance hall",
						"path": "res://map/rooms/room_9.tscn"
				},
				Vector2(1,1): {
						"name": "the castle moat",
						"path": "res://map/rooms/room_10.tscn"
				},
				
				#Etage 2
				Vector2(-1,2): {
						"name": "the west wing",
						"path": "res://map/rooms/room_5.tscn"
				},
				Vector2(0,2): {
						"name": "the banqueting hall",
						"path": "res://map/rooms/room_6.tscn"
				},
				Vector2(1,2): {
						"name": "the east wing",
						"path": "res://map/rooms/room_7.tscn"
				},
				
				#Etage 3
				Vector2(-1,3): {
						"name": "the west tower",
						"path": "res://map/rooms/room_2.tscn"
				},
				Vector2(0,3): {
						"name": "the castle staircase",
						"path": "res://map/rooms/room_3.tscn"
				},
				Vector2(1,3): {
						"name": "the east tower",
						"path": "res://map/rooms/room_4.tscn"
				},
				
				#Etage 4
				Vector2(0,4): {
						"name": "the attic",
						"path": "res://map/rooms/room_1.tscn"
				}
		}
}


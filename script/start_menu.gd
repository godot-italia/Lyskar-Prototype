#===================================================#
#                                                   #
#                   start_menu.gd                   #
#                                                   #
#===================================================#

extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$vbox/start.connect("pressed",self,"start_game")


func start_game():
	get_tree().change_scene("res://scenes/game.tscn")

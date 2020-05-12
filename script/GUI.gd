#===================================================#
#                     GUI.gd                        #
#===================================================#

extends Control

var player
#--- flags
var fl_player_is_on_floor := false


func _ready():
	$pl_stats_box.hide()
	#--- connect signals for player stats
	$pl_stats_box/accelleration.connect("value_changed",self,"accelleration")
	$pl_stats_box/friction.connect("value_changed",self,"friction")
	$pl_stats_box/gravity_acc.connect("value_changed",self,"gravity_acc")
	$pl_stats_box/jump_acc.connect("value_changed",self,"jump_acc")
	$pl_stats_box/max_speed.connect("value_changed",self,"max_speed")
	$pl_stats_box/max_fall_speed.connect("value_changed",self,"max_fall_speed")
	
	yield(get_tree(),"idle_frame")
	#--- set labels
	$pl_stats_box/accelleration.value = player.accelleration
	$pl_stats_box/friction.value = player.friction
	$pl_stats_box/gravity_acc.value = player.gravity_acc
	$pl_stats_box/jump_acc.value = player.jump_acc
	$pl_stats_box/max_speed.value = player.max_speed
	$pl_stats_box/max_fall_speed.value = player.max_fall_speed
	
	$pl_stats_box/accelleration/lb.text = str(player.accelleration)
	$pl_stats_box/friction/lb.text = str(player.friction)
	$pl_stats_box/gravity_acc/lb.text = str(player.gravity_acc)
	$pl_stats_box/jump_acc/lb.text = str(player.jump_acc)
	$pl_stats_box/max_speed/lb.text = str(player.max_speed)
	$pl_stats_box/max_fall_speed/lb.text = str(player.max_fall_speed)


func accelleration(val):
	player.accelleration = val
	$pl_stats_box/accelleration/lb.text = str(val)
func friction(val):
	player.friction = val
	$pl_stats_box/friction/lb.text = str(val)
func gravity_acc(val):
	player.gravity_acc = val
	$pl_stats_box/gravity_acc/lb.text = str(val)
func jump_acc(val):
	player.jump_acc = val
	$pl_stats_box/jump_acc/lb.text = str(val)
func max_speed(val):
	player.max_speed = val
	$pl_stats_box/max_speed/lb.text = str(val)
func max_fall_speed(val):
	player.max_fall_speed = val
	$pl_stats_box/max_fall_speed/lb.text = str(val)


func _process(delta):
	$fps.text = str( Engine.get_frames_per_second() , " fps" )

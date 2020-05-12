#===================================================#
#                     world.gd                      #
#                    game script                    #
#                                                   #
#===================================================#



extends Spatial

onready var player_pack     = preload("res://instances/player.tscn")
onready var fixed_cam_pack  = preload("res://instances/cam_fixed.tscn")
onready var follow_cam_pack = preload("res://instances/cam_follow.tscn")
onready var gui_pack        = preload("res://instances/GUI.tscn")
onready var raycaster_pack  = preload("res://instances/raycaster.tscn")
onready var floating_label  = preload("res://instances/billboard_label.tscn")

var player
var cam
var gui
var raycaster

#--- signals
signal map_clicked

#-- navigation
var nav_path



#================================ GAME INIT ====================================

func _ready():
	initialize_game()

func initialize_game():
	#--- add instances
	player    = player_pack.instance()
	cam       = fixed_cam_pack.instance()
	gui       = gui_pack.instance()
	raycaster = raycaster_pack.instance()
	#  --- player
	player.translation = $spawn.translation
	player.camera = cam
	add_child(player)
	#  --- camera
	cam.player = player
	add_child(cam)
	#  --- game interface
	gui.player = player
	add_child(gui)
	#  --- utility raycaster
	add_child(raycaster)
	
	#--- set cursor type:
	var arrow = load("res://assetts/sprites/game-cursor-png-1.png")
	Input.set_custom_mouse_cursor(arrow, Input.CURSOR_ARROW, Vector2(8.5,1.5))

	#---- temporary set for tentacle test
	for tentacle in $tentacles.get_children():
		tentacle.node_to_reach_path = player.get_path()



#================================ PROCESSES ====================================

func _unhandled_input(event):
	#--- on mouse click
	if event.is_action_pressed("left_click"):
		var result: Dictionary = raycaster.cast_ray()
		if result:
			if result.collider is GridMap:
				emit_signal("map_clicked", result.position)
				calculate_nav_path(player.global_transform.origin, result.position)
				draw_nav_path()
				player.start_nav_path(nav_path)
	elif event.is_action_pressed("right_click"):
		var result: Dictionary = raycaster.cast_ray()
		if result:
			var obj_name = result.collider.name
			display_billboard_message(result.position, obj_name)


#============================= GAME FUNCTIONS ==================================

func calculate_nav_path(from_pos, to_pos):
	nav_path = $nav.get_simple_path(from_pos, to_pos)
	if nav_path.empty():
		print("GAME: navigation path empty")
		display_billboard_message(to_pos, "navigation path empty")

func draw_nav_path():
	var offset_above_nav_mesh = Vector3(0,0.2,0)
	$dp.clear()
	if not nav_path.empty():
		$dp.begin(Mesh.PRIMITIVE_LINE_STRIP)
		for p in nav_path:
			$dp.add_vertex(p + offset_above_nav_mesh)
		$dp.end()


#================================ TRIGGERS =====================================

func _on_dead_drop_body_entered(body):
	# this area is a big box under the scene, in case the player manage to drop off the map
	# it is meant to teleport the player back to the starting position if drop outside
	if body == player:
		player.global_transform.origin = $spawn.global_transform.origin
	else:
		body.queue_free()


func display_billboard_message(pos : Vector3, text : String, duration = 1.5):
	var billboard_label = floating_label.instance()
	billboard_label.pos = pos
	billboard_label.text = text
	billboard_label.duration = duration
	add_child(billboard_label)






#===================================================#
#                                                   #
#                    cam_fixed.gd                   #
#                                                   #
#===================================================#

extends Spatial

var player : Spatial

export var max_distance : float = 100
export var min_distance : float = 5
export var max_y_angle : float = 0
export var min_y_angle : float = -180
export var max_x_angle : float = 0
export var min_x_angle : float = -90

var target_y_angle  : float = -90
var target_x_angle  : float = -45
var target_distance : float = 20
var target_distance_obstructed : float
var target_distance_set : float = 20

var mouse_middle_pressed = false

var vertical_offset = Vector3(0,2.5,0)
var angle_treshold = 0.01
var distance_treshold = 0.5

onready var cam = $cam_fixed


func _ready():
	rotation.x = deg2rad(target_x_angle)
	rotation.y = deg2rad(target_y_angle)
	cam.translation.z = target_distance

func _input(event):
	#--- check if camera is current
	if not cam.current:
		return
	
	#--- adjust distance with mouse wheel scroll
	if event is InputEventMouseButton:
		set_process(true)
		if event.button_index == BUTTON_WHEEL_DOWN: target_distance_set *= 1.2
		elif event.button_index == BUTTON_WHEEL_UP: target_distance_set /= 1.2
		target_distance_set = clamp(target_distance_set, min_distance, max_distance)
		
	#--- pan camera target angles with middle mouse pressed and mouse movement
		if event.button_index == BUTTON_MIDDLE and event.is_pressed():       mouse_middle_pressed = true
		elif event.button_index == BUTTON_MIDDLE and not event.is_pressed(): mouse_middle_pressed = false

	if event is InputEventMouseMotion and mouse_middle_pressed:
		target_y_angle -= event.relative.x
		target_x_angle += event.relative.y
		
		target_y_angle = clamp(target_y_angle, min_y_angle, max_y_angle)
		target_x_angle = clamp(target_x_angle, min_x_angle, max_x_angle)
	
	#--- pan camera target angles with keypad numbers
	if event is InputEventKey:
		if   event.scancode == KEY_KP_5: target_x_angle += 5
		elif event.scancode == KEY_KP_8: target_x_angle -= 5
		elif event.scancode == KEY_KP_4: target_y_angle -= 5
		elif event.scancode == KEY_KP_6: target_y_angle += 5
		
		target_y_angle = clamp(target_y_angle, min_y_angle, max_y_angle)
		target_x_angle = clamp(target_x_angle, min_x_angle, max_x_angle)


func _process(delta):
	#--- set position to player position
	if player:
		translation = player.translation + vertical_offset
	
	#--- check if camera is in the target angle/distance
	var cam_steady = false
	
	if cam.translation.z == target_distance and\
	   rotation.x == deg2rad(target_x_angle) and\
	   rotation.y == deg2rad(target_y_angle):
		cam_steady = true
	
	#--- if not in target angle/distance adjust camera smoothly
	if not cam_steady:
		rotation.x = lerp_angle(rotation.x, deg2rad(target_x_angle), delta*10)
		rotation.y = lerp_angle(rotation.y, deg2rad(target_y_angle), delta*10)
		cam.translation.z = lerp(cam.translation.z, target_distance, delta*10)
		
		#--- if close to tresholds snap to target angle/distance
		if abs(rotation.x - deg2rad(target_x_angle)) < angle_treshold:
			rotation.x = deg2rad(target_x_angle)
		if abs(rotation.y - deg2rad(target_y_angle)) < angle_treshold:
			rotation.y = deg2rad(target_y_angle)
		if abs(cam.translation.z - target_distance) < distance_treshold:
			cam.translation.z = target_distance
	
	if check_for_camera_occlusion(delta):
		target_distance = target_distance_obstructed
	else:
		target_distance = target_distance_set


func check_for_camera_occlusion(delta):
	$cam_occlusion_ray.cast_to = $cam_fixed.translation + Vector3(0,0,3)
	if $cam_occlusion_ray.is_colliding():
		target_distance_obstructed = ($cam_occlusion_ray.get_collision_point() - translation).length()
		return true
	return false

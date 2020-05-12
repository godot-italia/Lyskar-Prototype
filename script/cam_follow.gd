#===================================================#
#                                                   #
#                   cam_follow.gd                   #
#                                                   #
#===================================================#

extends Spatial

#this node is the target of the camera
var distance : float = 10
var height   : float = 4

const MAX_DIST   = 50
const MIN_DIST   = 2.5
const MAX_HEIGHT = 20
const MIN_HEIGHT = 1

onready var cam = $cam_follow


func _ready():
	cam.set_as_toplevel(true)


func _physics_process(delta):
	pass


var mouse_last_pos = Vector2()
func _process(delta):
	if not cam.current:
		return
	#--- cam follow
	var cam_origin = cam.global_transform.origin
	var up = Vector3(0,1,0)
	
	var offset = cam.global_transform.origin - global_transform.origin
	offset = offset.normalized() * distance
	offset.y = height
	var pos = global_transform.origin + offset
	cam.look_at_from_position(pos, global_transform.origin, up)
	
	#--- mouse middle button -> camera rotation
	if Input.is_mouse_button_pressed(BUTTON_MIDDLE):
		if mouse_last_pos == Vector2():
			mouse_last_pos = get_viewport().get_mouse_position()
		else:
			var diff = get_viewport().get_mouse_position() - mouse_last_pos
			height += diff.y * delta
			
			var orbital_vec = Vector3(1,0,0).rotated(Vector3(0,1,0),cam.global_transform.basis.get_euler().y)*(diff.x * delta)
			cam.global_transform.origin += orbital_vec
			
			mouse_last_pos = get_viewport().get_mouse_position()
	elif mouse_last_pos != Vector2():
		 mouse_last_pos = Vector2()


func _input(event):
	if not cam.current:
		return
	#--- cam zoom
	if event is InputEventMouseButton:
		if event.button_mask == 16:
			distance *= 1.2
			distance  = min(distance, MAX_DIST)
			height   *= 1.2
			height    = min(height,   MAX_HEIGHT)
		elif event.button_mask == 8:
			distance /= 1.2
			distance  = max(distance, MIN_DIST)
			height   /= 1.2
			height    = max(height,   MIN_HEIGHT)
	







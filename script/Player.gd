#===================================================#
#                                                   #
#                    player.gd                      #
#                                                   #
#===================================================#


extends KinematicBody

#--- global var
var direction   : Vector3
var move_vector : Vector3

#--- player stats
var camera : Spatial

var accelleration  : float = 100
var friction       : float = 180
var jump_acc       : float = 20
var gravity_acc    : float = 190
var max_speed      : int   = 15
var max_fall_speed : int   = 80

var fl_is_on_floor = false

#--- navigation
var is_moving_along_path = false
var nav_path : PoolVector3Array


func _ready():
	pass


#================================ PROCESSES ====================================

func _input(event):
	#--- if pressing keyboard controls, it stops following the nav_path
	if event is InputEventKey:
		is_moving_along_path = false
	
	if event is InputEventAction:
		direction = Vector3(                                                          \
		event.get_action_strength("ui_right") - event.get_action_strength("ui_left"), \
		event.get_action_strength("ui_select") * jump_acc * int( is_on_floor() ),\
		event.get_action_strength("ui_down")  - event.get_action_strength("ui_up"))
	


func _process(delta):
	#--- if using inputs from keyboard
	if not is_moving_along_path:
		direction = Vector3(                                                          \
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"), \
		Input.get_action_strength("ui_select") * (jump_acc + gravity_acc*delta) * int(is_on_floor()),\
		Input.get_action_strength("ui_down")  - Input.get_action_strength("ui_up"))
		
		#--- adjust direction to camera angle
		if camera:
			var cam_global_angle = camera.rotation.y
			direction = direction.rotated( Vector3(0,1,0) , cam_global_angle)
	
	#--- moving along navigation path
	else:
		if(nav_path.size() > 0):
			direction = nav_path[0] - translation;
			direction.normalized()
			if translation.distance_to(nav_path[0]) < 0.5:
				nav_path.remove(0)
		else:
			is_moving_along_path = false


func _physics_process(delta):
	#--- slide briefly if there are no direction inputs
	if direction == Vector3():
		move_vector.x /= 1.0 + delta * friction
		move_vector.z /= 1.0 + delta * friction
	else:
		move_vector *= 0.9
		move_vector += direction * delta * accelleration
	
	#--- rotate the player body facing the direction
	if move_vector.length() > 0.2:
		rotation.y = Vector2(move_vector.x , -move_vector.z).angle() - PI/2
	
	#--- gravity
	fl_is_on_floor = is_on_floor()
	if not is_on_floor():
		move_vector.y -= gravity_acc * delta
		move_vector.y = clamp(move_vector.y, -max_fall_speed, max_fall_speed)
	
	move_vector.x = clamp(move_vector.x , -max_speed , max_speed)
	move_vector.z = clamp(move_vector.z , -max_speed , max_speed)
	
	move_vector = move_and_slide_with_snap(move_vector, Vector3(0,1,0), Vector3(0,1,0), false, 4, deg2rad(45))

func start_nav_path(_nav_path : PoolVector3Array):
	if _nav_path.empty():
		return
	nav_path = _nav_path
	is_moving_along_path = true

func move_along_nav_path():
	pass






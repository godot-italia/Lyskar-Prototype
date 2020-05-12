#===================================================#
#                   UTILITY script                  #
#                    raycaster.gd                   #
#                                                   #
#===================================================#

extends Spatial

var ray_length = 1000

func cast_ray():
	var camera : Camera = get_viewport().get_camera()
	var mouse_coords = get_viewport().get_mouse_position()
	
	var fromVector: Vector3 = camera.project_ray_origin(mouse_coords)
	var toVector: Vector3 = fromVector + camera.project_ray_normal(mouse_coords) * ray_length

	var space_state: PhysicsDirectSpaceState = get_world().direct_space_state
	var result: Dictionary = space_state.intersect_ray(fromVector, toVector)
	
	return result

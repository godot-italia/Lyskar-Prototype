extends Node
class_name MouseRayCaster

var ray : RayCast
var camera: Camera
var ray_length: int

func _init(cam : Camera, length: int = 1000) -> void:
	camera = cam
	ray = RayCast.new()
	ray.set_name("MouseClick_Ray")
	camera.add_child(ray)
	ray.clear_exceptions()
	#ray.set_collision_mask(COLLISIONMASK)
	ray.set_enabled(true)
	ray_length = length
	
func cast_ray(mouse_coords: Vector2, world: World) -> Dictionary:
	var fromVector: Vector3 = camera.project_ray_origin(mouse_coords)
	var toVector: Vector3 = fromVector + camera.project_ray_normal(mouse_coords) * ray_length

	var space_state: PhysicsDirectSpaceState = world.direct_space_state
	var result: Dictionary = space_state.intersect_ray(fromVector, toVector)
	
	return result
	
	

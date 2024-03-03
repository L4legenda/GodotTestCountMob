extends Sprite2D

var frame_step: float = 1.0 / 8.0
var index_frame: int = 0
var time_frame: float = 0

var nearest_player: Player = null

var direction: Vector2 = Vector2.ZERO

var body: RID
var detection_area: RID  # Обновлено: переменная для области обнаружения
var area: RID
var shape: RID
var detection_shape

var shape_instance

func _ready():
	nearest_player = get_tree().get_first_node_in_group("player")
	
	body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	shape = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.shape_set_data(shape, Vector2(10, 10))
	PhysicsServer2D.body_add_shape(body, shape)
	PhysicsServer2D.body_set_space(body, get_world_2d().space)
	
	detection_area = PhysicsServer2D.area_create()
	PhysicsServer2D.area_set_space(detection_area, get_world_2d().space)
	detection_shape = PhysicsServer2D.circle_shape_create()
	PhysicsServer2D.shape_set_data(detection_shape, 50)  # Радиус области обнаружения
	PhysicsServer2D.area_add_shape(detection_area, detection_shape)
	var area_collision_layer = 1
	var area_collision_mask = 1
	PhysicsServer2D.area_set_collision_layer(detection_area, area_collision_layer)
	PhysicsServer2D.area_set_collision_mask(detection_area, area_collision_mask)
	
	shape_instance = CircleShape2D.new()
	shape_instance.radius = 50


func _physics_process(delta):
	time_frame += delta
	var frame_count: int = time_frame / frame_step
	if frame_count > 0:
		time_frame = time_frame - (frame_step * frame_count)
		frame = (frame + frame_count) % hframes
		direction = global_position.direction_to(nearest_player.global_position)
	
	var space_state = get_world_2d().direct_space_state
	
	var query = PhysicsShapeQueryParameters2D.new()
	query.set_shape(shape_instance)  # Используйте форму вашего моба или области
	query.transform = Transform2D(0, global_position)
	query.collide_with_bodies = true
	#query.collision_mask = 1
	var result = space_state.intersect_shape(query)
	
	if result.size() > 1:
		for i in range(result.size()):
			var collider = result[i].collider
			if not collider:
				continue
			if collider != self and collider.is_in_group("mobs"):  # Проверка, чтобы не реагировать на самого себя
				direction = global_position.direction_to(collider.global_position).rotated(PI / 2).normalized()  # Изменение направления
	
	var new_position = global_position + direction * 100 * delta
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM, Transform2D(0, new_position))
	update_sprite_position()
	
func update_sprite_position():
	# Получаем текущую трансформацию тела
	var body_transform = PhysicsServer2D.body_get_state(body, PhysicsServer2D.BODY_STATE_TRANSFORM)
	# Обновляем позицию спрайта
	global_position = body_transform.origin

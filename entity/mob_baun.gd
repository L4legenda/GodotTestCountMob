extends Sprite2D

var frame_step: float = 1.0 / 8.0
var index_frame: int = 0
var time_frame: float = 0

var body: RID
var shape: RID

var nearest_player: Player = null

func _ready():
	nearest_player = get_tree().get_first_node_in_group("player")

	body = PhysicsServer2D.body_create()
	PhysicsServer2D.body_set_mode(body, PhysicsServer2D.BODY_MODE_KINEMATIC)
	shape = PhysicsServer2D.rectangle_shape_create()
	PhysicsServer2D.shape_set_data(shape, Vector2(10, 10))
	PhysicsServer2D.body_add_shape(body, shape)
	PhysicsServer2D.body_set_space(body, get_world_2d().space)
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY, Vector2(1, 0))
	PhysicsServer2D.body_set_force_integration_callback(body, _body_moved, 0)



func _physics_process(delta):
	time_frame += delta
	var frame_count: int = time_frame / frame_step
	if frame_count > 0:
		time_frame = time_frame - (frame_step * frame_count)
		frame = (frame + frame_count) % hframes
	
	var direction: Vector2 = global_position.direction_to(nearest_player.global_position)
	PhysicsServer2D.body_set_state(body, PhysicsServer2D.BODY_STATE_LINEAR_VELOCITY, direction * 100 * delta)
	

func _body_moved(state, index):
	position += state.linear_velocity

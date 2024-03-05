extends Area2D

var frame_step: float = 1.0 / 8.0
var index_frame: int = 0
var time_frame: float = 0

@onready var raycasts = $Raycasting
@onready var sprite_2d = $Sprite2D

var nearest_player: Player = null

var direction: Vector2 = Vector2.ZERO

var max_speed: int = 50

var max_steering: float = 6.5

var velocity = Vector2.ZERO

var avoid_force: int = 1000

func _ready():
	nearest_player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	time_frame += delta
	var frame_count: int = time_frame / frame_step
	if frame_count > 0:
		time_frame = time_frame - (frame_step * frame_count)
		sprite_2d.frame = (sprite_2d.frame + frame_count) % sprite_2d.hframes
		direction = global_position.direction_to(nearest_player.global_position)
	
	var steering: Vector2 = Vector2.ZERO
	steering += seek_steering()
	steering += avoid_obstacles_steering()
	steering = steering.limit_length(max_steering)
	
	velocity += steering
	velocity = velocity.limit_length(max_speed)
	
	global_position += velocity * delta


func seek_steering() -> Vector2:
	var desired_velocity: Vector2 = (nearest_player.global_position-position).normalized() * max_speed
	
	return desired_velocity - velocity

func avoid_obstacles_steering() -> Vector2:
	raycasts.rotation = velocity.angle()
	for raycast in raycasts.get_children():
		raycast.target_position.x = velocity.length()
		if raycast.is_colliding():
			var obstacle = raycast.get_collider()
			if obstacle == self:
				return Vector2.ZERO
			return (position + velocity - obstacle.position).normalized() * avoid_force
	
	return Vector2.ZERO

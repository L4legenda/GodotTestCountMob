extends Area2D

var nearest_player: Node = null
var velocity: Vector2 = Vector2.ZERO

func _ready():
	nearest_player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var direction: Vector2 = global_position.direction_to(nearest_player.global_position)
	velocity = direction * 100 * delta
	global_position += velocity

extends Area2D

var nearest_player = null
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	nearest_player = get_tree().get_first_node_in_group("player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var direction = global_position.direction_to(nearest_player.global_position)
	
	velocity = direction * 100 * delta
	
	global_position += velocity

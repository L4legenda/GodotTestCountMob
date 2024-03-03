extends Area2D

class_name Player

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var camera_2d = $Camera2D


@export var move_speed = 200

var velocity = Vector2.ZERO

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	if x_mov or y_mov:
		animated_sprite_2d.play("RUN")
		var mov = Vector2(x_mov, y_mov).normalized()
		velocity = mov * move_speed * delta
		if x_mov == 1:
			animated_sprite_2d.flip_h = false
		elif x_mov == -1:
			animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.play("IDLE")
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.y = move_toward(velocity.y, 0, move_speed)
	
	global_position += velocity


func _on_area_entered(area):
	print(area)


func _on_body_entered(body):
	print(body)

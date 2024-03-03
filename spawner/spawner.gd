extends Node2D

@onready var mobs = get_tree().get_first_node_in_group("mobs")

@export var spawns: Array[Spawn_wave_enemy_info] = []

var time = 0

var thread: Thread

func handler_timer():
	var enemy_spawns = spawns
	for i in enemy_spawns:
		if time >= i.time_start and time <= i.time_end:
			if i.spawn_delay_counter < i.enemy_spawn_delay:
				i.spawn_delay_counter += 1
			else:
				i.spawn_delay_counter = 0
				var new_enemy = i.enemy
				spawn_mob(new_enemy, i.enemy_num)


func spawn_mob(new_enemy, counter, is_boss=false):
	for i in range(counter):
		var enemy_spawn = new_enemy.instantiate()
		enemy_spawn.global_position = get_random_position()
		mobs.add_child(enemy_spawn)


func get_random_position():
	var sides_screen = get_sides_screen()
	var left = sides_screen['left']
	var top = sides_screen['top']
	var right = sides_screen['right']
	var bottom = sides_screen['bottom']
	
	var top_left = Vector2(left, top)
	var top_right = Vector2(right, top)
	var bottom_left = Vector2(left, bottom)
	var bottom_right = Vector2(right, bottom)
	
	var pos_side = ["up", "down", "right", "left"].pick_random()
	var spawn_pos1 = Vector2.ZERO
	var spawn_pos2 = Vector2.ZERO
	
	match pos_side:
		"up":
			spawn_pos1 = top_left
			spawn_pos2 = top_right
		"down":
			spawn_pos1 = bottom_left
			spawn_pos2 = bottom_right
		"right":
			spawn_pos1 = top_right
			spawn_pos2 = bottom_right
		"left":
			spawn_pos1 = top_left
			spawn_pos2 = bottom_left
	
	var x_spawn = randf_range(spawn_pos1.x, spawn_pos2.x)
	var y_spawn = randf_range(spawn_pos1.y, spawn_pos2.y)
	return Vector2(x_spawn, y_spawn)


func get_sides_screen():
	var camera_position = get_camera().global_position
	var viewport_rect = get_viewport_rect().size * randf_range(1.2, 1.5)

	var left = camera_position.x - viewport_rect.x / 2
	var top = camera_position.y - viewport_rect.y / 2
	var right = left + viewport_rect.x
	var bottom = top + viewport_rect.y
	
	return {
		"left": left,
		"right": right,
		"top": top,
		"bottom": bottom,
		"center_x": camera_position.x,
		"center_y": camera_position.y
	}


func get_camera():
	var player = get_tree().get_first_node_in_group("player")
	var camera = player.camera_2d
	return camera


func _on_timer_timeout():
	time += 1
	handler_timer()
	print(time)

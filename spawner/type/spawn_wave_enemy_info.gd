extends Resource

class_name Spawn_wave_enemy_info

@export var time_start: int
@export var time_end: int
@export var enemy: Resource
@export var enemy_num: int
@export var enemy_spawn_delay:int

var spawn_delay_counter = 0
var index_sub_pool = 0

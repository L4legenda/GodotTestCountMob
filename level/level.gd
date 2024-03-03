extends Node2D

@onready var label_count_mob = $CanvasLayer/LabelCountMob

@onready var mobs = $Mobs

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	label_count_mob.text = str(mobs.get_children().size())

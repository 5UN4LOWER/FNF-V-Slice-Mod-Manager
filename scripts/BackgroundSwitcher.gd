extends Node2D

var bgs:Array = []
@export var bg_positions:Array = []
var current_bg:Sprite2D
var bg_index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		bgs.append(node)
	current_bg = bgs[bg_index]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if current_bg != null:
		current_bg.position = -get_global_mouse_position() / 50 + bg_positions[bg_index]

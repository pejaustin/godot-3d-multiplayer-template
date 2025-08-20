class_name PlayerInput extends Node

var input_dir : Vector2 = Vector2.ZERO
var camera_input : Vector2 = Vector2.ZERO
var jump_input := false
var run_input := false
var attack_input := false

func _ready():
	NetworkTime.before_tick_loop.connect(_gather)

func _gather():
	# In this case, should be client authority
	if is_multiplayer_authority():
		input_dir = Input.get_vector("left", "right", "forward", "backward")
		jump_input = Input.is_action_pressed("jump")
		run_input = Input.is_action_pressed("run")
		attack_input = Input.is_action_pressed("player_action_1")
		camera_input = Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")

func _exit_tree():
	NetworkTime.before_tick_loop.disconnect(_gather)

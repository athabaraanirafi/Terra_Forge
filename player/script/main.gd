extends KinematicBody2D

const state = preload("res://player/script/state.gd")

var PLAYER_STATE = state.PState.IDLE
var PLAYER_DIR = state.Dir.RIGHT

var PLAYER_VELOCITY = Vector2()
const PLAYER_SPEED = 50
const PLAYER_JUMP_MOD = -200

var JUMP_BUFF = 3
var INPUT_POLL = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#Input.is_action_pressed("move_left")
	
#	pass # Replace with function body.

func _physics_process(delta):
	PLAYER_VELOCITY.y += Physics.GRAVITY * delta
	process_input()
	action()
	PLAYER_VELOCITY = move_and_slide(PLAYER_VELOCITY, Vector2.UP)
	
	
func process_input():
	if is_on_floor():
		if Input.is_action_pressed("move_left"):
			PLAYER_DIR = state.Dir.LEFT
			PLAYER_STATE = state.PState.RUN
		elif Input.is_action_pressed("move_right"):
			PLAYER_DIR = state.Dir.RIGHT
			PLAYER_STATE = state.PState.RUN		
		else:
			PLAYER_STATE = state.PState.IDLE
		if Input.is_action_pressed("jump"):
			PLAYER_STATE = state.PState.JUMP
	else:
		PLAYER_STATE = state.PState.FALL
		
func action():
	var speed = 0;
	match PLAYER_DIR:
		state.Dir.LEFT:
			speed = -PLAYER_SPEED
		state.Dir.RIGHT:
			speed = PLAYER_SPEED
	match PLAYER_STATE: 
		state.PState.JUMP:
			PLAYER_VELOCITY.y = PLAYER_JUMP_MOD * JUMP_BUFF
		state.PState.RUN:
			PLAYER_VELOCITY.x += speed
		state.PState.IDLE:
			PLAYER_VELOCITY.x = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

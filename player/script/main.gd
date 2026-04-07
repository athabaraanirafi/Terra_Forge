extends KinematicBody2D

const state = preload("res://player/script/state.gd")

var PLAYER_STATE = state.PState.IDLE
var PLAYER_DIR = state.Dir.RIGHT

var PLAYER_VELOCITY = Vector2()
const PLAYER_SPEED = 30
const PLAYER_SPEED_CAP = 100
const PLAYER_JUMP_MOD = 200
const PLAYER_FRICTION = 20
var JUMP_BUFF = 1
var INPUT_POLL = []

func _ready():
	pass

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
		
		if Input.is_action_pressed("move_left"):
			PLAYER_DIR = state.Dir.LEFT
		elif Input.is_action_pressed("move_right"):
			PLAYER_DIR = state.Dir.RIGHT			
		

func action():
	var speed = 0;
	match PLAYER_DIR:
		state.Dir.LEFT:
			speed = -PLAYER_SPEED
		state.Dir.RIGHT:
			speed = PLAYER_SPEED
	match PLAYER_STATE: 
		state.PState.JUMP:
			PLAYER_VELOCITY.y = -PLAYER_JUMP_MOD - (to_positive(PLAYER_VELOCITY.x) / 2) 
		state.PState.RUN:
			PLAYER_VELOCITY.x += speed
		state.PState.IDLE:
			if PLAYER_VELOCITY.x > 0:
				PLAYER_VELOCITY.x -= PLAYER_FRICTION
			elif PLAYER_VELOCITY.x < 0:
				PLAYER_VELOCITY.x += PLAYER_FRICTION


func to_positive(number: int) -> int:
	if number < 0: 
		return number * -1
	else:
		return number

extends KinematicBody2D

const state = preload("res://player/script/state.gd")

var PLAYER_STATE = state.PState.IDLE
var PLAYER_DIR = state.Dir.RIGHT

var PLAYER_VELOCITY = Vector2()
const PLAYER_SPEED = 600
const PLAYER_SPEED_CAP = 600
const PLAYER_JUMP_MOD = 600
const PLAYER_FRICTION = 20
var JUMP_BUFF = 2
var ACTION_POOL: Array = []

var LAST_TAP = {
	"move_left": 0.0,
	"move_right": 0.0
}

var DASH_TIMER = 0.0
const DASH_DURATION = 0.25

func check_double_tap(action: String) -> bool:
	var current_time = OS.get_ticks_msec() / 1000.0
	
	if current_time - LAST_TAP[action] <= DTAP_THRESHOLD:
		LAST_TAP[action] = 0
		return true
	
	LAST_TAP[action] = current_time
	return false

var DTAP_THRESHOLD = 0.25

func _ready():
	pass

func _physics_process(delta):
	if DASH_TIMER <= 0:
		PLAYER_STATE = state.PState.IDLE
		PLAYER_VELOCITY.y += Physics.GRAVITY * delta
	else:
		DASH_TIMER -= delta
	process_input()		
	action(delta)
	PLAYER_VELOCITY = move_and_slide(PLAYER_VELOCITY, Vector2.UP)
	
	

func process_input():
	if Input.is_action_just_pressed("move_left"):
		PLAYER_DIR = state.Dir.LEFT		
		if check_double_tap("move_left"):
			#PLAYER_STATE = state.PState.DASH
			#print("DOUBLE TAP LEFT")
			ACTION_POOL.push_back(state.Action.DASH)
			return
	elif Input.is_action_just_pressed("move_right"):
		PLAYER_DIR = state.Dir.RIGHT
		if check_double_tap("move_right"):
			#PLAYER_STATE = state.PState.DASH			
			#print("DOUBLE TAP RIGHT")
			ACTION_POOL.push_back(state.Action.DASH)			
			return
	if is_on_floor():
		if Input.is_action_pressed("move_left"):
			#PLAYER_STATE = state.PState.RUN
			PLAYER_DIR = state.Dir.LEFT
			ACTION_POOL.push_back(state.Action.RUN)						
		elif Input.is_action_pressed("move_right"):
			#PLAYER_STATE = state.PState.RUN
			PLAYER_DIR = state.Dir.RIGHT			
			ACTION_POOL.push_back(state.Action.RUN)									
		else:
			ACTION_POOL.push_back(state.Action.IDLE)						
			#PLAYER_STATE = state.PState.IDLE
		if Input.is_action_pressed("jump"):
			#PLAYER_STATE = state.PState.JUMP
			ACTION_POOL.push_back(state.Action.JUMP)									
	else:
		#PLAYER_STATE = state.PState.FALL
		if Input.is_action_pressed("move_left"):
			PLAYER_DIR = state.Dir.LEFT
		elif Input.is_action_pressed("move_right"):
			PLAYER_DIR = state.Dir.RIGHT

func action(delta):
	for action in ACTION_POOL:
		match action:
			state.Action.DASH:
				PLAYER_VELOCITY.x = PLAYER_DIR * 2
				DASH_TIMER = DASH_DURATION
				pass
			state.Action.RUN:
				PLAYER_VELOCITY.x = PLAYER_DIR
				PLAYER_VELOCITY.x = clamp(PLAYER_VELOCITY.x, -PLAYER_SPEED_CAP, PLAYER_SPEED_CAP)
				pass
			state.Action.JUMP:
				PLAYER_VELOCITY.y = -PLAYER_JUMP_MOD
				pass
			state.Action.IDLE:				
				if abs(PLAYER_VELOCITY.x) < PLAYER_FRICTION:
					PLAYER_VELOCITY.x = 0
				else:
					PLAYER_VELOCITY.x -= sign(PLAYER_VELOCITY.x) * PLAYER_FRICTION
				pass
	ACTION_POOL.clear()

func to_positive(number: int) -> int:
	if number < 0:
		return number * -1
	else:
		return number

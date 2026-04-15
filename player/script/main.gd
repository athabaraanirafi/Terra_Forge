extends KinematicBody2D

const state = preload("res://player/script/state.gd")

onready var PLAYER_DIR = state.Dir.RIGHT
onready var PLAYER_VELOCITY = Vector2()
onready var PLAYER_ACTION = state.Action.IDLE
onready var PLAYER_ACTION_PACK = state.Action_Pack[PLAYER_ACTION]
onready var PLAYER_FRAME = PLAYER_ACTION_PACK.Frame
onready var PLAYER = $AnimatedSprite
onready var LEFT_HAND = $LeftHand
onready var RIGHT_HAND = $RightHand
var FLOORED = false

func _reassign_frame():
	PLAYER_ACTION_PACK = state.Action_Pack[PLAYER_ACTION]
	PLAYER_FRAME = PLAYER_ACTION_PACK.Frame

func _change_action(action):
	PLAYER_ACTION = action
	_reassign_frame()

func _change_dir(dir):
	match dir:
		state.Dir.LEFT:
			PLAYER.flip_h = false
		state.Dir.RIGHT:
			PLAYER.flip_h = true
	PLAYER_DIR = dir
	
func _ready():
	_change_dir(PLAYER_DIR)

func _physics_process(delta):
	FLOORED = is_on_floor()
	
	PLAYER_VELOCITY.y += Physics.GRAVITY * delta
	if PLAYER_FRAME != 0:
		PLAYER_FRAME -= 1
	else:
		if FLOORED:
			_change_action(PLAYER_ACTION_PACK.Floor)
		else:
			_change_action(PLAYER_ACTION_PACK.Float)
	process_input()
	_action_process()
	#PLAYER.play("LANDING")
	PLAYER_VELOCITY = move_and_slide(PLAYER_VELOCITY, Vector2.UP)


func process_input():
	if Input.is_action_just_pressed("left_hand"):
		LEFT_HAND.attack()
		pass
	if Input.is_action_just_pressed("right_hand"):
		RIGHT_HAND.attack()
		pass
	#if is_on_floor() && PLAYER_ACTION != state.Action.JUMP | state.Action.FALL | state.Action.SLIDE:
	if FLOORED:
		if Input.is_action_pressed("move_left"):
			_change_action(state.Action.RUN)			
			_change_dir(state.Dir.LEFT)
			pass
		elif Input.is_action_pressed("move_right"):
			_change_action(state.Action.RUN)			
			_change_dir(state.Dir.RIGHT)			
			pass
		if Input.is_action_just_pressed("jump"):
			if Input.is_action_pressed("crouch"):
				_change_action(state.Action.SLIDE)
			else:
				_change_action(state.Action.JUMP)
	else:
		pass

func _action_process():
	match PLAYER_ACTION:
		state.Action.JUMP:
			PLAYER.play("JUMP")
			PLAYER_VELOCITY.y = state.JUMP_MOD
		state.Action.IDLE:
			PLAYER.play("IDLE")
			PLAYER_VELOCITY.x = 0
		state.Action.FALL:
			PLAYER.play("FALL")
		state.Action.RUN:
			PLAYER_VELOCITY.x = PLAYER_DIR
			PLAYER.play("RUN")
		state.Action.SLIDE:
			PLAYER.play("SLIDE")
			PLAYER_VELOCITY.x = PLAYER_DIR * 2
		state.Action.LANDING:
			PLAYER.play("LANDING")

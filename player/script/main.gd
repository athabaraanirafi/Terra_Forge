extends KinematicBody2D

const state = preload("res://player/script/state.gd")

onready var PLAYER_DIR = state.Dir.RIGHT
onready var PLAYER_VELOCITY = Vector2()
onready var PLAYER_ACTION = state.Action.IDLE
onready var PLAYER_LAST_ACTION = PLAYER_ACTION
onready var PLAYER_ACTION_PACK = state.Action_Pack[PLAYER_ACTION]
onready var PLAYER_FRAME = PLAYER_ACTION_PACK.Frame
onready var PLAYER = $AnimatedSprite
onready var PLAYER_HURT_BOX = $HurtBox/CollisionShape2D
onready var PLAYER_HURT_BOX_ANCHOR = Vector2(PLAYER_HURT_BOX.shape.extents.x, PLAYER_HURT_BOX.shape.extents.y)
onready var PLAYER_HURT_BOX_ANCHOR_POS = Vector2(PLAYER_HURT_BOX.position)
onready var LEFT_HAND = $LeftHand
onready var RIGHT_HAND = $RightHand
onready var PLAYER_IS = state.Is.FLOATING
onready var COYOTE_FRAME = state.COYOTE_FRAME

func _reassign_frame():
	PLAYER_ACTION_PACK = state.Action_Pack[PLAYER_ACTION]
	PLAYER_FRAME = PLAYER_ACTION_PACK.Frame

func _change_action(action):
	PLAYER_LAST_ACTION = PLAYER_ACTION
	PLAYER_ACTION = action
	_reassign_frame()

func _change_dir(dir) -> bool:
	var changed = PLAYER_DIR == dir
	match dir:
		state.Dir.LEFT:
			PLAYER.flip_h = false
		state.Dir.RIGHT:
			PLAYER.flip_h = true
	PLAYER_DIR = dir
	return changed

func _process_position():
	if is_on_floor():
		COYOTE_FRAME = state.COYOTE_FRAME
		if Input.is_action_pressed("crouch"):
			PLAYER_IS = state.Is.CROUCHING
		else:
			PLAYER_IS = state.Is.STANDING
	else:
		if COYOTE_FRAME > 0:
			COYOTE_FRAME -= 1
			PLAYER_IS = state.Is.STANDING
		else:
			PLAYER_IS = state.Is.FLOATING

func _ready():
	_change_dir(PLAYER_DIR)

func _physics_process(delta):
	_process_position()
	PLAYER_VELOCITY.y += Physics.GRAVITY * delta
	if PLAYER_FRAME != 0:
		PLAYER_FRAME -= 1
	else:
		_change_action(PLAYER_ACTION_PACK[PLAYER_IS])
		_process_input()
	_cancellable_input()
	_process_attack()
	_action_process()
	# _determine_hitbox()
	#_determine_hitbox()
	#PLAYER.play("LANDING")
	PLAYER_VELOCITY = move_and_slide(PLAYER_VELOCITY, Vector2.UP)

func _cancellable_input():
	match PLAYER_IS:
		state.Is.STANDING:
			if Input.is_action_pressed("jump"):
				_change_action(state.Action.JUMP)
			pass
		state.Is.FLOATING:
			if Input.is_action_pressed("move_right"):
				_change_dir(state.Dir.RIGHT)
				PLAYER_VELOCITY.x = PLAYER_DIR
				pass
			elif Input.is_action_pressed("move_left"):
				_change_dir(state.Dir.LEFT)
				PLAYER_VELOCITY.x = PLAYER_DIR
				pass
		state.Is.CROUCHING:
			if Input.is_action_just_pressed("jump") and PLAYER_ACTION != state.Action.SLIDE:
				_change_action(state.Action.SLIDE)
			pass


func _process_input():
	match PLAYER_IS:
		state.Is.STANDING:
			if Input.is_action_pressed("move_left"):
				match PLAYER_LAST_ACTION:
					state.Action.IDLE:
						_change_action(state.Action.RUN_START)
						pass
					state.Action.RUN_START:
						_change_action(state.Action.RUN)
						pass
					state.Action.RUN:
						_change_action(state.Action.RUN)
						pass
				_change_dir(state.Dir.LEFT)
			elif Input.is_action_pressed("move_right"):
				match PLAYER_LAST_ACTION:
					state.Action.IDLE:
						_change_action(state.Action.RUN_START)
						pass
					state.Action.RUN_START:
						_change_action(state.Action.RUN)
						pass
					state.Action.RUN:
						_change_action(state.Action.RUN)
						pass
				_change_dir(state.Dir.RIGHT)
			
		state.Is.FLOATING:
			pass
		state.Is.CROUCHING:
			#if Input.is_action_pressed("jump") and PLAYER_ACTION != state.Action.SLIDE:
			#	_change_action(state.Action.SLIDE)
			pass

func _process_attack():
	if Input.is_action_just_pressed("left_hand"):
		LEFT_HAND.attack()
		pass
	if Input.is_action_just_pressed("right_hand"):
		RIGHT_HAND.attack()
		pass

func _change_hurtbox(hurt_box):
	match hurt_box:
		state.HurtBox.FULL:
			var shape = PLAYER_HURT_BOX.shape
			shape.extents = Vector2(PLAYER_HURT_BOX_ANCHOR.x, PLAYER_HURT_BOX_ANCHOR.y)
			PLAYER_HURT_BOX.position = PLAYER_HURT_BOX_ANCHOR_POS
			pass
		state.HurtBox.HALF:
			var shape = PLAYER_HURT_BOX.shape
			shape.extents = Vector2(PLAYER_HURT_BOX_ANCHOR.x, PLAYER_HURT_BOX_ANCHOR.y / 2)
			var offset = PLAYER_HURT_BOX_ANCHOR.y - shape.extents.y
			PLAYER_HURT_BOX.position.y = offset
			pass

# func _determine_hitbox():
# 	match PLAYER_IS:
# 		state.Is.STANDING:
# 			var shape = PLAYER_HURT_BOX.shape
# 			shape.extents = Vector2(PLAYER_HURT_BOX_ANCHOR.x, PLAYER_HURT_BOX_ANCHOR.y)
# 			PLAYER_HURT_BOX.position = PLAYER_HURT_BOX_ANCHOR_POS
# 		state.Is.FLOATING:
# 			pass
# 		state.Is.CROUCHING:
# 			var shape = PLAYER_HURT_BOX.shape
# 			shape.extents = Vector2(PLAYER_HURT_BOX_ANCHOR.x, PLAYER_HURT_BOX_ANCHOR.y / 2)
# 			var offset = PLAYER_HURT_BOX_ANCHOR.y - shape.extents.y
# 			PLAYER_HURT_BOX.position.y = offset

func _action_process():
	match PLAYER_ACTION:
		state.Action.JUMP:
			PLAYER.play("JUMP")
			PLAYER_VELOCITY.y = state.JUMP_MOD
		state.Action.IDLE:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER.play("IDLE")
			PLAYER_VELOCITY.x = 0
		state.Action.CROUCH_IDLE:
			_change_hurtbox(state.HurtBox.HALF)
			PLAYER.play("CROUCH_IDLE")
			PLAYER_VELOCITY.x = 0
		state.Action.CROUCH_UP:
			_change_hurtbox(state.HurtBox.HALF)
			PLAYER.play("CROUCH_UP")
		state.Action.CROUCH_START:
			_change_hurtbox(state.HurtBox.HALF)
			PLAYER.play("CROUCH_START")
		state.Action.FALL:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER.play("FALL")
		state.Action.RUN:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER_VELOCITY.x = PLAYER_DIR
			PLAYER.play("RUN")
		state.Action.RUN_START:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER_VELOCITY.x = PLAYER_DIR
			PLAYER.play("RUN_STARTUP")
		state.Action.SLIDE:
			_change_hurtbox(state.HurtBox.HALF)
			PLAYER.play("SLIDE")
			PLAYER_VELOCITY.x = PLAYER_DIR * 2
		state.Action.LANDING:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER_VELOCITY.x = 0
			PLAYER.play("LANDING")

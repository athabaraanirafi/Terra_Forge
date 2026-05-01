extends KinematicBody2D

const state = preload("res://player/script/state.gd")
const sig = preload("res://player/attack/sig-def.gd")

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
onready var HAND = $Hand
onready var PLAYER_IS = state.Is.FLOATING
onready var COYOTE_FRAME = state.COYOTE_FRAME
onready var HURT_BOX = $HurtBox

func _reassign_frame():
	PLAYER_ACTION_PACK = state.Action_Pack[PLAYER_ACTION]
	PLAYER_FRAME = PLAYER_ACTION_PACK.Frame

func _change_action(action):
	PLAYER_LAST_ACTION = PLAYER_ACTION
	PLAYER_ACTION = action
	_reassign_frame()

func _change_dir(dir) -> bool:
	var changed = PLAYER_DIR != dir
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
	Player.PLAYER = self
	HURT_BOX.connect(sig.DEAL_STUN, self, "_on_stun")
	_change_dir(PLAYER_DIR)

func _on_stun(time):
	_cancel_attack()
	_change_action(state.Action.STUN)
	PLAYER_FRAME = time

func _cancel_attack():
	HAND.deactivate()
	PLAYER.show()

func _physics_process(delta):
	_process_position()
	if PLAYER_ACTION != state.Action.JUMP:
		PLAYER_VELOCITY.y += Physics.GRAVITY * delta
	if PLAYER_FRAME != 0:
		PLAYER_FRAME -= 1
	else:
		_change_action(PLAYER_ACTION_PACK[PLAYER_IS])
		_process_input()
	_cancellable_input()
	_process_attack()
	_action_process()
	PLAYER_VELOCITY = move_and_slide(PLAYER_VELOCITY, Vector2.UP)

func _cancellable_input():
	match PLAYER_IS:
		state.Is.STANDING:
			if Input.is_action_pressed("jump"):
				PLAYER_VELOCITY.y += state.JUMP_BOOST
				_change_action(state.Action.JUMP)
				_cancel_attack()
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

func _process_move():
	match PLAYER_LAST_ACTION:
		state.Action.IDLE:
			_change_action(state.Action.RUN_START)
			pass
		state.Action.RUN_START:
			# if dir_changed:
				# _change_action(state.Action.RUN_FLIP)
			# else:
			_change_action(state.Action.RUN)
			# pass
		state.Action.RUN:
			# if dir_changed:
				# _change_action(state.Action.RUN_FLIP)
			# else:
			_change_action(state.Action.RUN)
			# pass


func _process_input():

	match PLAYER_IS:
		state.Is.STANDING:
			if Input.is_action_pressed("move_left"):
				_change_dir(state.Dir.LEFT)
					# print("here")
					# return
				_process_move()
			elif Input.is_action_pressed("move_right"):
				_change_dir(state.Dir.RIGHT)
					# print("here")
					# return
				_process_move()

		state.Is.FLOATING:
			pass
		state.Is.CROUCHING:
			if Input.is_action_pressed("move_left"):
				_change_dir(state.Dir.LEFT)
			elif Input.is_action_pressed("move_right"):
				_change_dir(state.Dir.RIGHT)


func _process_attack():
	if PLAYER_ACTION != state.Action.ATTACK:
		if Input.is_action_pressed("left_hand"):
			var frame = HAND.activate(state.Hand.LEFT,PLAYER_DIR, PLAYER_IS, PLAYER_ACTION)
			_change_action(state.Action.ATTACK)
			PLAYER_FRAME = frame
			# print("Left!")
			# print(frame)
			#PLAYER.hide()
			pass
		elif Input.is_action_pressed("right_hand"):
			var frame = HAND.activate(state.Hand.RIGHT,PLAYER_DIR, PLAYER_IS, PLAYER_ACTION)
			_change_action(state.Action.ATTACK)
			PLAYER_FRAME = frame
		# 	# print("Right!")
			# print(frame)
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

func _action_process():
	match PLAYER_ACTION:
		state.Action.JUMP:
			HAND.deactivate()
			PLAYER.show()
			PLAYER.play("JUMP")
			PLAYER_VELOCITY.y += state.JUMP_MOD
		state.Action.JUMP_START:
			PLAYER.play("JUMP")
			PLAYER_VELOCITY.y += state.JUMP_BOOST			
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
			PLAYER_VELOCITY.y += state.FALL_MOD
			PLAYER.play("FALL")
		state.Action.RUN:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER_VELOCITY.x = PLAYER_DIR
			PLAYER.play("RUN")
		state.Action.RUN_START:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER_VELOCITY.x = PLAYER_DIR
			PLAYER.play("RUN_STARTUP")
		state.Action.RUN_STOP:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER_VELOCITY.x = PLAYER_DIR / 2
			PLAYER.play("RUN_STOP")
		state.Action.RUN_FLIP:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER_VELOCITY.x = PLAYER_DIR / 26
			PLAYER.play("RUN_FLIP")
		state.Action.SLIDE:
			_change_hurtbox(state.HurtBox.HALF)
			PLAYER.play("SLIDE")
			PLAYER_VELOCITY.x = PLAYER_DIR * 2
		state.Action.LANDING:
			_change_hurtbox(state.HurtBox.FULL)
			PLAYER_VELOCITY.x = 0
			PLAYER.play("LANDING")
		state.Action.ATTACK:
			# print(PLAYER_FRAME)			
			PLAYER_VELOCITY.x = 0
			HAND.attack(PLAYER_FRAME)
			if PLAYER_FRAME <= 0:
				HAND.deactivate()
				PLAYER.show()
			else:
				PLAYER.hide()
		state.Action.STUN:
			PLAYER_VELOCITY.x = 0
			PLAYER.play("STUN")

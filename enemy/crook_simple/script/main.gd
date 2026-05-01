extends KinematicBody2D

const include = preload("res://enemy/crook_simple/script/include.gd")
const Bullet = preload("res://enemy/crook_simple/scene/bullet.tscn")
const sig = preload("res://player/attack/sig-def.gd")

const RANGE = 400
const PERSONAL_SPACE = 200

enum Player_Is {
	NO_PROBLEM,
	TOO_CLOSE,
	TOO_FAR,
	IN_RANGE,
}

enum Action {
	PURSUE,
	BACK_AWAY,
	SHOOTING,
	IDLE,
	STUNNED
}

const Action_Pack = {
	Action.IDLE: {
		"Frame": 1,
		Player_Is.NO_PROBLEM: Action.IDLE,
		Player_Is.TOO_CLOSE: Action.BACK_AWAY,
		Player_Is.TOO_FAR: Action.PURSUE,
		Player_Is.IN_RANGE: Action.SHOOTING
	},
	Action.PURSUE: {
		"Frame": 1,
		Player_Is.NO_PROBLEM: Action.IDLE,
		Player_Is.TOO_CLOSE: Action.BACK_AWAY,
		Player_Is.TOO_FAR: Action.PURSUE,
		Player_Is.IN_RANGE: Action.SHOOTING
	},
	Action.SHOOTING: {
		"Frame": 60,
		Player_Is.NO_PROBLEM: Action.IDLE,
		Player_Is.TOO_CLOSE: Action.BACK_AWAY,
		Player_Is.TOO_FAR: Action.PURSUE,
		Player_Is.IN_RANGE: Action.SHOOTING
	},
	Action.BACK_AWAY: {
		"Frame": 1,
		Player_Is.NO_PROBLEM: Action.IDLE,
		Player_Is.TOO_CLOSE: Action.BACK_AWAY,
		Player_Is.TOO_FAR: Action.PURSUE,
		Player_Is.IN_RANGE: Action.SHOOTING
	},
}

onready var CROOK = $AnimatedSprite
onready var VELOCITY = Vector2()
onready var PLAYER_IS = Player_Is.NO_PROBLEM
onready var ACTION = Action.IDLE
onready var ACTION_PACK = Action_Pack[ACTION]
onready var FRAME = ACTION_PACK.Frame
onready var DIR = include.Dir.RIGHT
onready var MUZZLE = $Muzzle
onready var HURT_BOX = $HurtBox

func _opposite() -> int:
	var dir
	match DIR:
		include.Dir.RIGHT:
			dir = include.Dir.LEFT
		include.Dir.LEFT:
			dir = include.Dir.RIGHT
	return dir

func _reassign_frame():
	ACTION_PACK = Action_Pack[ACTION]
	FRAME = ACTION_PACK.Frame

func _change_action(action):
	ACTION = action
	_reassign_frame()

func _ready():
	pass

func _connet():
	# print()
	pass

func _player_is():
	var left = self.position.x - PERSONAL_SPACE
	var right = self.position.x + PERSONAL_SPACE
		
	if Player.PLAYER.position.x > left and Player.PLAYER.position.x < right:
		PLAYER_IS = Player_Is.TOO_CLOSE
		return
		
	left = self.position.x - RANGE
	right = self.position.x + RANGE
	if Player.PLAYER.position.x > left and Player.PLAYER.position.x < right:
		PLAYER_IS = Player_Is.IN_RANGE
	else:
		PLAYER_IS = Player_Is.TOO_FAR
	

func _change_dir():
	if Player.PLAYER.position.x > self.position.x:
		DIR = include.Dir.RIGHT
		CROOK.flip_h = true
		pass
	else:
		DIR = include.Dir.LEFT
		CROOK.flip_h = false
	pass

func _physics_process(delta):
	VELOCITY.y += Physics.GRAVITY * delta
	if FRAME != 0:
		FRAME -= 1
	else:
		_change_dir()
		_player_is()
		_change_action(ACTION_PACK[PLAYER_IS])
	_process_action()

	VELOCITY = move_and_slide(VELOCITY, Vector2.UP)

func _process_action():
	match ACTION:
		Action.IDLE:
			CROOK.play("IDLE")
		Action.PURSUE:
			CROOK.play("PURSUE")
			VELOCITY.x = DIR
		Action.SHOOTING:
			match FRAME:
				20:
					_shoot()
				40:
					_shoot()
				60:
					_shoot()
			CROOK.play("SHOOT")
		Action.BACK_AWAY:
			VELOCITY.x = _opposite()
			CROOK.play("PURSUE")
			
func _shoot():
	var bullet = Bullet.instance()
	bullet.global_position = MUZZLE.global_position
	get_tree().current_scene.add_child(bullet)
	bullet.shoot(DIR)
	VELOCITY.x = 0
	

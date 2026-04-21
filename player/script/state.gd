# Ini langsung ubah aja buat play test
const PLAYER_SPEED = 260
const JUMP_MOD = -200
const COYOTE_FRAME = 20

enum Action {
	RUN,
	RUN_START,
	RUN_STOP,
	RUN_FLIP,
	IDLE,
	JUMP,
	SLIDE,
	FALL,
	LANDING,
	CROUCH_START,
	CROUCH_UP,
	CROUCH_IDLE,
}

enum Is {
	STANDING,
	FLOATING,
	CROUCHING,
}

enum HurtBox {
	FULL,
	HALF,
}

# Jadi value disini korespon terhadap "lamanya" aksi itu nanti, per frame based
# Fi, kamu bisa tweak sesuka hati pas testing dsb, this is the real reason i do it like this
const Action_Pack = {
	Action.RUN: {
		"Frame": 1,
		Is.STANDING: Action.RUN_STOP,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_START,
	},
	Action.RUN_START: {
		"Frame": 22,
		Is.STANDING: Action.RUN_STOP,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_START,
	},
	Action.RUN_STOP: {
		"Frame": 12,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_START,
	},
	Action.RUN_FLIP: {
		"Frame": 12,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_START,
	},
	Action.IDLE: {
		"Frame": 1,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_START
	},
	Action.CROUCH_IDLE: {
		"Frame": 1,
		Is.STANDING: Action.CROUCH_UP,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_IDLE
	},
	Action.CROUCH_UP: {
		"Frame": 15,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_IDLE
	},
	Action.CROUCH_START: {
		"Frame": 11,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_IDLE
	},
	Action.JUMP: {
		"Frame": 60,
		Is.STANDING: Action.LANDING,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.FALL
	},
	Action.FALL: {
		"Frame": 1,
		Is.STANDING: Action.LANDING,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.LANDING,
	},
	Action.LANDING: {
		"Frame": 20,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_IDLE,
	},
	Action.SLIDE: {
		"Frame": 20,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_IDLE,
	}
}

enum Dir {
	LEFT = - PLAYER_SPEED,
	RIGHT = PLAYER_SPEED,
}

# class Runnable:
# 	func run() -> int:
# 		return Action.IDLE

# class Run:
# 	func run(prev_action: int, current_dir: int, player_is: int):
# 		pass
# Ini langsung ubah aja buat play test
const PLAYER_SPEED = 200
const JUMP_MOD = -200
const COYOTE_FRAME = 20

enum Action {
	RUN,
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

# Jadi value disini korespon terhadap "lamanya" aksi itu nanti, per frame based
# Fi, kamu bisa tweak sesuka hati pas testing dsb, this is the real reason i do it like this
const Action_Pack = {
	Action.RUN: {
		"Frame": 1,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.IDLE,
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
		"Frame": 40,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.CROUCH_IDLE,
	}
}

enum Dir {
	LEFT = -PLAYER_SPEED,
	RIGHT = PLAYER_SPEED,
}

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
	IDLE_CROUCH,
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
		Is.CROUCHING: Action.IDLE_CROUCH
	},
	Action.IDLE_CROUCH: {
		"Frame": 1,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.IDLE_CROUCH
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
		Is.CROUCHING: Action.IDLE_CROUCH,
	},
	Action.SLIDE: {
		"Frame": 40,
		Is.STANDING: Action.IDLE,
		Is.FLOATING: Action.FALL,
		Is.CROUCHING: Action.IDLE_CROUCH,
	}
}

enum Dir {
	LEFT = -PLAYER_SPEED,
	RIGHT = PLAYER_SPEED,
}

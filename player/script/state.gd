# Ini langsung ubah aja buat play test
const PLAYER_SPEED = 200
const JUMP_MOD = -200

enum Action {
	RUN,
	IDLE,
	JUMP,
	SLIDE,
	FALL,
	LANDING,
	CROUCH,
}

# Jadi value disini korespon terhadap "lamanya" aksi itu nanti, per frame based
const Action_Pack = {
	Action.RUN: {
		"Frame": 1,
		"Floor": Action.IDLE,
		"Float": Action.FALL
	},
	Action.CROUCH: {
		"Frame": 1,
		"Floor": Action.IDLE,
		"Float": Action.FALL
	},
	Action.IDLE: {
		"Frame": 1,
		"Floor": Action.IDLE,
		"Float": Action.FALL
	},
	Action.JUMP: {
		"Frame": 60,
		"Floor": Action.LANDING,
		"Float": Action.FALL
	},
	Action.FALL: {
		"Frame": 1,
		"Floor": Action.LANDING,
		"Float": Action.FALL
	},
	Action.LANDING: {
		"Frame": 25,
		"Floor": Action.IDLE,
		"Float": Action.FALL
	},
	Action.SLIDE: {
		"Frame": 40,
		"Floor": Action.IDLE,
		"Float": Action.FALL
	}
}

enum Dir {
	LEFT = -PLAYER_SPEED,
	RIGHT = PLAYER_SPEED,
}

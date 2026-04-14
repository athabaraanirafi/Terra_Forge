# Ini langsung ubah aja buat play test
const PLAYER_SPEED = 200
const JUMP_MOD = -200


enum Action {
	RUN,
	RUN_STARTUP,
	IDLE,
	JUMP,
	SLIDE,
	FALL,
}

# Jadi value disini korespon terhadap "lamanya" aksi itu nanti, per frame based
const Action_Frame = {
	Action.RUN: 1,
	Action.IDLE: 1,
	Action.JUMP: 60,
	Action.FALL: 40,
	Action.SLIDE: 40
}

enum Dir {
	LEFT = -PLAYER_SPEED,
	RIGHT = PLAYER_SPEED,
}

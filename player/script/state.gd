enum PState {
	RUN,
	IDLE,
	JUMP,
	DASH,
	FALL
}

enum Action {
	RUN,
	IDLE,
	JUMP,
	DASH,
}

const PLAYER_SPEED = 330

enum Dir {
	LEFT = -PLAYER_SPEED,
	RIGHT = PLAYER_SPEED,
}

enum Pressed {
	
}

func start() -> int:
	return PState.Idle

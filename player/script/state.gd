enum PState {
	RUN,
	IDLE,
	JUMP,
	DASH,
	FALL
}
const PLAYER_SPEED = 600

enum Dir {
	LEFT = -PLAYER_SPEED,
	RIGHT = PLAYER_SPEED,
}

enum Pressed {
	
}

func start() -> int:
	return PState.Idle

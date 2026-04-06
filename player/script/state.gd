enum PState {
	RUN,
	IDLE,
	JUMP,
	DASH,
	FALL
}

enum Dir {
	LEFT,
	RIGHT,
}

enum Pressed {
	
}

func start() -> int:
	return PState.Idle

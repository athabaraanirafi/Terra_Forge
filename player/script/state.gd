enum PState {
	Run,
	Idle,
	Startup,
	Jump,
	Dash,
}

func start() -> int:
	return PState.Idle

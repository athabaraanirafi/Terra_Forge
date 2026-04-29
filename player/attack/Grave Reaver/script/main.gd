extends Node2D

const state = preload("res://player/script/state.gd")

const FRAME = 30
onready var SPRITE = $AnimatedSprite

# func _set_activation_state(state):
	
	# set_process(state)
	# set_physics_process(state)
	# visible = state


func _ready():
	SPRITE.hide()
	# _set_activation_state(false)
	pass # Replace with function body.

# func _physics_process(_delta):

func activate(player_dir, player_is, player_action) -> int:
	# _set_activation_state(true)
	
	# func _change_dir(dir) -> bool:
		# var changed = PLAYER_DIR != dir
	match player_dir:
		state.Dir.LEFT:
			SPRITE.flip_h = false
		state.Dir.RIGHT:
			SPRITE.flip_h = true
		# PLAYER_DIR = dir
		# return changed
	# if SPRITE == null: 
	# 	print("null!")
	# 	return 0
	SPRITE.show()
	return FRAME

func deactivate():
	SPRITE.hide()
	# _set_activation_state(false)

func attack(frame) -> int:
	if frame > 0:
		_active_frame(frame)
		return state.Weapon.ACTIVE
	else:
		SPRITE.hide()
		SPRITE.frame = 0
		# _set_activation_state(false)
		return state.Weapon.HIDDEN

func _active_frame(_frame):
	SPRITE.play("DEFAULT_ATTACK")


extends Area2D


const include = preload("res://enemy/crook_simple/script/include.gd")
const sig = preload("res://player/attack/sig-def.gd")

enum Action {
	FLYING,
	EXPLODE,
	FREE_SELF,
}

const Action_Pack = {
	Action.FLYING: {
		"Frame": 1,
		"Next": Action.FLYING
	},
	Action.EXPLODE: {
		"Frame": 10,
		"Next": Action.FREE_SELF
	},
	Action.FREE_SELF: {
		"Frame": 1
	}
}

signal deal_damage(damage)

onready var DIR = include.Dir.LEFT
onready var BULLET = $AnimatedSprite
onready var ON_SCREEN = $OnScreen
onready var ACTION = Action.FREE_SELF
onready var ACTION_PACK = Action_Pack[ACTION]
onready var FRAME = 0
 
func _ready():
	set_process(false)
	set_physics_process(false)
	visible = false
	ON_SCREEN.connect("screen_exited", self, "_free")
	pass

func _on_damage(dmg):
	_set_action(Action.EXPLODE)
	pass
	
func _free():
	queue_free()

func _set_action(action):
	ACTION = action
	ACTION_PACK = Action_Pack[ACTION]
	FRAME = ACTION_PACK.Frame

func shoot(dir):
	set_process(true)
	set_physics_process(true)
	visible = true
	self.connect(sig.DEAL_DAMAGE, self, "_on_damage")
	DIR = dir
	_set_action(Action.FLYING)
	match DIR:
		include.Dir.RIGHT:
			BULLET.flip_h = true
		include.Dir.LEFT:
			BULLET.flip_h = false
	pass

func _physics_process(delta):
	if FRAME != 0:
		FRAME -= 1
	else:
		_set_action(ACTION_PACK.Next)
	_action(delta)	
	pass

func _action(delta):
	match ACTION:
		Action.FLYING:
			self.position.x += DIR * delta
			BULLET.play("FLYING")
		Action.FREE_SELF:
			queue_free()
		Action.EXPLODE:
			self.position.x = 0
			BULLET.play("EXPLODE")

func _on_hit(body):
	body.emit_signal(sig.DEAL_STUN, 20)

extends Area2D

const include = preload("res://enemy/crook_simple/script/include.gd")

onready var DIR = include.Dir.LEFT
onready var BULLET = $AnimatedSprite
onready var ON_SCREEN = $OnScreen
func _ready():
	set_process(false)
	set_physics_process(false)
	visible = false
	ON_SCREEN.connect("screen_exited", self, "_free")
	pass
func _free():
	queue_free()

func shoot(dir):
	set_process(true)
	set_physics_process(true)
	visible = true
	DIR = dir
	match DIR:
		include.Dir.RIGHT:
			BULLET.flip_h = true
		include.Dir.LEFT:
			BULLET.flip_h = false
	pass

func _physics_process(delta):
	self.position.x += DIR * delta
	BULLET.play("FLYING")	
	pass

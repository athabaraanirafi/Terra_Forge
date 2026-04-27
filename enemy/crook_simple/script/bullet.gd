# TO-DO: Implement the bullet animation and movement, maybe also add some explodification
# TO-DO: Mungkin bullet scene itu di attach sekalian sama crook biar gak perlu di load 
# TO-DO: pas keluar.
# TO-DO: Which does makes it easier buat naruh posisi keluarnya dimana.
# TO-DO: Oh ya, kalau ACTIVE == false. ini object jadi inert (gak kelihatan) sekalian.
# TO-DO: Terus kalau udah nabrak object atau keluar dari layar ini object
# TO-DO: langsung dibalikin ke Crook terus dijadiin inert. 


extends Area2D

const include = preload("res://enemy/crook_simple/script/include.gd")

onready var BULLET = $AnimatedSprite
onready var DIR = include.Dir.LEFT
onready var ACTIVE = false

func _ready():
	ACTIVE = false
	pass
	
func _shoot(dir):
	DIR = dir
	match DIR:
		include.Dir.RIGHT:
			BULLET.flip_h = true
		include.Dir.LEFT:
			BULLET.flip_h = false
	pass

func _physics_process(delta):
	if !ACTIVE:
		return
	self.position.x += DIR * delta
	ACTIVE.play("FLYING")	
	pass

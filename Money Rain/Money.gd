extends Sprite

const MIN_SPEED = 400
const MAX_SPEED = 600
const MIN_ROT_SPEED = -0.6
const MAX_ROT_SPEED = 0.6
const MIN_SCALE = 0.48
const MAX_SCALE = 0.52

var velocity = Vector2()
var target_dir = Vector2()

onready var speed = rand_range(MIN_SPEED, MAX_SPEED)
onready var rot_speed = rand_range(MIN_ROT_SPEED, MAX_ROT_SPEED)
onready var sprite_scale = rand_range(MIN_SCALE, MAX_SCALE)

func _ready():
	scale = Vector2(sprite_scale, sprite_scale)

func _physics_process(delta):
	velocity = target_dir * speed
	position += velocity * delta
	
	rotation += rot_speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

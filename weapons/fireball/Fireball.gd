extends Area2D

const SPEED = 100

var velocity = Vector2()
var direction = 1 # 1 Right, -1 Left


func set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("shoot")


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Fireball_body_entered(body):
	if body.is_in_group("Enemy"):
		print(body)
		body.dead()
	queue_free()

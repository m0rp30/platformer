extends KinematicBody2D

const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)

export(int) var spped = 30
export(int) var life = 1

var velocity = Vector2()
var direction = 1
var is_deat = false

func _physics_process(delta):
	if is_deat == false:
		velocity.x = SPEED * direction
		
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		$AnimatedSprite.play("walk")
		
		velocity.y += GRAVITY
		velocity = move_and_slide(velocity, FLOOR)
		
	if is_on_wall():
		direction *= -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction *= -1
		$RayCast2D.position.x *= -1
	
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			if get_slide_collision(i).collider.is_in_group("Player"):
				print(get_slide_collision(i).collider)
				get_slide_collision(i).collider.dead()


func dead(weapon_power):
	life -= weapon_power
	if life <= 0:
		is_deat = true
		velocity = Vector2.ZERO
		$AnimatedSprite.play("dead")
		$CollisionShape2D.set_deferred("disabled", true)
		$Timer.start()


func _on_Timer_timeout():
	queue_free()

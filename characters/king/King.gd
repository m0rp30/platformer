extends KinematicBody2D

const GRAVITY = 10
const FLOOR = Vector2(0, -1)
#const FIREBALL = preload("res://weapons/fireball/Fireball.tscn")
const FIREBALL = preload("res://weapons/white_fireball/White_fireball.tscn")

export var speed = 75
export var jump_power = 250

var velocity = Vector2()
var on_ground = false
var is_attacking = false


# warning-ignore:unused_argument
func _physics_process(delta):
	
	# Movimento destra/sinistra
	if Input.is_action_pressed("ui_right"):
		if is_attacking == false || is_on_floor() == false:
			velocity.x = speed
			if is_attacking == false:
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = false
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
	elif Input.is_action_pressed("ui_left"):
		if is_attacking == false || is_on_floor() == false:
			velocity.x = -speed
			if is_attacking == false:
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = true
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
	else:
		velocity.x = 0
		if on_ground == true && is_attacking == false:
			$AnimatedSprite.play("idle")

	# Movimento alto/basso
	if Input.is_action_pressed("ui_up"):
		if is_attacking == false:
			if on_ground == true:
				velocity.y = -jump_power
				on_ground = false
	
	if Input.is_action_just_pressed("ui_accept") && is_attacking == false:
		if is_on_floor():
			velocity.x = 0
		is_attacking = true
		$AnimatedSprite.play("slash")
		var fireball = FIREBALL.instance()
		if sign($Position2D.position.x) == 1:
			fireball.set_fireball_direction(1)
		else:
			fireball.set_fireball_direction(-1)
		get_parent().add_child(fireball)
		fireball.position = $Position2D.global_position

	velocity.y +=  GRAVITY

	if is_on_floor():
		if on_ground == false:
			is_attacking == false
		on_ground = true
	else:
		if is_attacking == false:
			on_ground = false
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				$AnimatedSprite.play("fall")

	velocity = move_and_slide(velocity, FLOOR)


func _on_AnimatedSprite_animation_finished():
	is_attacking = false

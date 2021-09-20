extends KinematicBody2D

const FLOOR = Vector2(0, -1)
const FIREBALLRED = preload("res://weapons/fireball/Fireball.tscn")
const FIREBALLWHITE = preload("res://weapons/white_fireball/White_fireball.tscn")

export var speed = 75
export var jump_power = 250

var on_ladder = false
var gravity = 10
var velocity = Vector2()
var on_ground = false
var is_attacking = false
var is_dead = false
var weapon_power = 1


# warning-ignore:unused_argument
func _physics_process(delta):
	if is_dead == false:
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
		
		if on_ladder == true:
			# Salire e scendere scalette
			gravity = 0
			if velocity.y < 0:
				$AnimatedSprite.play("ladder")
			
			if Input.is_action_pressed("ui_up"):
				velocity.y = -speed
			elif Input.is_action_pressed("ui_down"):
				if on_ground == false:
					velocity.y = speed
			else:
				$AnimatedSprite.play("idle")
				velocity.y = 0
		else:
			gravity = 10
		
		if Input.is_action_just_pressed("ui_select") && is_attacking == false:
			if is_on_floor():
				velocity.x = 0
			is_attacking = true
			$AnimatedSprite.play("slash")
			var fireball = null
			if weapon_power == 1:
				fireball = FIREBALLWHITE.instance()
			elif weapon_power == 2:
				fireball = FIREBALLRED.instance()
			
			if sign($Position2D.position.x) == 1:
				fireball.set_fireball_direction(1)
			else:
				fireball.set_fireball_direction(-1)
			
			get_parent().add_child(fireball)
			fireball.position = $Position2D.global_position

		velocity.y += gravity
	
		if is_on_floor():
			if on_ground == false:
				is_attacking = false
			on_ground = true
		else:
			if is_attacking == false:
				on_ground = false
				if velocity.y < 0:
					if on_ladder == false:
						$AnimatedSprite.play("jump")
					elif on_ladder == true:
						$AnimatedSprite.play("ladder")
				else:
					if on_ladder == false:
						$AnimatedSprite.play("fall")
					elif on_ladder == true:
						$AnimatedSprite.play("ladder")
	
		velocity = move_and_slide(velocity, FLOOR)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if get_slide_collision(i).collider.is_in_group("Enemy"):
					dead()

func dead():
	is_dead = true
	velocity = Vector2.ZERO
	$AnimatedSprite.play("dead")
	$CollisionShape2D.set_deferred("disabled", true)
	$Timer.start()


func _on_AnimatedSprite_animation_finished():
	is_attacking = false


func set_weapon_power(power):
	weapon_power = power


func _on_Timer_timeout():
	# TODO: Menu o scena per decidere se riprovare o fermarsi
	if get_tree().change_scene("res://levels/LevelZero.tscn"):
		print("Error: Doesn't find scene res://levels/LevelZero.tscn" )

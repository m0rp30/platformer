extends Area2D


export var weapon_power = 2


func _on_Crown_body_entered(body):
	body.set_weapon_power(weapon_power)
	queue_free()

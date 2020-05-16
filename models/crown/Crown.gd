extends Area2D


func _on_Crown_body_entered(body):
	body.set_weapon_power(2)
	queue_free()

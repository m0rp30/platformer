extends Node


export var ladder_scale = 1
var leadder_heigth = 16

onready var ladder_body = $CollisionBody

func _ready():
	ladder_body.scale.y = ladder_scale
	ladder_body.position.y = -(leadder_heigth * ladder_scale) / 2


func _on_Ladder_collision_body_entered(body):
	if body.is_in_group("Player"):
		body.on_ladder = true


func _on_Ladder_collision_body_exited(body):
	if body.is_in_group("Player"):
		body.on_ladder = false


func _on_LadderTop_body_entered(body):
	if body.is_in_group("Player"):
		body.on_ladder = false

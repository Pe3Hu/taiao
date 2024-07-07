class_name Lair extends Node2D


@export var habitat: Habitat: set = set_habitat

@onready var poly = $Wall/Polygon2D

var index = null
var eggs = 1


func set_habitat(habitat_) -> void:
	habitat = habitat_
	poly.color = Color.from_hsv(habitat.hue, 0.8, 0.7, 1)
	
	%Spawn.collision_mask = pow(2, habitat.layer - 1)
	%Spawn.collision_layer = pow(2, habitat.layer - 1)
	habitat.add_blob()
	
func _on_spawn_body_exited(_body):
	if eggs > 0:
		habitat.add_blob()
	else:
		%Wall.collision_mask = pow(2, habitat.layer - 1)
		%Wall.collision_layer = pow(2, habitat.layer - 1)
	
func _on_spawn_body_entered(_body):
	pass # Replace with function body.

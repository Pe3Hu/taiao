class_name Lair extends Node2D


@export var habitat: Habitat:
	set(habitat_):
		habitat = habitat_
	get:
		return habitat

@onready var poly = $Wall/Polygon2D
@onready var wall = $Wall
@onready var spawn = %Spawn
@onready var womb = $Wall/Womb
@onready var navigation_agent = $NavigationAgent

var eggs = 1
var parking: Array[Blob]


func _on_spawn_body_exited(_body):
	if eggs > 0:
		if %Spawn.has_overlapping_bodies():
			wall.collision_mask = 0
			wall.collision_layer = 0
			navigation_agent.avoidance_layers = 0
			habitat.add_blob()
		else:
			pass
	else:
		wall.collision_mask = pow(2, habitat.layer - 1)
		wall.collision_layer = pow(2, habitat.layer - 1)
		navigation_agent.avoidance_layers = pow(2, habitat.layer - 1)
	
func _on_spawn_body_entered(_body):
	if true:
		return
	if _body.habitat == habitat:
		if _body.hsm.get_active_state().name == "comeback":
			parking.append(_body)
			_body.hsm.dispatch(&"drain_started")
	pass # Replace with function body.

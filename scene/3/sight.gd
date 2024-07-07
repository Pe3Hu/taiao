@tool
extends Node2D


@export var blob: Blob
@export var nourishment: NourishmentResource = NourishmentResource.new():
	set(nourishment_):
		nourishment = nourishment_
		update_masks()
	get:
		return nourishment 

@export_range(8, 160, 1) var side_glance: int:
	set(side_glance_):
		side_glance = side_glance_
		update_focuses(side_names)
	get:
		return side_glance

@export_range(8, 160, 1) var front_glance: int:
	set(front_glance_):
		front_glance = front_glance_
		update_focuses(front_names)
	get:
		return front_glance

@export_range(30, 60, 1) var view_angle: float:
	set(view_angle_):
		view_angle = view_angle_
		update_focuses(side_names)
	get:
		return view_angle

const side_names = ["left", "right"]
const front_names = ["center"]
const left_sign = -1
const center_sign = 0
const right_sign = 1
const left_glance = "side"
const center_glance = "front"
const right_glance = "side"

@onready var left = $Focuses/Left
@onready var center = $Focuses/Center
@onready var right = $Focuses/Right


func update_masks() -> void:
	var mask = nourishment.get_mask()
	
	for focus in %Focuses.get_children():
		focus.collision_mask += mask
	
	if blob != null:
		#blob.collision_layer += mask
		blob.collision_mask += mask
	
func update_focuses(names_: Array) -> void:
	for _name in names_:
		var focus = get(_name)
		
		if focus != null:
			focus.target_position = get_focus_postion(_name)
	
func get_focus_postion(name_: String) -> Vector2:
	var glance = get(get(name_ + "_glance")  + "_glance")
	var angle = view_angle / 360.0 * PI * 2 * get(name_ + "_sign")
	return Vector2.from_angle(angle) * glance
	
func get_colliders() -> Dictionary:
	var colliders = {}
	
	for focus in %Focuses.get_children():
		var collider = focus.get_collider()
		
		if collider != null:
			if !blob.targets.has(collider.get_parent()):
				colliders[collider] = nourishment.evaluate_collider(collider)
				
				if colliders[collider] == 0:
					colliders.erase(collider)
	
	return colliders

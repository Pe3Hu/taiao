class_name Habitat extends Node2D


@export var isle: Isle
@export var blobSize: float = 8.0
@export var hue: float = 0.0

@onready var boundary = $Boundary
@onready var poly = $Boundary/Polygon2D
@onready var lair = $Lair

var index = null
var layer = null


func _ready() -> void:
	index = int(Global.num.index.habitat)
	Global.num.index.habitat += 1
	layer = index + 5
	
	boundary.collision_layer = pow(2, layer - 1)
	
func init() -> void:
	lair.set_habitat(self)
	
func set_isle(isle_: Isle) ->Habitat:
	isle = isle_
	return self
	
func roll_color() -> Habitat:
	hue = isle.hues.pop_back()
	#hue = isle.hues.pick_random()
	#isle.hues.erase(hue)
	poly.color = Color.from_hsv(hue, 0.9, 0.9, 0.05)
	return self
	
func roll_position() -> Habitat:
	position = isle.spots.pop_back()
	position += Global.vec.size.border
	#Global.rng.randomize()
	#var angle = Global.rng.randf() * PI * 2
	#spot += Vector2.from_angle(angle) * Global.vec.size.habitat.x
	return self
	
func add_blob() -> void:
	lair.eggs -= 1
	var blob = Global.scene.blob.instantiate()
	%Blobs.add_child(blob)
	
	blob.position = get_spawn_position()
	blob.habitat = self
	
	var color = Color.from_hsv(hue, 0.9, 0.9)
	blob.regularPolygon.polygon_color_set(color)
	
	blob.collision_mask += pow(2, layer - 1)
	blob.collision_layer += pow(2, layer - 1)
	
func get_spawn_position() -> Vector2:
	if true:
		return Vector2.ZERO
	
	var vertexs = poly.get_polygon()
	var l = vertexs[0].length()
	
	for vertex in vertexs:
		if vertex.length() < l:
			l = vertex.length()
	
	l -= blobSize
	Global.rng.randomize()
	var angle = Global.rng.randf() * PI * 2
	return Vector2.from_angle(angle) * l
	
func expansion(blob_: Blob) -> void:
	if false:
		return
	
	var x = sign(blob_.position.x)
	var y = sign(blob_.position.y)
	var direction = Vector2i(x, y)
	
	var _index = Global.dict.direction.diagonal.find(direction)
	var axis = Global.arr.axis[_index]
	var vertexs = poly.get_polygon()
	var square = Global.gauss_square_formula(vertexs)
	var increment = blob_.exploration_power / square
	
	for _i in axis:
		var vertex = vertexs[_i]
		var length = vertex.length() * (1 + increment / 2)
		vertex = vertex.normalized() * length
		vertexs.set(_i, vertex)
	
	poly.set_polygon(vertexs)


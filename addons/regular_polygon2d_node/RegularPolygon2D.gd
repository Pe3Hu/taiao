@tool
extends Node2D

signal changed

@export var centered: bool: set = centered_set, get = centered_get
@export_range(3, 100, 1) var num_sides: int = 3: set = num_sides_set, get = num_sides_get
@export var size: float = 64: set = size_set, get = size_get
@export var polygon_color: Color = Color(36.0/256.0,138.0/256.0,199.0/256.0): set = polygon_color_set, get = polygon_color_get

@export var polygon_texture: Texture: set = polygon_texture_set, get = polygon_texture_get

@export var border_size: float = 4: set = border_size_set, get = border_size_get
@export var border_color: Color = Color(0,0,0): set = border_color_set, get = border_color_get
@export_range(-360, 360, 1) var polygon_rotation: float = 0: set = polygon_rotation_set, get = polygon_rotation_get

@export var collision_shape: CollisionPolygon2D: set = parent_collision_shape_set, get = parent_collision_shape_get


var DEBUG_NONE = -9999
var DEBUG_INFO = 0
var DEBUG_VERBOSE = 1

var LOG_LEVEL = DEBUG_NONE

func vlog(arg1, arg2 = "", arg3 = ""):
	if LOG_LEVEL >= DEBUG_VERBOSE:
		print(arg1,arg2,arg3)

func dlog(arg1, arg2 = "", arg3 = ""):
	if LOG_LEVEL >= DEBUG_INFO:
		print(arg1,arg2,arg3)

func poly_offset():
	if !centered:
		return Vector2(size/2 + border_size, size/2 + border_size)
	return Vector2(0,0)

func poly_pts(p_size):
	p_size /= 2
	var th = 2*PI/num_sides
	var pts = PackedVector2Array()
	var off = poly_offset()
	vlog("off: ", off)
	for i in range(num_sides):
		var angle = deg_to_rad(-90 + polygon_rotation) + i * th
		var v = Vector2(p_size, 0).rotated(angle)
		pts.append(off + v)
	return pts

func draw_poly(p_size, p_color, p_texture):
	var pts = poly_pts(p_size)

	var uvs = PackedVector2Array()
	if p_texture:
		var ts = polygon_texture.get_size()
		vlog(" ts: ", ts)
		for pt in pts:
			uvs.append((pt - poly_offset() + Vector2(p_size, p_size)) / ts)

	vlog("pts: ", pts)
	vlog("uvs: ", uvs)
	draw_colored_polygon(pts, p_color, uvs, polygon_texture)
	collision_shape.set_polygon(pts)
	
func _notification(what):
	if what == NOTIFICATION_DRAW:
		if border_size > 0:
			draw_poly(size + border_size, border_color, null)
		draw_poly(size, polygon_color, polygon_texture)
	if what == NOTIFICATION_READY:
		vlog("enter tree")
		if !collision_shape || Engine.is_editor_hint():
			vlog("editor mode: Not adding collision")
			return
			
		var p = get_parent();
		if p == null:
			vlog("no parent")
			return
		
		if p is CollisionObject2D:
			vlog("parent is CollisionObject2D")
			var shape = ConvexPolygonShape2D.new()
			shape.points = poly_pts(size + border_size)
			vlog("shape.points = ", shape.points)
			var col = CollisionShape2D.new()
			col.shape = shape
			p.call_deferred("add_child", col)


func parent_collision_shape_set(p_val):
	collision_shape = p_val

func parent_collision_shape_get():
	return collision_shape

func polygon_texture_set(texture):
	polygon_texture = texture
	queue_redraw()

func polygon_texture_get():
	return polygon_texture

func centered_set(val):
	centered = val
	queue_redraw()

func centered_get():
	return centered

func border_color_set(color):
	border_color = color
	queue_redraw()

func border_color_get():
	return border_color

func polygon_color_set(color):
	polygon_color = color
	queue_redraw()

func polygon_color_get():
	return polygon_color

func polygon_rotation_set(rot):
	polygon_rotation = rot
	queue_redraw()

func polygon_rotation_get():
	return polygon_rotation

func border_size_set(size):
	border_size = size
	queue_redraw()

func border_size_get():
	return border_size

func num_sides_set(sides):
	num_sides = sides
	queue_redraw()

func num_sides_get():
	return num_sides

func size_set(s):
	size = s
	queue_redraw()

func size_get():
	return size

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

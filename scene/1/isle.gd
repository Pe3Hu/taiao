class_name Isle extends Node2D


@onready var edge = $Edge
@onready var illuminance = $Illuminance

var spots = []
var hues = []

func _ready() -> void:
	init_spawn_spots()
	init_hues()
	init_habitats()
	
func init_spawn_spots() -> void:
	var x = (Global.vec.size.spawnArea.x - Global.vec.size.habitat.x * 0) / (Global.num.isle.col + 1)
	var y = (Global.vec.size.spawnArea.y - Global.vec.size.habitat.y * 0) / (Global.num.isle.row + 1)
	var gap = Vector2(x, y)
	
	for _i in Global.num.isle.row:
		for _j in Global.num.isle.col:
			var spot = Vector2(_j + 1, _i + 1) * gap
			spots.append(spot)
	
	spots.shuffle()
	
func init_hues() -> void:
	var step = 1.0 / Global.num.isle.n
	
	for _i in Global.num.isle.n:
		var hue = _i * step
		hues.append(hue)
	
	hues.shuffle()
	
func init_habitats() -> void:
	for _i in Global.num.habitat.n:
		add_habitat()
	
func add_habitat() -> void:
	var habitat = Global.scene.habitat.instantiate()
	%Habitats.add_child(habitat)
	habitat.set_isle(self).roll_position().roll_color().init()
	
func _on_start_timeout():
	init_domains()
	
func init_domains() -> void:
	for domain in %Domains.get_children():
		domain.awakening()

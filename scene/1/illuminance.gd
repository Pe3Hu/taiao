extends TileMap


@export var isle: Isle: 
	set(isle_):
		isle = isle_
	get:
		return isle

var layer = 0
var source_id = 0

var lights = {}
#var shadows = {}

func _ready():
	init_cells()
	pass # Replace with function body.
	
func init_cells() -> void:
	var x = Global.vec.size.spawnArea.x / Global.vec.size.illuminance.x 
	var y = Global.vec.size.spawnArea.y / Global.vec.size.illuminance.y 
	#var a = Global.vec.size.spawnArea
	var atlas_coord = Vector2(0, 0)
	
	for _i in y:
		for _j in x:
			var coord = Vector2i(_j, _i) + Vector2i.ONE
			set_cell(layer, coord, source_id, atlas_coord)
			lights[coord] = 1.0
	
func pull_light_coord() -> Vector2i:
	var coord = Global.get_random_key(lights)
	#lights.erase(coord)
	#shadows[coord] = 1
	update_cells(coord, -1)
	return coord
	
func update_cells(coord_: Vector2i, fluctuation_: int) -> void:
	lights[coord_] += Global.num.shadow.primary * fluctuation_
	#var a = lights[coord_]
	var atlas_coord = get_cell_atlas_coords(layer, coord_)
	atlas_coord.x -= fluctuation_
	
	for direction in Global.dict.direction.linear2:
		var coord = coord_ + direction
		
		if lights.has(coord):
			if lights[coord] > 0:
				lights[coord] += Global.num.shadow.secondary * fluctuation_
				set_cell(layer, coord, source_id, atlas_coord)
	
	atlas_coord = Vector2(4, 0)
	set_cell(layer, coord_, source_id, atlas_coord)


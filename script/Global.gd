extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.axis = [[0, 1], [1, 2], [2, 3], [3, 0]]
	arr.food = ["plant", "meat", "carrion"]


func init_num() -> void:
	num.index = {}
	num.index.habitat = 0
	
	num.isle = {}
	num.isle.col = 6
	num.isle.row = 4
	num.isle.n = num.isle.col * num.isle.row
	
	num.shadow = {}
	num.shadow.primary = 1.0
	num.shadow.secondary = num.shadow.primary / 4
	
	num.domain = {}
	num.domain.count = 2000
	num.domain.n = 4224
	num.domain.growth = 1
	
	num.plant = {}
	num.plant.start = 100
	
	num.habitat = {}
	num.habitat.n = 1#num.isle.n
	
	num.acceleration = {}
	num.habitat.multiplier = -0.25


func init_dict() -> void:
	init_direction()


func init_direction() -> void:
	dict.direction = {}
	dict.direction.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.direction.linear2 = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.direction.diagonal = [
		Vector2i( 1,-1),
		Vector2i( 1, 1),
		Vector2i(-1, 1),
		Vector2i(-1,-1)
	]
	dict.direction.zero = [
		Vector2i( 0, 0),
		Vector2i( 1, 0),
		Vector2i( 1, 1),
		Vector2i( 0, 1)
	]
	dict.direction.hex = [
		[
			Vector2i( 1,-1), 
			Vector2i( 1, 0), 
			Vector2i( 0, 1), 
			Vector2i(-1, 0), 
			Vector2i(-1,-1),
			Vector2i( 0,-1)
		],
		[
			Vector2i( 1, 0),
			Vector2i( 1, 1),
			Vector2i( 0, 1),
			Vector2i(-1, 1),
			Vector2i(-1, 0),
			Vector2i( 0,-1)
		]
	]


func init_blank() -> void:
	dict.blank = {}
	dict.blank.rank = {}
	var exceptions = ["rank"]
	
	var path = "res://asset/json/maoiri_blank.json"
	var array = load_data(path)
	
	for blank in array:
		blank.rank = int(blank.rank)
		var data = {}
		
		for key in blank:
			if !exceptions.has(key):
				data[key] = blank[key]
			
		if !dict.blank.rank.has(blank.rank):
			dict.blank.rank[blank.rank] = []
	
		dict.blank.rank[blank.rank].append(data)


func init_node() -> void:
	pass
	#node.world = get_node("/root/World")


func init_scene() -> void:
	scene.habitat = load("res://scene/2/habitat.tscn")
	scene.blob = load("res://scene/3/blob.tscn")
	
	


func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	vec.size.tile = Vector2(16, 16)
	vec.size.illuminance = Vector2(16, 16)
	
	init_window_size()
	
	vec.size.border = Vector2(16, 16)
	vec.size.spawnArea = vec.size.window - vec.size.border * 2
	vec.size.habitat = vec.size.tile * 2


func init_window_size():
	var width = ProjectSettings.get_setting("display/window/size/viewport_width")
	var height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window = Vector2(width, height)


func init_color():
	var h = 360.0
	
	color.defender = {}
	color.defender.active = Color.from_hsv(120 / h, 0.6, 0.7)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null


func gauss_square_formula(vertexs_: Array) -> float:
	var n = vertexs_.size() - 1
	var squares = {}
	squares.x = vertexs_[n].x * vertexs_[0].y
	squares.y = -vertexs_[n].y * vertexs_[0].x
	
	for _i in n:
		squares.x += vertexs_[_i].x * vertexs_[_i + 1].y
		squares.y -= vertexs_[_i].y * vertexs_[_i + 1].x
		
	return abs(squares.x + squares.y) / 2

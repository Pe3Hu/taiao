class_name ItemResource extends Resource


@export_enum("plant", "meat", "carrion") var type: String = "plant": 
	set(type_):
		type = type_
	get:
		return type

@export var texture: Texture2D
@export var textureSize: Vector2 = Vector2(64, 64)
@export var smell: float

var mask = null


func get_mask() -> float:
	if mask == null:
		var layer = Global.arr.food.find(type) + 2
		mask = pow(2, layer - 1)
		
	return mask

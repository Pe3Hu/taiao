class_name Domain extends Node2D


@export var isle: Isle

@export_enum("plant", "meat", "carrion") var type: String = "plant":
	set(type_):
		type = type_
		itemScene = load("res://scene/4/" + type + "Item.tscn")
		itemResource = load("res://resource/item/" + type + "Item.tres")
	get:
		return type

@onready var items = $Items

var itemScene
var itemResource
var pool: Array[Item]


func _ready():
	refill_pool()
	
func refill_pool() -> void:
	type = type
	
	for _i in Global.num.domain.count:
		var instance = itemScene.instantiate()
		pool.append(instance)
		instance.domain = self
	
func awakening() -> void:
	match type:
		"plant":
			for _i in Global.num.plant.start:
				growth()
			
			%Timer.start()
	
func growth() -> void:
	var instance = pool.pop_back()
	items.add_child(instance)
	instance.itemSource = ItemSource.from_sun(self)
	instance.itemResource = itemResource
	#var a = instance.get_node("BiteArea")
	
	if pool.is_empty():
		refill_pool()
	
func _on_timer_timeout():
	match type:
		"plant":
			for _i in Global.num.domain.growth:
				growth()

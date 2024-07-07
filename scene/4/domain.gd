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


func _ready() -> void:
	refill_pool()
	
func refill_pool() -> void:
	for _i in Global.num.domain.count:
		var instance = itemScene.instantiate()
		pool.append(instance)
		instance.domain = self
	
func awakening() -> void:
	pass

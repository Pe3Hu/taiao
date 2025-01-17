class_name ItemSource extends Node


@export var item: Item

var weight: float
var position: Vector2
var life_time: float 

@export_range(0, 100, 0.01) var integrity: float = 100


static func from_sun(domain_: Domain) -> ItemSource:
	var itemSource = ItemSource.new()
	itemSource.weight = 16
	itemSource.life_time = 999
	var coord = domain_.isle.illuminance.pull_light_coord()#Global.node.world.isle.illuminance.pull_light_coord()
	itemSource.position = (Vector2(coord) + Vector2.ONE / 2) * Global.vec.size.illuminance
	#position += 
	return itemSource


func get_bite(blob_: Blob) -> void:
	var stockpile = weight * integrity / 100
	var loss = min(stockpile, blob_.organism.jaw.limit)
	blob_.organism.jaw.content += loss
	integrity -= loss / weight * 100
	#print(integrity)
	
	if integrity == 0:
		item.destroy()

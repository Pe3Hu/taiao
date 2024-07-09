class_name NourishmentResource extends Resource


@export_enum("herbivore", "predator", "scavenger", "omnivore", "vermin") var nourishment: String

@export_group("Valuation", "valuation")
@export_range(0, 3, 0.1) var valuation_plant: float = 0
@export_range(0, 3, 0.1) var valuation_meat: float = 0
@export_range(0, 3, 0.1) var valuation_carrion: float = 0

var mask = null


func get_mask() -> float:
	if mask == null:
		mask = 0
		
		for food in Global.arr.food:
			var valuation = get("valuation_" + food)
			
			if valuation > 0:
				var layer = Global.arr.food.find(food) + 2
				mask += pow(2, layer - 1)
	
	return mask
	
func evaluate_collider(collider_) -> float:
	var resource = collider_.get_parent().itemSource
	return resource.weight * resource.life_time

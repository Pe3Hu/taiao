extends Domain


func awakening() -> void:
	super.awakening()
	
	for _i in Global.num.plant.start:
		growth()
		
	%GrowthTimer.start()
	
func growth() -> void:
	var instance = pool.pop_back()
	items.add_child(instance)
	instance.itemSource = ItemSource.from_sun(self)
	instance.itemResource = itemResource
	#var a = instance.get_node("BiteArea")
	
	if pool.is_empty():
		refill_pool()
	
func _on_growth_timer_timeout():
	for _i in Global.num.domain.growth:
		growth()

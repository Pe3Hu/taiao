class_name Item extends Node2D


@export var domain: Domain

@export var itemResource: ItemResource: 
	set(itemResource_):
		itemResource = itemResource_
		
		if itemResource.texture != null:
			%Sprite2D.texture = itemResource.texture
			%BiteArea.collision_layer = itemResource.get_mask()
			#%BiteArea.collision_mask += itemResource.get_mask()
			#itemResource.item = self
	get:
		return itemResource

@export var itemSource: ItemSource: 
	set(itemSource_):
		itemSource = itemSource_
		position = itemSource.position
		itemSource.item = self
	get:
		return itemSource

@export var blobs: Array[Blob]


func prepare() -> void:
	pass
	
func _on_odor_timer_timeout():
	pass # Replace with function body.
	
func destroy() -> void:
	for blob in blobs:
		blob.targets.erase(self)
		
		if blob.target == self:
			blob.target = null
	
	domain.items.remove_child(self)
	domain.pool.append(self)


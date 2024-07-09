@tool
class_name Organism extends Control


@export var blob: Blob
@export var bite: int = 4

@onready var jaw = $Cavities/Jaw
@onready var stomach = $Cavities/Stomach


func update_cavity_content(cavity_: Cavity) -> void:
	match cavity_.type:
		"jaw":
			if jaw.tempo == "drain":
				jaw.tempo = "standard"
			elif jaw.content > 0:
				var _bite = min(min(jaw.content, bite), stomach.limit - stomach.content)
				jaw.content -= _bite
				stomach.content += _bite
		"stomach":
			if stomach.tempo == "drain":
				stomach.tempo = "standard"
				blob.hsm.dispatch(&"exploration_started")
			elif stomach.content >= stomach.limit:
					if blob.target != null and blob.target != blob.habitat.lair:
						blob.targets.append(blob.target)
					
					blob.target = null
					blob.hsm.dispatch(&"comeback_started")
					blob.target = blob.habitat.lair
					blob.navigation_agent.target_position = blob.habitat.lair.global_position

func drain() -> void:
	var content = stomach.content + jaw.content
	
	for cavity in %Cavities.get_children():
		cavity.tempo = "drain"
	
	blob.habitat.lair.womb.jaw.content += content
	stomach.content = 0
	jaw.content = 0

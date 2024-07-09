@tool
class_name Womb extends Control


@export var lair: Lair
@export var laying: int = 32

@onready var jaw = $Cavities/Jaw
@onready var stomach = $Cavities/Stomach


func update_cavity_content(cavity_: Cavity) -> void:
	match cavity_.type:
		"stomach":
			if stomach.content > laying:
				stomach.content -= laying
				lair.eggs += 1

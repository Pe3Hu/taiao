@tool
class_name Cavity extends NinePatchRect


@export_enum("stomach", "jaw") var type: String = "stomach"

@export_enum("standard", "drain") var tempo: String = "standard"

@export var proprietor: Control

@export var texture_size: Vector2 = Vector2(16, 16):
	set(texture_size_):
		texture_size = texture_size_
	get:
		return texture_size

@export var color_under: Color = Color.WHITE:
	set(color_under_):
		color_under = color_under_
		%Fullness.tint_under = color_under
	get:
		return color_under

@export var color_progress: Color = Color.WHITE:
	set(color_progress_):
		color_progress = color_progress_
		%Fullness.tint_progress = color_progress
	get:
		return color_progress

@export var treatment_time: float = 0.5

@export var limit: int = 16:
	set(limit_):
		limit = limit_
		%Fullness.max_value = limit
		%Label.text = str(round(limit))
	get:
		return limit

@export var content: float = 0.0:
	set(content_):
		content = clamp(content_, 0, limit)
		
		var tween = create_tween().set_parallel(true)
		var modifier = get(tempo+"_modifier")
		var time = treatment_time * modifier
		
		tween.tween_property(%Fullness, "value", content, treatment_time)
		tween.connect("finished", on_tween_finished)
	get:
		return content

@export var standard_modifier: float = 1.0

@export var drain_modifier: float = 6.0


func on_tween_finished() -> void:
	proprietor.update_cavity_content(self)

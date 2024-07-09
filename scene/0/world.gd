extends Node


@onready var isle = %Isle

func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	#Global.rng.randomize()
	#var random = Global.rng.randi_range(0, 1)
	pass
	
	#var idle_state = LimboState.new().named("idle").call_on_enter(idle_ready).call_on_update(idle_physics_process)
	#hsm.add_child(idle_state)
	#hsm.add_transition(_state, idle_state, &"idle_started")
	#hsm.add_transition(idle_state, _state, &"idle_ended")
	
func idle_ready() -> void:
	pass
	
func idle_physics_process(delta_) -> void:
	pass

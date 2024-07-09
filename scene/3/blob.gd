class_name Blob extends CharacterBody2D


@export var habitat: Habitat
@export var speed: float = 60.0
@export var exploration_power: float = 30000.0
@export_range(-0.5, -0.1, 0.1) var acceleration_multiplier: float = -0.25
@export_range(0, 16, 0.1) var stomach: float = 0

@onready var regular_polygon = $RegularPolygon2D
@onready var hsm = $LimboHSM
@onready var organism = $Organism
@onready var navigation_agent = $NavigationAgent

var targets = []
var target = null


func _ready() -> void:
	init_state_machine()
	
	var nourishment = load("res://resource/nourishment/herbivoreNourishment.tres")
	%Sight.nourishment = nourishment
	
func init_state_machine() -> void:
	var idle_state = LimboState.new().named("idle").call_on_enter(idle_ready).call_on_update(idle_physics_process)
	var exploration_state = LimboState.new().named("exploration").call_on_enter(exploration_ready).call_on_update(exploration_physics_process)
	var hunt_state = LimboState.new().named("hunt").call_on_enter(hunt_ready).call_on_update(hunt_physics_process)
	var acceleration_state = LimboState.new().named("acceleration").call_on_enter(acceleration_ready).call_on_update(acceleration_physics_process)
	var comeback_state = LimboState.new().named("comeback").call_on_enter(comeback_ready).call_on_update(comeback_physics_process)
	var drain_state = LimboState.new().named("drain").call_on_enter(drain_ready).call_on_update(drain_physics_process)
	
	hsm.add_child(idle_state)
	hsm.add_child(exploration_state)
	hsm.add_child(hunt_state)
	hsm.add_child(acceleration_state)
	hsm.add_child(comeback_state)
	hsm.add_child(drain_state)
	
	hsm.add_transition(hsm.ANYSTATE, exploration_state, &"exploration_started")
	hsm.add_transition(exploration_state, idle_state, &"exploration_ended")
	hsm.add_transition(exploration_state, hunt_state, &"hunt_started")
	hsm.add_transition(hunt_state, exploration_state, &"hunt_ended")
	hsm.add_transition(hunt_state, acceleration_state, &"acceleration_started")
	hsm.add_transition(acceleration_state, hunt_state, &"acceleration_ended")
	hsm.add_transition(hsm.ANYSTATE, comeback_state, &"comeback_started")
	hsm.add_transition(comeback_state, drain_state, &"comeback_ended")
	hsm.add_transition(hsm.ANYSTATE, drain_state, &"drain_started")
	hsm.add_transition(drain_state, idle_state, &"drain_ended")
	
	hsm.add_transition(hsm.ANYSTATE, idle_state, &"state_ended")
	
	hsm.initial_state = idle_state
	hsm.initialize(self)
	hsm.set_active(true)
	
func handle_collision(collision_: KinematicCollision2D) -> void:
	if collision_:
		var collider = collision_.get_collider()
		
		if hsm.get_active_state().name == "hunt":
			if collider == habitat.boundary:
				velocity *= acceleration_multiplier
				hsm.dispatch(&"acceleration_started")
				%AccelerationTimer.start()
			
			if collider.get_parent() == target:
				velocity *= acceleration_multiplier
				hsm.dispatch(&"acceleration_started")
				%AccelerationTimer.start()
				target.itemSource.get_bite(self)
		elif hsm.get_active_state().name == "comeback":
			if collider.get_parent() == target:
				hsm.dispatch(&"drain_started")
				organism.drain()
		else:
			velocity = velocity.bounce(collision_.get_normal())
			update_eye()
		
		if collider.get_parent() == habitat:
			if collider == habitat.boundary:
				habitat.expansion(self)
	
	var colliders = %Sight.get_colliders()
	
	if colliders.keys().is_empty():
		return
	else:
		while !colliders.keys().is_empty():
			var _target = Global.get_random_key(colliders).get_parent()
			
			if !targets.has(_target):
				targets.append(_target)
				_target.blobs.append(self)
				colliders.erase(_target.get_node("%BiteArea"))
	
func update_eye() -> void:
	%Sight.rotation = velocity.angle()# + PI / 2
	var angle = velocity.angle() * 360 / PI / 2 + 90
	regular_polygon.polygon_rotation_set(angle)
	
func idle_ready() -> void:
	var angle = Global.rng.randf() * 360
	angle = angle / 360 * PI * 2
	velocity = Vector2.from_angle(angle).normalized() * speed
	update_eye()
	
func idle_physics_process(delta_) -> void:
	if velocity != Vector2.ZERO:
		hsm.dispatch(&"exploration_started")
		return
	
func exploration_ready() -> void:
	pass
	
func exploration_physics_process(delta_) -> void:
	if velocity == Vector2.ZERO:
		hsm.dispatch(&"exploration_ended")
		return
	
	var collision = move_and_collide(velocity * delta_)
	handle_collision(collision)
	
	if !targets.is_empty():
		hsm.dispatch(&"hunt_started")
	
func hunt_ready() -> void:
	pass
	
func hunt_physics_process(delta_) -> void:
	if target:
		navigation_agent.target_position = target.global_position
		
		if navigation_agent.is_navigation_finished():
			return
	else:
		find_nearest_target()
	
	var current_agent_position = global_position
	var next_path_position = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * speed
	update_eye()
	
	var collision = move_and_collide(velocity * delta_)
	handle_collision(collision)
	
	if targets.is_empty() and target == null:
		hsm.dispatch(&"hunt_started")
	
func acceleration_ready() -> void:
	pass
	
func acceleration_physics_process(delta_) -> void:
	if velocity == Vector2.ZERO:
		pass
	
	var collision = move_and_collide(velocity * delta_)
	handle_collision(collision)
	
func comeback_ready() -> void:
	pass
	
func comeback_physics_process(delta_) -> void:
	if navigation_agent.is_navigation_finished():
		return
	
	navigation_agent.target_position = target.global_position
	var current_agent_position = global_position
	var next_path_position = navigation_agent.get_next_path_position()
	velocity = current_agent_position.direction_to(next_path_position) * speed
	update_eye()
	
	var collision = move_and_collide(velocity * delta_)
	handle_collision(collision)
	
func drain_ready() -> void:
	pass
	
func drain_physics_process(delta_) -> void:
	if organism.jaw.content > 0 or organism.stomach.content > 0:
		return
	
	target = null
	hsm.dispatch(&"exploration_started")
	
func _on_hsm_active_state_changed(current, previous):
	if false:
		return
	if previous == null:
		print(current.name)
	else:
		print(previous.name, " > ", current.name)
	pass # Replace with function body.
	
func _on_acceleration_timer_timeout():
	hsm.dispatch(&"acceleration_ended")
	velocity /= acceleration_multiplier
	
func find_nearest_target() -> void:
	if !is_instance_valid(target):
		if targets.is_empty():
			idle_ready()
			hsm.dispatch(&"exploration_started")
		else:
			targets.sort_custom(sort_by_distance)
			target = targets.pop_back()
			navigation_agent.target_position = target.global_position
	
func sort_by_distance(a_, b_) -> bool:
	return a_.get_global_position().distance_to(get_global_position()) > b_.get_global_position().distance_to(get_global_position())
	
func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	pass # Replace with function body.


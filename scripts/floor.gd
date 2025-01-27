extends AnimatableBody2D
@onready var fall_timer: Timer = $FallTimer
var initial_position : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initial_position = global_position 
	fall_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_fall_timer_timeout() -> void:
	global_position.y += 10
	fall_timer.start()

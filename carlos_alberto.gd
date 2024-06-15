extends CharacterBody2D
@onready var area_2d = $Area2D
@onready var timer_despawn = $TimerDespawn



func _ready():
	pass



func _process(delta):
	move_and_slide()
	if velocity != Vector2.ZERO:
		rotation = velocity.angle()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		velocity = Vector2.ZERO
		if timer_despawn.is_stopped():
			timer_despawn.start()

		


func _on_area_2d_area_entered(area)	 :# Replace with function body.
	var objetosAtacados = area_2d.get_overlapping_bodies()
	for objeto in objetosAtacados:
		if objeto != self:
			if objeto is Inimigo:
				objeto.levar_dano(1)
				queue_free()
				


func _on_timer_despawn_timeout():
	queue_free()

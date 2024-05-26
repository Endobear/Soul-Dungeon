extends CharacterBody2D
@onready var area_2d = $Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide()


func _on_area_2d_area_entered(area)	 :# Replace with function body.
	var objetosAtacados = area_2d.get_overlapping_bodies()
	for objeto in objetosAtacados:
		if objeto != self:
			if objeto is Inimigo:
				objeto.levar_dano(1)
				queue_free()

extends Node2D
@export var dungeon = true
@onready var animation_player = load("res://Cenas/anim_nivel.tscn")


var listaInimigo = []
@export var ProximoNivel: String

func _ready():
	animation_player = animation_player.instantiate()
	add_child(animation_player)
	animation_player = animation_player.find_child("AnimationPlayer")
	animation_player.play("fade out")
	for enemy in get_children():
		if enemy is Inimigo:
			listaInimigo.append(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if dungeon:
		for enemy in listaInimigo:
			if !enemy:
				listaInimigo.erase(enemy)
		if listaInimigo.size() == 0:
			animation_player.play("fade in")
		
		

func mudar_nivel():
	get_tree().change_scene_to_file(ProximoNivel)
	

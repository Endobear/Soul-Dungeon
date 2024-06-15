extends Control

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_player.play("new_animation")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	get_tree().change_scene_to_file("res://OOGABOOGA.tscn")


func _on_button_2_button_down():
	get_tree().change_scene_to_file("res://Cenas/Settings.tscn")


func _on_button_3_button_down():
	get_tree().quit()

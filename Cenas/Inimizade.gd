class_name Inimigo 
extends CharacterBody2D
@export var infoInimigo : informacoesInimigo
var vida:= 5
var vidaMax:= 10
var velocidade := 170
var dano := 1
var animacoes : SpriteFrames
var player  : Player  = null

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var knockout = $Knockout




# Called when the node enters the scene tree for the first time.
func _ready():
	vida = infoInimigo.vida
	vidaMax = infoInimigo.vidaMax
	velocidade = infoInimigo.velocidade
	dano = infoInimigo.dano
	animacoes = infoInimigo.animacoes 
	animated_sprite_2d.sprite_frames = animacoes
	pass # Replace with function body.

 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	animated_sprite_2d.play()
	var distance_from_player
	var direction
	print(knockout.time_left)
	if vida <= 0:
		
		queue_free()
		
	
		

	if player:
		distance_from_player = Vector2(player.transform.get_origin().x - transform.get_origin().x, player.transform.get_origin().y - transform.get_origin().y)
		direction = Vector2(clamp(distance_from_player.x, - 1, 1), clamp(distance_from_player.y, - 1, 1)).normalized()
	
		if knockout.time_left == 0:
			velocity.x = direction.x * velocidade
			velocity.y = direction.y * velocidade
		
	else:
		velocity.x = 0; velocity.y = 0
		
		
	if knockout.time_left > 0:
		velocity = -direction * 120
	move_and_slide()
	

func levar_dano(dano):
	vida -= dano
	knockout.start()








func _on_hunt_area_area_entered(area):
	
	if area.owner.name == "jogador":
		player = area.owner
	
	pass # Replace with function body.


func _on_hunt_area_area_exited(area):
	if area.owner.name == "jogador":
		player = null
	pass # Replace with function body.


func _on_knockout_timeout():
	pass # Replace with function body.

class_name Inimigo 
extends CharacterBody2D
@export var infoInimigo : informacoesInimigo
var vida:= 5
var vidaMax:= 10
var velocidade := 55
var dano := 1
var animacoes : SpriteFrames
var player  : Player  = null
var estado  = "parado"
var direcao = "baixo"

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var knockout = $Knockout




# Called when the node enters the scene tree for the first time.
func _ready():
	vidaMax = infoInimigo.vidaMax
	velocidade = infoInimigo.velocidade
	dano = infoInimigo.dano
	animacoes = infoInimigo.animacoes 
	animated_sprite_2d.sprite_frames = animacoes
	pass # Replace with function body.

 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var distance_from_player
	var direction
	if vida <=0:
		queue_free()
	
	
	if player:
		distance_from_player = Vector2(player.transform.get_origin().x - transform.get_origin().x, player.transform.get_origin().y - transform.get_origin().y)
		
		direction = Vector2(clamp(distance_from_player.x, - 1, 1), clamp(distance_from_player.y, - 1, 1)).normalized()
		
		print(int(direction.angle()))
		match int(direction.angle()):
			1:
				direcao = "baixo"
			-1:
				direcao = "cima"
			0:
				direcao = "direita"
			-3:
				direcao = "esquerda"
		if knockout.time_left == 0:
			velocity.x =move_toward(velocity.x, direction.x * velocidade,velocidade/2)
			velocity.y =move_toward(velocity.y, direction.y * velocidade,velocidade/2)
			animated_sprite_2d.play("andando " + direcao)
	else:
		velocity.x = 0; velocity.y = 0
		animated_sprite_2d.play("parado " + direcao)
		

	if knockout.time_left > 0:
		if player:
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

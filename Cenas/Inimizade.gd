class_name Inimigo 
extends CharacterBody2D
@export var infoInimigo : informacoesInimigo
var vida:= 5
var vidaMax:= 10
var velocidade := 170
var dano := 1
var animacoes : SpriteFrames


@onready var animated_sprite_2d = $AnimatedSprite2D


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
	if vida <= 0:
		
		queue_free()
		

class_name Player
extends CharacterBody2D

@onready var text_morte = $Camera2D/Control/Text_Morte
var vida = 15
var vidaMax = 15

var speed = 125
var speedz = speed * 1.5
var speedx = speed
var can_dash = true
@onready var texture_progress_bar = $Camera2D/CanvasLayer/TextureRect/TextureProgressBar
var is_dashing = false
var dash_dir =  Vector2.DOWN
@onready var cooldown_dash = $dashicoldaun
# speedx é o stopping speed
# speedz é o sprint
@onready var sprite_2d = $Sprite2D
@onready var estado = "idle"
@onready var direcao = "baixo"
@onready var hurtbox = $hurtbox
@onready var hitbox = $hitbox
@onready var iframes = $Iframes
var velocidadeKnock = 500
var velocidade_dash = 350

var emKnock = false
var KnockDirec = Vector2.ZERO
@onready var knock = $Knock
@onready var cooldown_atk = $CooldownATK
var atacou = false
@onready var animation_player = $Camera2D/AnimationPlayer
@onready var cooldown_atk_2 = $CooldownATK2
@onready var faca = load("res://carlos_alberto.tscn")









# Called when the node enters the scene tree for the first time.
func _ready():
	sprite_2d.play("default")







# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	texture_progress_bar.max_value = vidaMax
	texture_progress_bar.value = vida
	
	var current_speed = speed
	if Input.is_key_pressed(KEY_SHIFT):
		current_speed = speedz
		if estado == "andar":
			sprite_2d.speed_scale = 1.5
			velocidade_dash = 250
	
	else:
		sprite_2d.speed_scale = 1
		velocidade_dash = 250
	
	if iframes.time_left > 0:
		current_speed = speed / 2
	
	var movimento_horizontal = Input.get_axis("mover_esq","mover_dire")
	var movimento_vertical = Input.get_axis("mover_cima","mover_baixo")
	
	var direction = Vector2(movimento_horizontal,movimento_vertical)
	
	if emKnock:
		
		direction = false
		can_dash = false
		if knock.time_left > 0:
			velocity.x = move_toward(velocity.x,0,10)
			velocity.y = move_toward(velocity.y,0, 10)
		else:
			emKnock = false
			can_dash = true
	
	if vida <= 0:
		estado = "died"
		direction = false
		can_dash = false
		
	
	
	
	
	
	
	
	
	
	
	if direction and (not is_dashing) and ((estado != "ataquePesado" and estado != "ataqueleve") ):
		estado = "andar"
	
		if(movimento_vertical == 1):
			direcao = "baixo"
			hurtbox.rotation_degrees = 0.0
		elif(movimento_vertical == -1):
			direcao = "cima"
			hurtbox.rotation_degrees = 180.0
		if(movimento_horizontal == 1):
			direcao = "direita"
			hurtbox.rotation_degrees = -90.0
		elif(movimento_horizontal == -1):
			direcao = "esquerda"
			hurtbox.rotation_degrees = 90.0
			
		dash_dir = direction.normalized()
		
		
		velocity = direction.normalized() * current_speed
	elif estado == "died":
		velocity = Vector2.ZERO
	elif not is_dashing and not emKnock and  (estado != "ataquePesado" and estado != "ataqueleve") :
		velocity.x = move_toward(velocity.x,0,speedx)
		velocity.y = move_toward(velocity.y,0,speedx)
		estado = "idle"
	
	
	
	
	
	
	
	if Input.is_action_just_pressed("ui_accept") and can_dash:
			
				can_dash = false
				is_dashing = true
				
			
				
				$duracaodouglas.start()
				$dashicoldaun.start()
	
	
	
	
	
	
	
	if Input.is_action_just_pressed("ataque_pesado") and ((estado != "ataquePesado" and estado != "ataqueleve") and estado != "died")  and !emKnock:
		velocity = Vector2.ZERO
		cooldown_atk.start()
		estado = "ataquePesado"
		
		
		
		
		
		
	if Input.is_action_just_pressed("atack_on_levi") and (estado != "ataqueleve" and estado != "died")  and !emKnock:
		velocity = Vector2.ZERO
		cooldown_atk_2.start()
		estado = "ataqueleve"
		var nova_faca = faca.instantiate()
		nova_faca.position = position
		nova_faca.velocity = dash_dir * 500
		nova_faca.rotation = nova_faca.velocity.angle()
		owner.add_child(nova_faca)
		
	elif iframes.time_left > 0.0:
		estado = "stunado"
		
	elif is_dashing:
		velocity = dash_dir * velocidade_dash
		 
		
		
		
		
		
	if cooldown_atk.time_left > 0:
		velocity = dash_dir * 60
		if atacou == false:
			ataque()
			atacou = true







					
	var hits = hitbox.get_overlapping_areas() 
	
	if hits and iframes.time_left == 0 and is_dashing == false:
		LevarDano(hits[0])
		
	
	
	TrocarAnim()
	move_and_slide()
	

func LevarDano(area: Area2D):
	
		
		if vida <= 0:
			estado = "died"
			can_dash = false
		elif !is_dashing:
			vida -= (area.owner.dano)
			estado = "stunado"
			emKnock = true 
			iframes.start()
			knock.start()
			KnockDirec = area.owner.position.direction_to(position)
			velocity = velocidadeKnock * KnockDirec 
	

func _on_timer_timeout():
	is_dashing = false


func _on_dashicoldaun_timeout():
	pass # Replace with function body.
	can_dash = true

func TrocarAnim():
	if sprite_2d.animation != "died":
		if estado == "died":
			sprite_2d.play("died") 
			match RandomNumberGenerator.new().randi_range(1,5):
				1:
					text_morte.text = "kakakakaka lixo"
				2:
					text_morte.text = "novo atacante do vasco contratado!"
				3:
					text_morte.text = "OMG EU MORRI JOGO RUIM!!1!!1111"
				4:
					text_morte.text = "Você faleceu????????"
				5:
					text_morte.text = "ai, ki dor"
			animation_player.play("animMorte")
		elif is_dashing:
			sprite_2d.play("dash" + direcao) 
		else:
			sprite_2d.play(estado + direcao)




func _on_hitbox_area_entered(area):
	if iframes.time_left == 0:
		LevarDano(area)


func _on_iframes_timeout():
	pass # Replace with function body.



func ataque():
	var objetosAtacados = hurtbox.get_overlapping_bodies()
	for objeto in objetosAtacados:
		if objeto != self:
			if objeto is Inimigo:
				objeto.levar_dano(2)


func _on_cooldown_atk_timeout():
	atacou = false
	estado = "idle"


func _on_button_button_down():
	get_tree().reload_current_scene()


func _on_button_2_button_down():
	get_tree().change_scene_to_file("res://Cenas/menuinicial.tscn")

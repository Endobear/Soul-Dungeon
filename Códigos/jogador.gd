class_name Player
extends CharacterBody2D

var vida = 15
var vidaMax = 30
var speed = 175
var speedz = speed * 2
var speedx = speed
var can_dash = true
var is_dashing = false
var dash_dir =  Vector2.ZERO
@onready var cooldown_dash = $Timer
# speedx é o stopping speed
# speedz é o sprint
@onready var sprite_2d = $Sprite2D
@onready var estado = "idle"
@onready var direcao = "baixo"
@onready var hurtbox = $hurtbox
@onready var hitbox = $hitbox
@onready var iframes = $Iframes


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(iframes.time_left)
	
	
	var current_speed = speed
	if Input.is_key_pressed(KEY_SHIFT):
		current_speed = speedz
		if estado == "andar":
			sprite_2d.speed_scale = 1.5
	
	else:
		sprite_2d.speed_scale = 1
	
	
	if iframes.time_left > 0:
		current_speed = speed / 2
	
	var movimento_horizontal = Input.get_axis("mover_esq","mover_dire")
	var movimento_vertical = Input.get_axis("mover_cima","mover_baixo")
	
	var direction = Vector2(movimento_horizontal,movimento_vertical)
	
	
	
	if direction and (not is_dashing) :
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
		
	elif not is_dashing:
		velocity.x = move_toward(velocity.x,0,speedx)
		velocity.y = move_toward(velocity.y,0,speedx)
		estado = "idle"
	if Input.is_action_just_pressed("ui_accept") and can_dash:
			
				can_dash = false
				is_dashing = true
				$duracaodouglas.start()
				$dashicoldaun.start()
	
	if Input.is_action_just_pressed("ataki_levi")and estado != "ataqueleve" and iframes.time_left != 0 :
		estado = "ataqueleve"
	elif iframes.time_left > 0.0:
		estado = "stunado"
	elif is_dashing:
		velocity = dash_dir * 1300
		
		
		
	if estado == "ataqueleve":
		var objetosAtacados = hurtbox.get_overlapping_bodies()
		for objeto in objetosAtacados:
			print(objeto)
			if objeto != self:
				if objeto is Inimigo:
					objeto.vida -= 1
	var hits = hitbox.get_overlapping_areas()
	if hits and iframes.time_left == 0:
		LevarDano(hits[0])
		
	
	TrocarAnim()
	move_and_slide()
	

func LevarDano(area: Area2D):
	print ("MEATAKARU AAAAAAAAAAAAAAA") 
	vida -= (area.owner.dano)
	estado = "stunado"
	iframes.start()


func _on_timer_timeout():
	is_dashing = false


func _on_dashicoldaun_timeout():
	pass # Replace with function body.
	can_dash = true

func TrocarAnim():
	#if estado == "stunado":
		#var AtualFrame = sprite_2d.frame
		#sprite_2d.play(estado + direcao)
		#sprite_2d.frame = AtualFrame
	#else:
		
	sprite_2d.play(estado + direcao)



func _on_hitbox_area_entered(area):
	if iframes.time_left == 0:
		LevarDano(area)


func _on_iframes_timeout():
	pass # Replace with function body.

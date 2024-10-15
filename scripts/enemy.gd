extends CharacterBody2D

# متغيرات
var speed = 40
var player_chase = false
var player = null
var health = 100
var player_inattack_zone = false

func _physics_process(delta):
	deal_with_damage()
	if player_chase and player:
		chase_player(delta)
	else:
		idle_state()

# دالة لتحريك الشخصية نحو اللاعب
func chase_player(delta):
	var direction = (player.position - position).normalized()
	position += direction * speed * delta
	$AnimatedSprite2D.play("walk")
	$AnimatedSprite2D.flip_h = direction.x < 0  # قم بعكس الصورة حسب الاتجاه

# دالة لتعيين حالة الشخصية إلى الحالة الثابتة
func idle_state():
	$AnimatedSprite2D.play("idle")

# دالة عند دخول الجسم إلى منطقة الكشف
func _on_detection_area_body_entered(body: Node2D) -> void:
		player = body
		player_chase = true

# دالة عند خروج الجسم من منطقة الكشف
func _on_detection_area_body_exited(_body: Node2D) -> void:
		player = null
		player_chase = false

func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true
		

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		health = health - 20
		print("slime health = ", health)
		if health <= 0:
			self.queue_free()  # حذف الوحش إذا كانت الصحة صفر أو أقل

extends CharacterBody2D

# متغيرات اللعب
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 100
var player_alive = true
var attack_ip = false
var global_player_current_attack = false

# ثوابت الحركة
const SPEED = 100
const DIR_RIGHT = 0
const DIR_LEFT = 1
const DIR_DOWN = 2
const DIR_UP = 3

# المتغيرات
var current_dir = DIR_DOWN

@onready var anim_sprite = $AnimatedSprite2D  # للحصول على الـ AnimatedSprite2D مرة واحدة

func _ready():
	# البدء بأنيميشن الوقوف في البداية
	anim_sprite.play("front_idle")

func _physics_process(delta):
	# تحديث الحركة بناءً على المدخلات
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		player_alive = false
		health = 0
		print("player has been killed")
		self.queue_free()
	
	# تحريك الشخصية بناءً على السرعة (الخاصية المدمجة velocity)
	velocity = velocity.normalized() * SPEED
	move_and_slide()  # لا حاجة لتمرير أي معاملات هنا

	# تحديث الأنيميشن بناءً على الاتجاه والحركة
	update_animation()

# دالة الحركة
func player_movement(_delta):
	velocity = Vector2.ZERO  # إعادة تعيين السرعة

	# التعامل مع المدخلات فقط إذا لم يكن الهجوم قيد التنفيذ
	if not attack_ip:
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
			current_dir = DIR_RIGHT
		elif Input.is_action_pressed("ui_left"):
			velocity.x -= 1
			current_dir = DIR_LEFT
		elif Input.is_action_pressed("ui_down"):
			velocity.y += 1
			current_dir = DIR_DOWN
		elif Input.is_action_pressed("ui_up"):
			velocity.y -= 1
			current_dir = DIR_UP

# دالة تحديث الأنيميشن
func update_animation():
	if velocity.length() > 0:
		match current_dir:
			DIR_RIGHT:
				anim_sprite.flip_h = false
				anim_sprite.play("side_walk")
			DIR_LEFT:
				anim_sprite.flip_h = true
				anim_sprite.play("side_walk")
			DIR_DOWN:
				anim_sprite.play("front_walk")
			DIR_UP:
				anim_sprite.play("back_walk")
	else:
		match current_dir:
			DIR_RIGHT, DIR_LEFT:
				anim_sprite.play("side_idle")
			DIR_DOWN:
				anim_sprite.play("front_idle")
			DIR_UP:
				anim_sprite.play("back_idle")

# الدالة المسؤولة عن التحقق من التصادم مع العدو
func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("enemy"):
		enemy_inattack_range = false

# دالة هجوم العدو
func enemy_attack():
	if enemy_inattack_range and enemy_attack_cooldown:
		health -= 20
		enemy_attack_cooldown = false
		$attack_cooldown.start()
		print("health: ", health)

# مؤقت هجوم العدو
func _on_attack_cooldown_timeout() -> void:
	enemy_attack_cooldown = true

# دالة هجوم اللاعب
func attack():
	if Input.is_action_just_pressed("attack") and not attack_ip:
		attack_ip = true
		
		match current_dir:
			DIR_RIGHT:
				anim_sprite.flip_h = false
				anim_sprite.play("side_attack")
			DIR_LEFT:
				anim_sprite.flip_h = true
				anim_sprite.play("side_attack")
			DIR_DOWN:
				anim_sprite.play("front_attack")
			DIR_UP:
				anim_sprite.play("back_attack")
		
		$deal_attack_timer.start()

# إنهاء الهجوم بعد انتهاء المؤقت
func _on_deal_attack_timer_timeout() -> void:
	$deal_attack_timer.stop()
	attack_ip = false  # السماح بالهجوم مرة أخرى بعد انتهاء المؤقت

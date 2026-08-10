extends Node2D

const BattleUnits = preload("res://Resources/BattleUnits.tres")

export(int) onready var hp = 25 setget set_hp 
export(int) var damage = 4

onready var screen = get_tree().current_scene
onready var hpLabel = $HPLabel
onready var animationPlayer = $AnimationPlayer

signal died
signal end_turn

func _ready() -> void:
	BattleUnits.Enemy = self

func set_hp(new_hp):
	hp = new_hp
	if hpLabel != null:
		hpLabel.text = str(hp) + "hp"

func _exit_tree():
	BattleUnits.Enemy = null

func attack() -> void:
	yield (get_tree().create_timer(0.4), "timeout")
	animationPlayer.play("Attack")
	BattleUnits.PlayerStats.hp -= damage
	yield(animationPlayer,"animation_finished")
	emit_signal("end_turn")
	
func take_damage(amount):
	self.hp -= amount
	if is_dead():
		emit_signal("died")
		queue_free()
	else:
		animationPlayer.play("Shake")

func is_dead():
	return hp <= 0

func shake():
	screen.shake(0.18, 5.0)

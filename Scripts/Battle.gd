extends Node2D

export (Array, PackedScene) var enemies = []

const BattleUnits = preload("res://Resources/BattleUnits.tres")
onready var battleActionButtons = $UI/BattleActionButtons
onready var animationPlayer = $AnimationPlayer
onready var nextRoomButton = $UI/CenterContainer/NextRoomButton	
onready var startPosition = $EnemyPostion

var original_position: Vector2 = Vector2.ZERO
var is_shaking := false

func _ready():
	start_player_turn()
	nextRoomButton.hide()
	var enemy = BattleUnits.Enemy
	original_position = position
	if enemy: 
		enemy.connect("died",self,"_on_Enemy_died")

func start_enemy_turn():
	var enemy = BattleUnits.Enemy
	battleActionButtons.hide()
	if enemy != null and not enemy.is_queued_for_deletion():
		enemy.attack()
		yield(enemy, "end_turn")
	start_player_turn()
	
func start_player_turn():
	var playerStats = BattleUnits.PlayerStats
	battleActionButtons.show()
	playerStats.ap = playerStats.max_ap
	yield(playerStats, "end_turn")
	start_enemy_turn()

func _on_Enemy_died():
	battleActionButtons.hide()
	nextRoomButton.show()

func create_new_enemy():
	enemies.shuffle()
	var Enemy = enemies.front()
	var enemy = Enemy.instance()
	startPosition.add_child(enemy) 
	enemy.connect("died", self, "_on_Enemy_died")

func _on_NextRoomButton_pressed():
	nextRoomButton.hide()
	animationPlayer.play("FadeToNewRoom")
	yield(animationPlayer, "animation_finished")
	battleActionButtons.show()
	var playerStats = BattleUnits.PlayerStats
	playerStats.ap = playerStats.max_ap
	create_new_enemy()


func shake(duration: float = 0.18, strength: float = 6.0) -> void:
	if is_shaking:
		return

	is_shaking = true

	var elapsed := 0.0

	while elapsed < duration:
		position = original_position + Vector2(
			rand_range(-strength, strength),
			rand_range(-strength, strength)
		)

		yield(get_tree().create_timer(0.02), "timeout")
		elapsed += 0.02

	position = original_position
	is_shaking = false


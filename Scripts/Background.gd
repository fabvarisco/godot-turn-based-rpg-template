extends Node2D

onready var sky = $Sky

func _ready():
	pass # Replace with function body.

func _process(_delta):
	sky.position.x += _delta * 1

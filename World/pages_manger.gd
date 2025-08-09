extends Control
class_name PAGESMANAGER

@onready var window_node = %WindowNode as WINDOWNODE

func _ready():
	window_node.OpenApp.connect(_openApp)

func _openApp(WhichApp : APPS, SIZESCREEN : Vector2):
	pass

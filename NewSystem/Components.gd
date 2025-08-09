extends Control
class_name COMPONENTS
@export var ParentApp : APPNEW

func _ready():
	self.mouse_entered.connect(_mouseEntro)
	

func _mouseEntro():
	AppsManager._arrayContManager()

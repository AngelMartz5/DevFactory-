extends ColorRect
class_name CONTAINERAPPS

@export var Contain : APPSMANAGER.KINDSAPPS

func _ready():
	self.mouse_entered.connect(_mouseEntered)
	self.mouse_exited.connect(_mouseExited)

func _mouseEntered():
	AppsManager._arrayContManager(self, true)
	

func _mouseExited():
	AppsManager._arrayContManager(self, false)

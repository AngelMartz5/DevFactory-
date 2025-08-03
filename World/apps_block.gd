extends ColorRect
class_name APPSBLOCK

@export var Number : int = 0

func _mouseEntered():
	
	AppsManager.WhoIsAbove = self

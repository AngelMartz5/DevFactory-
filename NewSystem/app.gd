extends ColorRect
class_name APPNEW



@export var KindApp : APPSMANAGER.KINDSAPPS

func _ready():
	self.mouse_entered.connect(_testMouseEntered)

func _testMouseEntered():
	print("EL MERO MERO ENRTO")

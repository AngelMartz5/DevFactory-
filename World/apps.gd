extends AppDetails
class_name APPS

@onready var window_node = %WindowNode

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visibility_changed.connect(_VisibilityChange)
	self.texture = LOGO
	self.mouse_entered.connect(_mouseOnAppEntered)
	self.mouse_exited.connect(_mouseOnAppExited)
	self.focus_entered.connect(_focusEntered)
	self.focus_exited.connect(_focusExited)
	self.focus_mode = Control.FOCUS_ALL
	


func _VisibilityChange():
	if(self.visible):
		print("ME VEO")
	else:
		print("NO ME VEO")

func _mouseOnAppEntered():
	self.modulate = ColorOver
	AppsManager.OnMouseEntered = self
	

func _mouseOnAppExited():
	if !self.modulate == ColorChose:
		
		self.modulate = Color(1, 1, 1, 1)
	AppsManager.OnMouseExited = self

func _focusEntered():
	self.modulate = ColorChose
	print("Este: ", str(self), " Con nombre de : ", str(NAME), " Se puso en Focus")

func _focusExited():
	self.modulate = Color(1, 1, 1, 1)
	print("Este: ", str(self), " Con nombre de : ", str(NAME), " Se salio del puso en Focus")

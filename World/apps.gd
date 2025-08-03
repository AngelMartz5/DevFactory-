extends AppDetails
class_name APPS

@onready var window_node = %WindowNode

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visibility_changed.connect(_VisibilityChange)
	self.texture = LOGO
	self.mouse_entered.connect(_mouseOnAppEntered)
	self.mouse_exited.connect(_mouseOnAppExited)
	

func _VisibilityChange():
	if(self.visible):
		print("ME VEO")
	else:
		print("NO ME VEO")

func _mouseOnAppEntered():
	self.modulate = ColorOver
	AppsManager.OnMouseEntered = self
	Input.set_default_cursor_shape(Input.CURSOR_BUSY)

func _mouseOnAppExited():
	self.modulate = Color(1, 1, 1, 1)
	AppsManager.OnMouseExited = self
	Input.set_default_cursor_shape(Input.CURSOR_BUSY)

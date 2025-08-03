extends TextureRect
class_name AppDetails

@export var NAME : String = ""
@export var LOGO : Texture2D
@export var ColorChose : Color
@export var ColorOver : Color
@export var Dragged : bool = false
var WasDragged : bool = false
@export var InHisPosition : bool = false
@export var CanYouOpenIt : bool = true
@export var Parent : APPSBLOCK = null : set = _setParent
@export var PreferentNumber : int = -1

func _setParent(PARENTNEW: APPSBLOCK):
	Parent = PARENTNEW
	if PARENTNEW != null:
		print("ENTRO: ",str(self), " Y SU NUEVO PADRE ES: ", str(PARENTNEW))
		var current_parent = get_parent()
		if current_parent:
			current_parent.remove_child(self)
		PARENTNEW.add_child(self,true)
		self.global_position = PARENTNEW.global_position
		

		InHisPosition = true
	else:
		InHisPosition = false

extends TextureRect

@export var ImageNew : Texture2D : set = _newImage

func _newImage(newIMG : Texture2D):
	ImageNew = newIMG
	self.texture = newIMG

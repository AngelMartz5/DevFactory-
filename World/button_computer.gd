extends Button
class_name PowerButton
@export var imageOn : Texture2D
@export var imageOff : Texture2D

var ComputerBool : bool = false : set = _computerStateChange

signal ComputadoraEncendida(turnOn : bool)
# Called when the node enters the scene tree for the first time.
func _ready():
	self.icon = imageOff
	
	ComputadoraEncendida.connect(func b(turnOn : bool): if(turnOn): self.icon = imageOn  else: self.icon = imageOff)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _computerStateChange(newbool : bool):
	ComputerBool = newbool
	ComputadoraEncendida.emit(ComputerBool)


func _on_pressed():
	print("PRESSED " + str(ComputerBool))
	ComputerBool = !ComputerBool

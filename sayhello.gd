extends SceneTree

var s = DynamicProperty.new()

func _init():
	print(s)
	s.add(10)
	s.add(20)
	s.add(30)
	print(s.get_total())
	s.reset()

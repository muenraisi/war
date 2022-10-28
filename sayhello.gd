extends SceneTree

var p = BoardPropertyManager.new()

func _init():
	var x
#	print(x, typeof(x))
	x=null
#	print(x, typeof(x))
	p.insert("life", 100, 0, 100)
	assert(p.get_var("life") == 100, "[function]get_var error")
	assert(p.get_final_var("life") == 100, "[function]get_final_var error")
	p.set_var("life", p.get_final_var("life")-10)
	assert(p.get_var("life") == 90, "[function]get_var error")
	assert(p.get_final_var("life") == 90, "[function]get_final_var error")	 
	quit()

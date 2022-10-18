extends Node


class_name Common

static func get_now_time():
#	var timeDict = OS.get_time();
#	var hour = timeDict.hour;
#	var minute = timeDict.minute;
#	var seconds = timeDict.second;
#	return str(hour)+":"+str(minute)+":"+str(seconds)
	var unix_time: float = Time.get_unix_time_from_system()
	var dt: Dictionary = Time.get_datetime_dict_from_unix_time(int(unix_time))
	var res := "%s:%s:%s" % [ dt.hour, dt.minute, dt.second]
	return res

static func print_with_time(obj):
	print(get_now_time()," ", obj)
	
static func print_with_name(obj):
	prints(obj.name, obj)

static func debug_print(arg1 = "", arg2 = "", arg3 = "", arg4 = "", arg5 = "", arg6 = "", arg7 = "", arg8 = ""):
	if OS.is_debug_build():
		print(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)

static func distance_grid_2d(a:Vector2i, b:Vector2i, type="manhattan"):
	match type:
		"manhattan":
			var dx = abs(a.x - b.x)
			var dy = abs(a.y - b.y)
			return dx + dy
		"chebyshev":
			var dx = abs(a.x - b.x)
			var dy = abs(a.y - b.y)
			return max(dx, dy)
		"euclidean":
			var dx2 = (a.x - b.x) * (a.x - b.x)
			var dy2 = (a.y - b.y) * (a.y - b.y)
			return sqrt(dx2 + dy2)
		_:
			return null

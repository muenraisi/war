extends Node


class Cell:
	# item must be hashable
	func _init(cell,parent=null,gscore=0,hscore=0):
		self.cell = cell
		self.parent = parent
		self.gscore = gscore
		self.hscore = hscore

	func __eq__(other):
		return other.cell == self.cell

	func __lt__( other):
		return self.gscore + self.hscore < other.gscore + other.hscore

	func __hash__():
		return hash(self.item)


#static func compute_gscore(src:Vector2, dst:Vector2):
#	return null

static func compute_hscore(src:Vector2, dst:Vector2):
	return max(abs(src.x-dst.x), abs(src.y-dst.y))

#static func astar_find_path(src:Vector2, dst:Vector2):
#	var path = []
#	var openpath = {}
#	var queue = []
#	var closepath = []
#	var found = false
#	var dst_cell = Cell.new(dst)
#	var now_cell = Cell.new(src)
#	now_cell.hscore = compute_hscore(src, dst)
#
#	openpath[start] = node
#	queue.append(node)
#	while openpath and not found:
#		current = queue.pop(0)
#		openpath.pop(current.item)
#		closepath.add(current)
#		for node in getchildren(current):
#			if not available(node):
#				continue
#			elif node in closepath:
#				continue
#			elif node == target:
#				path = generate(node)
#				found = True
#				break
#			else:
#				duplicated = openpath.get(node.item)
#				if not duplicated:
#					node.heuristic = heuristic(node, target)
#					openpath[node.item] = node
#					bisect.insort_left(queue, node)
#				elif duplicated.gscore > node.gscore:
#					left = bisect.bisect_left(queue, duplicated)
#					right = bisect.bisect_right(queue, duplicated)
#					queue.pop(queue.index(duplicated, left, right))
#					node.heuristic = heuristic(node, target)
#					openpath[node.item] = node
#					bisect.insort_left(queue, node)
#	return path
	

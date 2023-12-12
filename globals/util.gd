extends Node2D
class_name Util


static func isInsideSquare(A: Vector2, B: Vector2, C: Vector2, D: Vector2, P: Vector2) -> bool:
	if (
		triangleAndSquareAreaComparison(A, B, P) > 0
		|| triangleAndSquareAreaComparison(B, C, P) > 0
		|| triangleAndSquareAreaComparison(C, D, P) > 0
		|| triangleAndSquareAreaComparison(D, A, P) > 0.
	):
		return false
	else:
		return true


static func get_square_direction_vectors():
	var block_direction_map = [
		Vector2(1, 0),
		Vector2(-1, 0),
		Vector2(0, 1),
		Vector2(0, -1),
		Vector2(1, 1),
		Vector2(1, -1),
		Vector2(-1, 1),
		Vector2(-1, -1),
	]
	return block_direction_map


static func triangleAndSquareAreaComparison(A: Vector2, B: Vector2, C: Vector2):
	return (C.x * B.y - B.x * C.y) - (C.x * A.y - A.x * C.y) + (B.x * A.y - A.x * B.y)


static func clear_callables_from_signals_in_node(node: Node) -> void:
	for i in node.get_signal_list():
		var sig_connections = node.get_signal_connection_list(i["name"])
		for j in sig_connections:
			var sig: Signal = j["signal"]
			var cal: Callable = j["callable"]
			sig.disconnect(cal)

extends Node2D

onready var bubble_scene = load("res://World/NotificationBubble.tscn")

var bubbles = []

func _ready():
	Helper.connect("send_notification", self, "_on_Helper_send_notification")

func _on_Helper_send_notification(msg):
	print("Received message: ", msg)
	
	var bubble = bubble_scene.instance()
	bubble.position = Vector2.ZERO
	bubble.msg = msg
	bubble.timer = 3.0
	bubble.connect("bubble_expired", self, "_on_NotificationBubble_bubble_expired")
	bubbles.append(bubble)
	
	add_child(bubble)
	
	shift_up(bubble.height + 1)

func shift_up(amt: float):
	for bubble in bubbles:
		$Tween.interpolate_property(bubble, "position", bubble.position, bubble.position + Vector2(0, -amt), 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

func _on_NotificationBubble_bubble_expired(node):
	bubbles.erase(node)
	node.queue_free()

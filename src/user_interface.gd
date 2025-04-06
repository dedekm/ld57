extends CanvasLayer

var text_lines := []
var active := false

@onready var main_text_label = $MainTextLabel

signal tag_clicked(tag)

func add_text_lines(new_text_lines: Array) -> void:
	text_lines.append_array(new_text_lines)

func read_next_text_line() -> void:
	active = true
	var current_text_line = text_lines.pop_front()

	if current_text_line:
		main_text_label.text = "[center]%s[/center]" % current_text_line
	else:
		main_text_label.text = ""
		active = false

func _on_main_text_label_meta_clicked(meta: Variant) -> void:
	emit_signal("tag_clicked", meta)

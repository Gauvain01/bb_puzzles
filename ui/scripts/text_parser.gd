extends VBoxContainer
@onready var font = $Label.get_font("normal_font")
@onready var window_size = $Label.get_size()

var max_lines
var total_lines = 0
var scroll = false

func addPlaceholderSpaces():
	$Label.clear()
	var font_height = font.get_height()
	max_lines = window_size[1] / font_height
	
	for line in max_lines:
		$Label.newline()

func addText(text):
	if text != '':
		$Label.newline()
		$Label.add_text( text)
		addLines(text)
	$TextEdit.set_text('')
	if not scroll and total_lines >= max_lines:
		$Label.set_scroll_active(1)
		for line in max_lines:
			$Label.remove_line(0)
		scroll = true

func addLines(text):
	var text_width = 0
	text_width += font.get_string_size(' > ')[0]
	for letter in text:
		text_width += font.get_string_size(letter)[0]
	var additional_lines = floor(text_width / window_size[0])
	total_lines += 1 + additional_lines

	total_lines = total_lines * 2

extends RichTextLabel

func parse_text(to_parse :String) -> void:
	const STYLES = {
		"+" : ["[b][color=LIGHT_SKY_BLUE]+","[/color][/b]"],
		"x" : ["[b][color=TOMATO]×","[/color][/b]"],
		"*" : ["[outline_size=4][b][outline_color=INDIGO]", "[/outline_color][/b][/outline_size]"],
		"c" : ["[outline_size=4][b][u][outline_color=BLACK]", "[/outline_color][/u][/b][/outline_size]"],
	}
	var in_token :bool = false
	var token :String = ""
	var tokens :Array[String] = []
	for c in to_parse:
		if c == "<" or c == ">":
			if token != "":
				if c == ">":
					var key := token[0]
					if STYLES.has(key):
						tokens.append(STYLES[key][0])
						tokens.append(token.right(-1))
						tokens.append(STYLES[key][1])
				else:
					tokens.append(token)
			token = ""
		if c != "<" and c != ">":
			token += c
	tokens.append(token)
	text = "".join(tokens)

func _ready() -> void:
	parse_text("<+12> score <x1.5>\n<*When scoring card: >\nGet super bonus")

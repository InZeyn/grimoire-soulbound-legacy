shader_type canvas_item;

uniform vec4 aura_color : source_color = vec4(0.8, 0.6, 0.2, 0.5);

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	float pulse = (sin(TIME * 2.0) + 1.0) * 0.5;
	float alpha = mix(0.2, 1.0, pulse);
	COLOR = mix(base, aura_color, aura_color.a * alpha);
	COLOR.a = base.a * mix(0.5, 1.0, pulse);
}

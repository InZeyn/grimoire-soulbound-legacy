shader_type canvas_item;

uniform float flash_intensity : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	COLOR = mix(base, vec4(1.0, 1.0, 1.0, base.a), flash_intensity);
}

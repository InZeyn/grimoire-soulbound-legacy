shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.85, 0.3, 1.0);
uniform float glow_intensity : hint_range(0.0, 2.0) = 0.0;

void fragment() {
	vec4 base = texture(TEXTURE, UV);

	// Sample neighboring pixels for edge detection
	vec2 pixel_size = TEXTURE_PIXEL_SIZE;
	float alpha_sum = 0.0;
	alpha_sum += texture(TEXTURE, UV + vec2(pixel_size.x * 2.0, 0.0)).a;
	alpha_sum += texture(TEXTURE, UV - vec2(pixel_size.x * 2.0, 0.0)).a;
	alpha_sum += texture(TEXTURE, UV + vec2(0.0, pixel_size.y * 2.0)).a;
	alpha_sum += texture(TEXTURE, UV - vec2(0.0, pixel_size.y * 2.0)).a;

	// Detect edges where alpha changes
	float edge = abs(base.a * 4.0 - alpha_sum);
	float glow = edge * glow_intensity;

	// Add glow at edges
	vec4 glow_result = mix(base, glow_color, clamp(glow, 0.0, 0.8));
	glow_result.a = max(base.a, glow * 0.5);

	COLOR = glow_result;
}

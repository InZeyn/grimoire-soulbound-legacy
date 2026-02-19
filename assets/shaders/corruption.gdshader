shader_type canvas_item;

uniform float radiant_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float vile_intensity : hint_range(0.0, 1.0) = 0.0;
uniform float primal_intensity : hint_range(0.0, 1.0) = 0.0;

const vec3 RADIANT_COLOR = vec3(1.0, 0.85, 0.4);
const vec3 VILE_COLOR = vec3(0.5, 0.2, 0.7);
const vec3 PRIMAL_COLOR = vec3(0.2, 0.6, 0.3);

void fragment() {
	vec4 base = texture(TEXTURE, UV);
	vec3 result = base.rgb;
	result = mix(result, RADIANT_COLOR, radiant_intensity * 0.4);
	result = mix(result, VILE_COLOR, vile_intensity * 0.4);
	result = mix(result, PRIMAL_COLOR, primal_intensity * 0.4);
	COLOR = vec4(result, base.a);
}

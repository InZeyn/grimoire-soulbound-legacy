shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec4 base = texture(TEXTURE, UV);

	// Page curl simulation: displace UVs based on progress
	float curl_edge = progress;
	float dist_from_edge = UV.x - curl_edge;

	if (dist_from_edge > 0.0) {
		// Behind the turning page — hidden
		COLOR = vec4(0.0, 0.0, 0.0, 1.0);
	} else if (dist_from_edge > -0.1) {
		// Curl zone — shadow at fold
		float shadow = smoothstep(-0.1, 0.0, dist_from_edge);
		vec2 curled_uv = UV;
		curled_uv.x = curl_edge - dist_from_edge;
		vec4 curled = texture(TEXTURE, clamp(curled_uv, vec2(0.0), vec2(1.0)));
		COLOR = mix(base, curled * 0.6, shadow);
	} else {
		// Normal page content
		COLOR = base;
	}
}

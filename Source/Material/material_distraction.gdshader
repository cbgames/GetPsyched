shader_type canvas_item;

uniform float grid_size : hint_range(2.0, 20.0) = 8.0;
uniform float shape_speed : hint_range(0.1, 5.0) = 1.0;
uniform float shape_scale : hint_range(0.1, 0.9) = 0.3;
uniform float blur : hint_range(0.01, 0.5) = 0.05;
uniform float global_alpha : hint_range(0.0, 1.0) = 0.5;
uniform float scroll_speed_x : hint_range(-5.0, 5.0) = 0.2;
uniform float scroll_speed_y : hint_range(-5.0, 5.0) = 0.1;

vec2 hash22(vec2 p) {
	vec3 p3 = fract(vec3(p.xyx) * vec3(0.1031, 0.1030, 0.1173));
	p3 += dot(p3, p3.yzx + 33.33);
	return fract((p3.xx + p3.yz) * p3.zy);
}

void fragment() {
	vec2 scrolled_uv = UV + vec2(scroll_speed_x, scroll_speed_y) * TIME;
	vec2 uv = scrolled_uv * grid_size;
	vec2 grid_id = floor(uv);
	vec2 grid_uv = fract(uv);
	
	vec2 rand_vals = hash22(grid_id);
	
	float shape_type = rand_vals.x;
	float phase_shift = rand_vals.y * 6.2831;
	
	float time_factor = TIME * shape_speed + phase_shift;
	vec2 shape_center = vec2(0.5) + vec2(cos(time_factor), sin(time_factor * 0.7)) * 0.2;
	
	vec2 to_center = grid_uv - shape_center;
	float dist = 0.0;
	
	if (shape_type < 0.33) {
		dist = length(to_center);
	} else if (shape_type < 0.66) {
		vec2 d = abs(to_center);
		dist = max(d.x, d.y);
	} else {
		vec2 d = abs(to_center);
		dist = d.x + d.y;
	}
	
	float shape_mask = smoothstep(shape_scale, shape_scale - blur, dist);
	
	vec3 base_color = 0.5 + 0.5 * cos(TIME * 0.5 + grid_id.xyx * 0.7 + vec3(0.0, 2.0, 4.0));
	COLOR = vec4(base_color, shape_mask * global_alpha);
}

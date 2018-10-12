shader_type canvas_item;

uniform vec4 color : hint_color = vec4(0.35, 0.48, 0.95, 1.0);
uniform float noise_scale = 20.0;
uniform float alpha_power = 2.0;
uniform int OCTAVES = 1;

float rand(vec2 coord){
	return fract(sin(dot(coord, vec2(56, 78)) * 1000.0) * 1000.0);
}

float noise(vec2 coord){
	vec2 i = floor(coord);
	vec2 f = fract(coord);

	// 4 corners of a rectangle surrounding our point
	float a = rand(i);
	float b = rand(i + vec2(1.0, 0.0));
	float c = rand(i + vec2(0.0, 1.0));
	float d = rand(i + vec2(1.0, 1.0));

	vec2 cubic = f * f * (3.0 - 2.0 * f);

	return mix(a, b, cubic.x) + (c - a) * cubic.y * (1.0 - cubic.x) + (d - b) * cubic.x * cubic.y;
}

float fbm(vec2 coord){
	float value = 0.0;
	float scale = 0.5;

	for(int i = 0; i < OCTAVES; i++){
		value += noise(coord) * scale;
		coord *= 2.0;
		scale *= 0.5;
	}
	return value;
}

void fragment() {
	vec2 coord = UV * noise_scale;
	vec2 motion = vec2( fbm(coord + vec2(TIME * -0.5, TIME * 0.5)) );
	float final = fbm(coord + motion);
	COLOR = vec4(color.rgb, pow(final, alpha_power) * color.a);
}

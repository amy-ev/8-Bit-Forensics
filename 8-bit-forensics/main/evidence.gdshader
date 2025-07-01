shader_type canvas_item;

uniform float fov: hint_range(1,179) = 90;
uniform float x_rot : hint_range(-180, 180) = 0.0;
uniform float y_rot : hint_range(-180, 180) = 0.0;

//uniform vec2 rect_size = vec2(120.0, 144.0);
uniform float inset: hint_range(-1,1) = 0.0;

uniform sampler2D front: repeat_disable, filter_nearest;
uniform sampler2D back: repeat_disable, filter_nearest;

varying flat mat3 material;
varying flat vec2 offset;
varying vec3 plane;
varying vec4 color;


void vertex() {
	float sin_b = sin(y_rot / 180.0 * PI);
	float cos_b = cos(y_rot / 180.0 * PI);
	float sin_c = sin(x_rot / 180.0 * PI);
	float cos_c = cos(x_rot / 180.0 * PI);
	
	material[0][0] = cos_b;
	material[0][1] = 0.0;
	material[0][2] = -sin_b;
	
	material[1][0] = sin_b * sin_c;
	material[1][1] = cos_c;
	material[1][2] = cos_b * sin_c;
	
	material[2][0] = sin_b * cos_c;
	material[2][1] = -sin_c;
	material[2][2] = cos_b * cos_c;
	
	float t = tan(fov / 360.0 * PI);
	plane = material * vec3((UV - 0.5), 0.5 / t);
	
	float v = (0.5 / t) + 0.5;
	plane.xy *= v * material[2].z;
	
	offset = v * material[2].xy;
	
	VERTEX += (UV- 0.5) / TEXTURE_PIXEL_SIZE * t * (0.5 - inset);
}

void fragment() {
	vec2 uv = (plane.xy / plane.z).xy - offset;
	if (plane.z <= 0.0){
		color = texture(back, uv + 0.5);
		color.a *= step(max(abs(uv.x), abs(uv.y)),0.5);	
	}else{
		color = texture(front, uv + 0.5);
		color.a *= step(max(abs(uv.x), abs(uv.y)),0.5);	
	}
	COLOR = color;
}


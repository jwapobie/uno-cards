shader_type canvas_item;

uniform int array_size;
uniform vec3[20] input_points;
uniform vec2 canvas_size;

uniform sampler2D color_ramp;

void vertex() {
	
}

float ball_dist(vec2 pos, float r, vec2 uv) {
	return smoothstep(10.0, 40.1, r/distance(uv, pos));
	
}

void fragment() {
	vec2 uv = UV;
	uv.x = uv.x*canvas_size.x/canvas_size.y;
	COLOR = vec4(vec3(0.0), 1.0);
	float dist = 0.0;
	for(int i = 0; i < array_size; i++) {
		dist += ball_dist(input_points[i].xy, input_points[i].z, uv);
	}
	float edge = 0.8;
	dist += pow(uv.y*1.05, 10)*0.5;
	dist += pow((1.0 - uv.y)*1.05, 10)*0.5;
	dist = smoothstep(edge - 0.02, edge + 0.02, dist)*0.2 + dist*0.8;
	COLOR = texture(color_ramp, vec2(dist));
	//COLOR = vec4(vec3(dist), 1.0);
	//COLOR = vec4(vec3(UV.x), 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}

shader_type canvas_item;

uniform float blurOffset = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 totalColor = vec4(0.0);
	for(int x = -1; x < 2; x++){
		for(int y = -1; y < 2; y++){
			totalColor += texture(TEXTURE, UV+vec2(float(x)*blurOffset, float(y)*blurOffset));
		}
	}
	totalColor = totalColor/9.0;
	COLOR = totalColor;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

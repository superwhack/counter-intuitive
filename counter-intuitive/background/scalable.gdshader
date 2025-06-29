shader_type canvas_item;

uniform float scale = 1.0;

void vertex() {
	UV -= vec2(0.5, 0.5);
		
	UV *= scale;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

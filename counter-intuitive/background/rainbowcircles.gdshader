shader_type canvas_item;

uniform float scale = 1;

void vertex() {
	UV -= vec2(0.5, 0.5);

	UV *= scale;

	UV.x += TIME * 0.01;
	UV.y += sin(TIME * 0.02);


}

// Modified from https://godotshaders.com/shader/moving-rainbow-gradient/ by Exuin
// HSV to RBG from https://www.rapidtables.com/convert/color/hsv-to-rgb.html
// Rotation matrix from https://en.wikipedia.org/wiki/Rotation_matrix

uniform float strength: hint_range(0., 1.) = 0.5;
uniform float speed: hint_range(0., 10.) = -0.15;
// uniform float angle: hint_range(0., 360.) = 0.;

void fragment() {
	float angle = TIME * 0.01;
	float hue = UV.x * cos(radians(angle)) - UV.y * sin(radians(angle));
	hue = fract(hue + fract(TIME  * speed));
	float x = 1. - abs(mod(hue / (1./ 6.), 2.) - 1.);
	vec3 rainbow;
	if(hue < 1./6.){
		rainbow = vec3(1., x, 0.);
	} else if (hue < 1./3.) {
		rainbow = vec3(x, 1., 0);
	} else if (hue < 0.5) {
		rainbow = vec3(0, 1., x);
	} else if (hue < 2./3.) {
		rainbow = vec3(0., x, 1.);
	} else if (hue < 5./6.) {
		rainbow = vec3(x, 0., 1.);
	} else {
		rainbow = vec3(1., 0., x);
	}
	vec4 color = texture(TEXTURE, UV);
	COLOR = mix(color, vec4(rainbow, color.a), strength);
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}

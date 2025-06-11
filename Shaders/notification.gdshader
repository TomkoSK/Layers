shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

uniform float transparentWidth = 0.2;
uniform float whiteWidth = 0.2;

void fragment() {
	vec4 c = textureLod(screen_texture, SCREEN_UV, 0.0);

	if (c.a > 0.0001) {
		c.rgb /= c.a;
	}

	COLOR *= c;
	
	if(UV.x < transparentWidth){
		COLOR = vec4(0);
	}
	else if(UV.x < transparentWidth+whiteWidth)
	{
		COLOR = vec4(1, 1, 1, 0.7);
	}
}

shader_type canvas_item;

uniform vec4 color : source_color;
uniform float outlineSize : hint_range(0.0, 50.0);
uniform float opacityThreshold : hint_range(0.0, 1.0);
uniform float blur : hint_range(0.0, 0.05);
uniform int blurSteps : hint_range(1, 4) = 1;

void vertex() {
	VERTEX+=(UV-0.5)*outlineSize*2.0;
}

void fragment() {
	vec2 uv = UV;
	uv = uv+(uv-0.5)*TEXTURE_PIXEL_SIZE*outlineSize*2.0;
	if(texture(TEXTURE, uv).a > opacityThreshold)
		discard;
	else {
		if(blur == 0.0){
			if(outlineSize > 0.0 && (texture(TEXTURE, vec2(uv.x+TEXTURE_PIXEL_SIZE.x*outlineSize, uv.y)).a > opacityThreshold || texture(TEXTURE, vec2(uv.x-TEXTURE_PIXEL_SIZE.x*outlineSize, uv.y)).a > opacityThreshold || texture(TEXTURE, vec2(uv.x, uv.y+TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(uv.x, uv.y-TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(uv.x+TEXTURE_PIXEL_SIZE.x*outlineSize, uv.y+TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(uv.x-TEXTURE_PIXEL_SIZE.x*outlineSize, uv.y-TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(uv.x-TEXTURE_PIXEL_SIZE.x*outlineSize, uv.y+TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(uv.x+TEXTURE_PIXEL_SIZE.x*outlineSize, uv.y-TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold)){
				COLOR = color;
			}
			else
				discard;
			}
		else{
			vec4 finalColor = vec4(0.0f);
			for(float offsetX = -blur; offsetX <=blur; offsetX+=blur/float(blurSteps)){
				for(float offsetY = -blur; offsetY <=blur; offsetY+=blur/float(blurSteps)){
					vec2 offsetUV = uv+vec2(offsetX, offsetY);
					if(outlineSize > 0.0 && (texture(TEXTURE, vec2(offsetUV.x+TEXTURE_PIXEL_SIZE.x*outlineSize, offsetUV.y)).a > opacityThreshold || texture(TEXTURE, vec2(offsetUV.x-TEXTURE_PIXEL_SIZE.x*outlineSize, offsetUV.y)).a > opacityThreshold || texture(TEXTURE, vec2(offsetUV.x, offsetUV.y+TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(offsetUV.x, offsetUV.y-TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(offsetUV.x+TEXTURE_PIXEL_SIZE.x*outlineSize, offsetUV.y+TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(offsetUV.x-TEXTURE_PIXEL_SIZE.x*outlineSize, offsetUV.y-TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(offsetUV.x-TEXTURE_PIXEL_SIZE.x*outlineSize, offsetUV.y+TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold || texture(TEXTURE, vec2(offsetUV.x+TEXTURE_PIXEL_SIZE.x*outlineSize, offsetUV.y-TEXTURE_PIXEL_SIZE.y*outlineSize)).a > opacityThreshold)){
						finalColor += color;
					}
				}
			}
			finalColor = finalColor/(9.0*float(blurSteps));
			COLOR = vec4(color.xyz, finalColor.a);
		}
	}
}
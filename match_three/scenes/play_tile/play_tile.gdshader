shader_type canvas_item;

uniform bool Selected;
uniform sampler2D Texture2DParameter;

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);
	return mix(2.0 * base * blend, 1.0 - 2.0 * (1.0 - base) * (1.0 - blend), limit);
}

void fragment() {
	bool selected = Selected;
	
	if(selected){
		vec4 current = texture(TEXTURE, UV);
		vec4 highlight = texture(Texture2DParameter, UV);
		COLOR = overlay(current, highlight);
	}else{
		COLOR = texture(TEXTURE, UV);
	}
}


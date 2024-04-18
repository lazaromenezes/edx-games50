shader_type canvas_item;

uniform bool Hovered = false;
uniform bool Selected = false;
uniform bool Shiny = false;

uniform sampler2D HighlightTexture;

uniform float ShineSpeed : hint_range(0.0, 10.0, 0.1) = 1.0;
uniform float ShineAmount : hint_range(0.01, 1.0, 0.01) = 0.01;

vec4 overlay(vec4 base, vec4 blend){
	vec4 limit = step(0.5, base);

	return mix(2.0 * base * blend, 1.0 - 1.5 * (1.0 - base) * (1.0 - blend), limit);
}

void fragment() {
	vec4 current = texture(TEXTURE, UV);
	vec4 highlight = texture(HighlightTexture, UV);

	if((Hovered && !Selected) || Selected){
		current = overlay(current, highlight);
	}

	if(Shiny){
		vec4 shineColor = current.rgba * (1.0 + ShineAmount);
		float cycle = sin(TIME * ShineSpeed);
		float pulse = cycle >= 0.0 ? abs(cycle) : 0.0;
		current.rgb = mix(current.rgb, shineColor.rgb, pulse * shineColor.a);
	}

	COLOR = current;
}


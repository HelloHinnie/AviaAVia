shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D next_scene : hint_default_black;

void fragment() {
	vec4 frame_color = texture(TEXTURE, UV);
	
	float greenness = frame_color.g - max(frame_color.r, frame_color.b);
	float blueness = frame_color.b - max(frame_color.r, frame_color.g);
	
	// Verde → transparente (mostra cena atual por baixo do CanvasLayer)
	if (greenness > 0.15) {
		discard;
	}
	// Azul → mostra cena seguinte
	else if (blueness > 0.15) {
		COLOR = texture(next_scene, UV);
	}
	// Papel (branco/cinza) → mostra o próprio papel como overlay
	else {
		COLOR = frame_color;
	}
}

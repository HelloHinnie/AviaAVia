shader_type canvas_item;

uniform float amplitude : hint_range(0.0, 0.5) = 0.1;
uniform float frequency : hint_range(0.0, 20.0) = 10.0;
uniform float speed : hint_range(0.0, 10.0) = 2.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Calcula a onda baseada no eixo X e no tempo
    float wave = sin(UV.x * frequency + TIME * speed) * amplitude;
    
    // Define o limite de preenchimento (ajustado pela onda)
    // Se o UV.y for maior que o preenchimento + a onda, fica transparente
    float fill_limit = 1.0 - COLOR.a; // Usamos o alpha original ou um uniform de progresso
    
    if (UV.y < 0.5 + wave) {
        COLOR = tex_color;
    } else {
        COLOR = vec4(0.0); // Torna invisível o que estiver fora da "onda"
    }
}
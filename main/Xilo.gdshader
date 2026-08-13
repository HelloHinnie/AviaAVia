shader_type canvas_item;

// Textura de ruído usada para gerar as imperfeições (artefatos)
uniform sampler2D noise_tex : repeat_enable;

// Intensidade das ranhuras e cortes na borda
uniform float distortion_strength : hint_range(0.0, 0.1) = 0.015;

// Velocidade da animação em quadros por segundo (baixo para efeito stop-motion)
uniform float fps = 6.0;

// Escala do ruído (ajuste dependendo da resolução da sua arte)
uniform float noise_scale = 1.0;

// Limiar para manter as bordas duras e rústicas, sem desfoque
uniform float threshold : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Cria um tempo "em degraus" para o efeito squiggle (muda a cada X frames)
    float stepped_time = floor(TIME * fps);

    // Desloca o mapa de ruído de forma irregular a cada "frame" do stepped_time
    vec2 noise_uv = UV * noise_scale + vec2(stepped_time * 0.37, stepped_time * 0.19);

    // Amostra a textura de ruído
    vec4 noise_color = texture(noise_tex, noise_uv);

    // Converte o ruído de [0, 1] para [-1, 1] para distorcer em todas as direções
    vec2 offset = (noise_color.rg - 0.5) * 2.0;

    // Aplica a distorção nas coordenadas UV originais
    vec2 distorted_uv = UV + offset * distortion_strength;

    // Lê a textura original usando o novo UV distorcido
    vec4 final_color = texture(TEXTURE, distorted_uv);

    // O step() força o canal alpha a ser 0 ou 1, eliminando pixels semitransparentes.
    // Isso garante o aspecto de tinta impressa / corte de madeira.
    final_color.a = step(threshold, final_color.a);

    COLOR = final_color;
}
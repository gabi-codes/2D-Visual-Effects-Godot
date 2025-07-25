shader_type canvas_item;

// Kolory
uniform vec4 center_color : source_color = vec4(0.1, 0.29, 0.54, 1);   // #1a4b8a
uniform vec4 edge_color : source_color = vec4(0.04, 0.07, 0.16, 1);    // #0a1128
uniform float smoothness : hint_range(0.1, 2.0) = 0.8;
uniform float base_radius : hint_range(0.1, 1.5) = 0.7;                // Bazowy rozmiar środka
uniform float pulse_speed : hint_range(0, 5) = 1.0;                    // Szybkość pulsowania
uniform float pulse_strength : hint_range(0, 0.5) = 0.1;               // Siła pulsowania (0 = brak)

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    float dist_from_center = distance(UV, center) / 0.7071;
    
    // Pulsujący radius (sinus + przesunięcie aby wartość była dodatnia)
    float radius = base_radius + pulse_strength * sin(TIME * pulse_speed) * 0.5;
    
    // Winieta
    float vignette = smoothstep(radius, radius - smoothness, 1.0 - dist_from_center);
    COLOR = mix(edge_color, center_color, vignette);
    

}
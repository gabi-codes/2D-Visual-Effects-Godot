shader_type canvas_item;

uniform vec4 main_color : source_color = vec4(0.1, 0.29, 0.54, 1);   
uniform vec4 edge_color : source_color = vec4(0.04, 0.07, 0.16, 1);    
uniform float smoothness : hint_range(0.1, 2.0) = 0.8;
uniform float base_radius : hint_range(0.1, 1.5) = 0.7;                
uniform float pulse_speed : hint_range(0, 5) = 1.0;                    
uniform float pulse_strength : hint_range(0, 0.5) = 0.1;               

void fragment() {
    vec2 center = vec2(0.5, 0.5);
    float dist_from_center = distance(UV, center) / 0.7071;
    
    float radius = base_radius + pulse_strength * sin(TIME * pulse_speed) * 0.5;
    
    float vignette = smoothstep(radius, radius - smoothness, 1.0 - dist_from_center);
    COLOR = mix(edge_color, main_color, vignette);
    

}
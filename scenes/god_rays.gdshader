/*
Shader from Godot Shaders - the free shader library.
godotshaders.com/shader/god-rays

Feel free to use, improve and change this shader according to your needs
and consider sharing the modified result on godotshaders.com.
*/

shader_type canvas_item;

uniform float angle = 0.0;
uniform float position = 0.0;
uniform float spread : hint_range(0.0, 1.0) = 0.5;
uniform float cutoff : hint_range(0.0, 1.0) = 0.1;
uniform float falloff = 0.2;
uniform float edge_fade = 0.165;

uniform float speed = 1.0;
uniform float ray1_density = 8.0;
uniform float ray2_density = 30.0;
uniform float ray2_intensity : hint_range(0.0, 1.0) = 0.3;

uniform vec4 color : source_color = vec4(1.0, 0.9, 0.65, 0.8);
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

uniform float seed = 8.0;

const vec2 noise_vec1 = vec2(12.9898, 78.233);
const float noise_scalar = 43758.5453123;
const vec2 ray_dir = vec2(1.0);

float random(vec2 uv) {
    return fract(sin(dot(uv, noise_vec1)) * noise_scalar);
}

float noise (in vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));

    vec2 u = f * f * (3.0-2.0 * f);

    return mix(a, b, u.x) +
            (c - a)* u.y * (1.0 - u.x) +
            (d - b) * u.x * u.y;
}

mat2 rotate(float _angle){
    return mat2(vec2(cos(_angle), -sin(_angle)),
                vec2(sin(_angle), cos(_angle)));
}

vec4 screen(vec4 base, vec4 blend){
	return 1.0 - (1.0 - base) * (1.0 - blend);
}

vec4 soft_light(vec4 base, vec4 blend){
	vec4 limit = step(0.5, blend);
	return mix(2.0 * base * blend + base * base * (1.0 - 2.0 * blend), sqrt(base) * (2.0 * blend - 1.0) + (2.0 * base) * (1.0 - blend), limit);
}


void fragment()
{
	float time_factor1 = TIME * 0.1 * speed;
    float time_factor2 = TIME * 0.2 * speed;
    
    vec2 transformed_uv = (rotate(angle) * (UV - position)) / ((UV.y + spread) - (UV.y * spread));
    
    float cut = step(cutoff, transformed_uv.x) * step(cutoff, 1.0 - transformed_uv.x);
    
    vec2 ray1 = vec2(transformed_uv.x * ray1_density + sin(time_factor1) * (ray1_density * 0.2) + seed, 1.0);
    vec2 ray2 = vec2(transformed_uv.x * ray2_density + sin(time_factor2) * (ray1_density * 0.2) + seed, 1.0);
    ray1 *= cut;
    ray2 *= cut;
    
    float rays = noise(ray1) + (noise(ray2) * ray2_intensity);
    
    rays *= smoothstep(0.0, falloff, (1.0 - UV.y));
    
    float edge = smoothstep(0.0 + cutoff, edge_fade + cutoff, min(transformed_uv.x, 1.0 - transformed_uv.x));
    rays *= edge;
    
    vec3 shine = vec3(rays) * color.rgb;
	shine = screen(texture(SCREEN_TEXTURE, SCREEN_UV), vec4(color)).rgb;
    
    COLOR = vec4(shine, rays * color.a);
}
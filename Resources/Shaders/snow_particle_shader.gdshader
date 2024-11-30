shader_type canvas_item;

uniform float scale_start;
uniform float scale_end;
uniform float grid_size;

void vertex() {
    // Lifetime ratio: reverse COLOR.a (1.0 at birth, 0.0 at death -> 0.0 to 1.0)
    float lifetime_ratio = 1.0 - COLOR.a;

    float current_size = mix(scale_start, scale_end, lifetime_ratio);

    VERTEX *= current_size;

    vec4 world_pos = MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0);
    world_pos.xy = floor(world_pos.xy / grid_size) * grid_size;
    VERTEX = (inverse(MODEL_MATRIX) * world_pos).xy;
}

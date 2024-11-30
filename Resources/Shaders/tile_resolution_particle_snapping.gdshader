shader_type canvas_item;

uniform float grid_size = 8.0;

void vertex() {
    vec4 world_pos = MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0);

    world_pos.xy = floor(world_pos.xy / grid_size) * grid_size;

    VERTEX = (inverse(MODEL_MATRIX) * world_pos).xy;
}

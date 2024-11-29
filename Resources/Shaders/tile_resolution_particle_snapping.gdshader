shader_type canvas_item;

uniform vec2 grid_size = vec2(4.0, 4.0);

void vertex() {
    vec2 snapped_pos = vec2(
        round(VERTEX.x / grid_size.x) * grid_size.x,
        round(VERTEX.y / grid_size.y) * grid_size.y
    );

    // Visualize snapping process by shifting the particle based on grid alignment
    VERTEX = snapped_pos;
}

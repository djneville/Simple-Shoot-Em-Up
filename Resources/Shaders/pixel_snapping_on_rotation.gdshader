// Pixel Snapping on Rotation Shader
// Rotates the sprite's texture in discrete steps and snaps UV coordinates to pixel centers.

shader_type canvas_item;

// Number of discrete rotation steps (e.g., 8 for 45-degree increments)
uniform int rotation_steps : hint_range(1, 8) = 8;

// Size of the sprite's texture in pixels (width, height)
uniform vec2 texture_size = vec2(16.0, 16.0);

// Current rotation of the sprite in radians, updated from the script
uniform float rotation = 0.0;

void fragment() {
    // Normalize rotation angle to [0, 2π)
    float two_pi = 6.283185307179586;
    float normalized_rotation = mod(rotation, two_pi);
    if (normalized_rotation < 0.0) {
        normalized_rotation += two_pi;
    }

    // Use built-in UV coordinates ranging from (0.0, 0.0) to (1.0, 1.0)
    vec2 uv = UV;

    // Calculate the angle increment for each discrete rotation step
    float step_angle = two_pi / float(rotation_steps);

    // Snap the current rotation to the nearest discrete step
    float snapped_angle = round(normalized_rotation / step_angle) * step_angle;

    // Create a 2x2 rotation matrix using the snapped angle
    mat2 rotation_matrix = mat2(
        vec2(cos(snapped_angle), -sin(snapped_angle)),
        vec2(sin(snapped_angle),  cos(snapped_angle))
    );

    // Define the center of the sprite in UV space
    vec2 center = vec2(0.5, 0.5);

    // Rotate UV coordinates around the center
    vec2 transformed_uv = rotation_matrix * (uv - center) + center;

    // Snap the rotated UV coordinates to the nearest pixel center
    vec2 snapped_uv = floor(transformed_uv * texture_size) / texture_size;

    // Sample the texture using the snapped UV coordinates
    COLOR = texture(TEXTURE, snapped_uv);
}

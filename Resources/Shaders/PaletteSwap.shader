shader_type canvas_item;
render_mode unshaded;

uniform sampler2D palette : hint_albedo;

uniform int total_rows = 4;
uniform int total_columns = 4;
uniform int color_row = 1;

void fragment()
{
    vec4 old_color = texture(TEXTURE, UV);

    // Snap red value to nearest column center
    float col_index = floor(old_color.r * float(total_columns));
    float x_coord = (col_index + 0.5) / float(total_columns);

    // Y coordinate for grayscale row (usually row 0)
    float y_grayscale = (0.0 + 0.5) / float(total_rows);
    vec4 gray_sample = texture(palette, vec2(x_coord, y_grayscale));

    // Y coordinate for desired color row
    float y_color = (float(color_row) + 0.5) / float(total_rows);
    vec4 color_sample = texture(palette, vec2(x_coord, y_color));

    // Replace color if it matches gray (within threshold)
    if (distance(old_color.rgb, gray_sample.rgb) < 0.001) {
        color_sample.a *= old_color.a;
        COLOR = color_sample;
    } else {
        COLOR = old_color;
    }
}

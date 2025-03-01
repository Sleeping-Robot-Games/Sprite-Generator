shader_type canvas_item;
render_mode unshaded;

uniform sampler2D palette : hint_albedo;

uniform int total_rows = 4;
uniform int color_row = 1; 

void fragment()
{
    vec4 old_color = texture(TEXTURE, UV);

    float y_grayscale = (0.0 + 0.5) / float(total_rows);
    vec4 gray_sample   = texture(palette, vec2(old_color.r, y_grayscale));
    
    float y_color      = (float(color_row) + 0.5) / float(total_rows);
    vec4 color_sample  = texture(palette, vec2(old_color.r, y_color));
    
    if (old_color == gray_sample)
    {
        color_sample.a *= old_color.a;
        COLOR = color_sample;
    }
    else
    {
        COLOR = old_color;
    }
}

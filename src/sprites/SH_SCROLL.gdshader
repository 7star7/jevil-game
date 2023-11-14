shader_type canvas_item;

uniform vec2 moving = vec2(1.0, 1.0);
uniform float speed = 1.0;
uniform float time_by = 1.0;

void fragment()
{
	COLOR = texture(TEXTURE, UV + (moving * (TIME * time_by) * speed));
}
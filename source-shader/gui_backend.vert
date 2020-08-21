$input a_position, a_texcoord0, a_color0
$output v_texcoord0, v_color0

#include "shared/common.sh"

void main()
{
    v_texcoord0 = a_texcoord0;
    v_color0 = a_color0;
    vec2 test = a_position.xy;
    test.x /= 900;
    test.y /= 600;
    gl_Position = vec4(test, 0.0, 1.0);
}
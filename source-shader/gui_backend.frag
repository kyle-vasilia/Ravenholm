$input v_texcoord0, v_color0

#include "shared/common.sh"

SAMPLER2D(uiTex, 0);

void main()
{
    gl_FragColor = v_color0 * texture2D(uiTex, v_texcoord0);
}
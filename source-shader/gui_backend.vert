$input pos, texCoord, color
$output outTex, outColor

#include "shared/common.sh"

void main() {
    outTex = texCoord;
    outColor = color;
    gl_Position = mul(u_viewProj, vec4(pos.xy, 0.0, 1.0));
}
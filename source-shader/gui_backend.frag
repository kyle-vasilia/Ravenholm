$input outColor, outTex

#include "shared/common.sh"

SAMPLER2D(uiTex, 0);

void main() {
    gl_FragColor = outColor * texture2D(uiTex, outTex);
}
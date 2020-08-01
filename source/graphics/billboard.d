module graphics.billboard;

import graphics.format : PosTexVertex;
import gfm.math : vec2i;

struct Billboard {
    vec2i pos;
    string tex;
}
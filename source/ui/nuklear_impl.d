module ui.nuklear_impl;

import bindbc.bgfx;
import bindbc.sdl;

import main_core : Core;
import graphics.format : XYRGBAUVVertex;

import bindbc.nuklear;


struct UICore {
    nk_buffer buffer;
    
    bgfx_program_handle_t program;
}


void uiInit(ref Core core, ref UICore uiCore) {
    nk_buffer_init_default(&uiCore.buffer);

} 

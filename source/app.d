import std.stdio;

import bindbc.bgfx;
import bindbc.sdl;
import util.core;

static ushort width = 900;
static ushort height = 600;

void main() {
    loadExternalLibraries();

    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window *win = SDL_CreateWindow("Title", 
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            width, height, SDL_WINDOW_SHOWN);
    
    loadOntoWindow(win);

     scope(exit) {
        bgfx_shutdown();
        SDL_DestroyWindow(win);
        SDL_Quit();
    }


    bgfx_reset(900, 600, BGFX_RESET_VSYNC,
        bgfx_texture_format_t.BGFX_TEXTURE_FORMAT_RGBA32U);
    bgfx_set_view_clear(0, BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH,
        0x303030ff, 1.0f, 0);
    bgfx_set_view_rect(0,0,0,width,height);
    bgfx_touch(0);

    
    bool running = true;
    SDL_Event e;
    while(running) {
        while(SDL_PollEvent(&e)) {
            if(e.type == SDL_QUIT) running = false;
        }
        bgfx_touch(0);
        bgfx_frame(false);
    }




    
}

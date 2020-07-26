import std.stdio;

import bindbc.bgfx;
import bindbc.sdl;

import graphics.util;
import graphics.format;

static ushort width = 900;
static ushort height = 600;


static immutable PosColorVertex[] quad = [
    {   0.5f,  0.5f, 0.0f,  rgba : 0xff0000ff},
    {   0.5f, -0.5f, 0.0f,  rgba : 0xff0000ff},
    {  -0.5f, -0.5f, 0.0f,  rgba : 0xff0000ff},
    {  -0.5f,  0.5f, 0.0f,  rgba : 0xff0000ff}
];


static const Uint16[] index = [
    0, 1, 3,  
    1, 2, 3
];

void main() {
    loadExternalLibraries();

    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window *win = SDL_CreateWindow("Title", 
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            width, height, SDL_WINDOW_SHOWN);
    
    loadOntoWindow(win);

   

    formatVertices();
    
    bgfx_vertex_buffer_handle_t vbo = bgfx_create_vertex_buffer(
        bgfx_make_ref(quad.ptr, quad.length * PosColorVertex.sizeof),
        &PosColorVertex.format,
        0
    );

    bgfx_index_buffer_handle_t ibo = bgfx_create_index_buffer(
        bgfx_make_ref(index.ptr, index.sizeof),
        0
    );
    
    bgfx_shader_handle_t vs = loadShader("basic_vert.bin");
    bgfx_shader_handle_t fs = loadShader("basic_frag.bin");
    
    bgfx_program_handle_t program = bgfx_create_program(vs, fs, true);





    scope(exit) {
        bgfx_destroy_vertex_buffer(vbo);
        bgfx_destroy_index_buffer(ibo);
        bgfx_destroy_program(program);

        bgfx_shutdown();
        SDL_DestroyWindow(win);
        SDL_Quit();
    }
    

    refreshWindow(win);
    
    bool running = true;
    SDL_Event e;
    while(running) {
        while(SDL_PollEvent(&e)) {
            if(e.type == SDL_QUIT) running = false;
        }
        bgfx_touch(0);

        bgfx_set_vertex_buffer(0, vbo, 0, 4);
        bgfx_set_index_buffer(ibo, 0, 6);

        ulong state = 0 
            | BGFX_STATE_WRITE_R 
            | BGFX_STATE_WRITE_G
            | BGFX_STATE_WRITE_B 
            | BGFX_STATE_WRITE_A;
        bgfx_set_state(state, 0);
        bgfx_submit(0, program, 0, 0);
        bgfx_frame(false);
    }




    
}

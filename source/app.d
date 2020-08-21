import std.stdio;

import bindbc.bgfx;
import bindbc.sdl;
import gfm.math;
import graphics.util;
import graphics.format;

static ushort width = 900;
static ushort height = 600;



void main() {
    import kosu.core.context : Context, preload;

    preload();
    Context ctx = new Context();
    
    ctx.open();
    ctx.load();
}

void main2() {
    loadExternalLibraries();

    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window *win = SDL_CreateWindow("Title", 
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            width, height, SDL_WINDOW_SHOWN);
    
    loadOntoWindow(win);

    

    formatVertices();
    


    bgfx_program_handle_t program;
    bgfx_program_handle_t billboardProgram;
    {
        bgfx_shader_handle_t vs1 = loadShader("basic_tex_vert.bin");
        bgfx_shader_handle_t fs1 = loadShader("basic_tex_frag.bin");
        program = bgfx_create_program(vs1, fs1, true);
    }    {
        bgfx_shader_handle_t vs2 = loadShader("basic_tex_billboard_vert.bin");
        bgfx_shader_handle_t fs2 = loadShader("basic_tex_billboard_frag.bin");
        billboardProgram = bgfx_create_program(vs2, fs2, true);
    }


    import graphics.chunk : Chunk, tileSize;
    Chunk chunk = new Chunk;
    chunk.genBuffer();
   // chunk.centerPosHandle = bgfx_create_uniform("u_billboardCenter",
    //        bgfx_uniform_type_t.BGFX_UNIFORM_TYPE_VEC4,
    //        4096);

    auto tex = loadTexture("assets/images/land.png");


    auto texUniform = bgfx_create_uniform("s_texColor", bgfx_uniform_type_t.BGFX_UNIFORM_TYPE_SAMPLER, 1);

    scope(exit) {
        bgfx_destroy_texture(tex);
        
        bgfx_destroy_program(billboardProgram);
        bgfx_destroy_program(program);

        bgfx_shutdown();
        SDL_DestroyWindow(win);
        SDL_Quit();
    }
    

    refreshWindow(win);
    
    

    import ui.nuklear_impl;
    nk_bgfx t;
    nk_bgfx_init(t);


    import asset.loader;
    parseDirInfo("assets/loader");


    
    bool running = true;
    SDL_Event e;

    import std.math;

    float a = 0.0f;

    while(running) {
        while(SDL_PollEvent(&e)) {
            if(e.type == SDL_QUIT) running = false;
        }
       
        import std.stdio;
        a += 0.040f;
        /*mat4x4f view = mat4f.lookAt(vec3f(32.0f + cos(a) * 10, 4.0f, 32.0f + sin(a) * 10), 
                    vec3f(32.0f, 0.0f, 32.0f), 
                    vec3f(0.0f, 1.0f, 0.0f)).transposed();
        mat4x4f perspective = mat4x4f.perspective(radians!float(70.0f), 
            cast(float)width/cast(float)height, 0.1f, 100.0f).transposed();
    
        bgfx_set_view_transform(0, view.ptr, perspective.ptr);
        */
        bgfx_touch(0);


        import bindbc.nuklear;
    import std.string:toStringz;

        if(nk_begin(&t.ctx, "Test", nk_rect(50, 50, 200, 200),
            NK_WINDOW_MOVABLE|NK_WINDOW_BORDER)) {

            nk_label(&t.ctx, "Hello World".toStringz, NK_TEXT_CENTERED);
            nk_layout_row_dynamic(&t.ctx, 135, 20);
        }
        nk_end(&t.ctx);


        nk_bgfx_render(t, vec2i(900, 600));


       

        /*bgfx_set_texture(0, texUniform, tex, BGFX_SAMPLER_NONE | BGFX_TEXTURE_NONE);
        bgfx_set_state(BGFX_STATE_WRITE_R
				| BGFX_STATE_WRITE_G
				| BGFX_STATE_WRITE_B
				| BGFX_STATE_WRITE_A
				| BGFX_STATE_WRITE_Z
				| BGFX_STATE_DEPTH_TEST_LESS
                | BGFX_STATE_CULL_CCW
				| BGFX_STATE_MSAA, 0);

        chunk.draw(program, billboardProgram);
        */

        bgfx_frame(false);
    }




    
}

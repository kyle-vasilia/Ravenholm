import std.stdio;

import bindbc.bgfx;
import bindbc.sdl;
import gfm.math;
import graphics.util;
import graphics.format;

static ushort width = 900;
static ushort height = 600;


static PosTexVertex[8] cube =
[
    {-1.0f,  1.0f,  1.0f, 0.0f, 0.0f },
    {1.0f,  1.0f,  1.0f, 1.0f, 0.0f },
    {-1.0f, -1.0f,  1.0f, 1.0f, 1.0f },
    {1.0f, -1.0f,  1.0f, 0.0f, 10.0f },
    {-1.0f,  1.0f, -1.0f,  0.0f, 0.0f},
    {1.0f,  1.0f, -1.0f,  1.0f, 0.0f },
    {-1.0f, -1.0f, -1.0f,  1.0f, 1.0f },
    {1.0f, -1.0f, -1.0f,  0.0f, 1.0f },
];

static ushort[36] index =
[
    0, 1, 2, // 0
    1, 3, 2,
    4, 6, 5, // 2
    5, 6, 7,
    0, 2, 4, // 4
    4, 2, 6,
    1, 5, 3, // 6
    5, 7, 3,
    0, 4, 1, // 8
    4, 5, 1,
    2, 3, 6, // 10
    6, 3, 7,
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
        bgfx_make_ref(cube.ptr, cube.length * PosTexVertex.sizeof),
        &PosTexVertex.format,
        0
    );

    bgfx_index_buffer_handle_t ibo = bgfx_create_index_buffer(
        bgfx_make_ref(index.ptr, ushort.sizeof * 36),
        0
    );
    
    bgfx_shader_handle_t vs = loadShader("basic_tex_vert.bin");
    bgfx_shader_handle_t fs = loadShader("basic_tex_frag.bin");
    
    bgfx_program_handle_t program = bgfx_create_program(vs, fs, true);

    auto tex = loadTexture("assets/images/land.png");

    auto texUniform = bgfx_create_uniform("s_texColor", bgfx_uniform_type_t.BGFX_UNIFORM_TYPE_SAMPLER, 1);

    scope(exit) {
        bgfx_destroy_texture(tex);
        
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

    import std.math;

    float a = 0.0f;

    while(running) {
        while(SDL_PollEvent(&e)) {
            if(e.type == SDL_QUIT) running = false;
        }

        import std.stdio;
        a += 0.016f;
        mat4x4f view = mat4f.lookAt(vec3f(cos(a) * 10, 4.0f, sin(a) * 10), 
                    vec3f(0.0f, 0.0f, 0.0f), 
                    vec3f(0.0f, 1.0f, 0.0f)).transposed();
        mat4x4f perspective = mat4x4f.perspective(radians!float(70.0f), 
            cast(float)width/cast(float)height, 0.1f, 100.0f).transposed();
        
        bgfx_set_view_transform(0, view.ptr, perspective.ptr);

        bgfx_touch(0);

        bgfx_set_vertex_buffer(0, vbo, 0, 8);
        bgfx_set_index_buffer(ibo, 0, 36);

        bgfx_set_texture(0, texUniform, tex, BGFX_SAMPLER_NONE | BGFX_TEXTURE_NONE);

   
        bgfx_set_state(BGFX_STATE_WRITE_R
				| BGFX_STATE_WRITE_G
				| BGFX_STATE_WRITE_B
				| BGFX_STATE_WRITE_A
				| BGFX_STATE_WRITE_Z
				| BGFX_STATE_DEPTH_TEST_LESS
				| BGFX_STATE_CULL_CCW
				| BGFX_STATE_MSAA, 0);



        bgfx_submit(0, program, 0, 36);
        bgfx_frame(false);
    }




    
}

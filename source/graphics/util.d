module graphics.util;

import bindbc.bgfx;
import bindbc.sdl;
import core.stdc.stdio;

void loadExternalLibraries() {
    import std.exception : enforce;
    enforce(loadSDL() == sdlSupport, "[ERR::DLL] Couldn't load SDL2");
    enforce(loadBgfx(), "[ERR::DLL] Couldn't load BGFX");
}

void loadOntoWindow(SDL_Window *win) {
    SDL_SysWMinfo wInfo;
    SDL_VERSION(&wInfo.version_);
    SDL_GetWindowWMInfo(win, &wInfo);
    
    bgfx_platform_data_t pd;

    version(Windows) {
        pd.ndt = null;
        pd.nwh = wInfo.info.win.window;
    }
    version(linux) {
        pd.ndt = wInfo.info.x11.display;
        pd.nwh = cast(uint*)wInfo.info.x11.window;
    }
    pd.context = null;
    pd.backBuffer = null;
    pd.backBufferDS = null;

    bgfx_set_platform_data(&pd);
    
    bgfx_init_t init;

    SDL_GetWindowSize(win, 
        cast(int*)&init.resolution.width, 
        cast(int*)&init.resolution.height);

    init.type = bgfx_renderer_type_t.BGFX_RENDERER_TYPE_OPENGL;
    init.vendorId = BGFX_PCI_ID_NONE;
    init.resolution.reset = BGFX_RESET_VSYNC;
    bgfx_init(&init);

}



bgfx_shader_handle_t loadShader(string name) {
    import std.string : toStringz;

    string fullPath = "shader/";
    version(Windows) {
        fullPath ~= "Windows/";
    }
    version(linux) {
        fullPath ~= "Linux/";
    }
    fullPath ~= name;
    
   
    //Use C-Style File I/O - issue with loading binary data with regular.
    FILE *file = fopen(toStringz(fullPath), "rb");
    
    scope(exit) fclose(file);
    fseek(file, 0, SEEK_END);

    const auto size = ftell(file);
 
    fseek(file, 0, SEEK_SET);

    ubyte[] data = new ubyte[size+1];
    
    fread(&data[0], size, 1, file);
    data[size] = '\0'; //Null-terminate it
   
    const bgfx_memory_t *mem = bgfx_copy(&data[0],cast(uint)data.length);
   
    bgfx_shader_handle_t handle = bgfx_create_shader(mem);
    bgfx_set_shader_name(handle, toStringz(name), cast(int)name.length);
    return handle;
} 

bgfx_texture_handle_t loadTexture(string name) {
    import imageformats : IFImage, read_image, ColFmt;

    IFImage img = read_image(name, ColFmt.RGB);

    const bgfx_memory_t *mem = bgfx_make_ref(img.pixels.ptr, img.pixels.sizeof);
    
    return bgfx_texture_handle_t();



}

void refreshWindow(SDL_Window *win) {
    
    int x;
    int y;

    SDL_GetWindowSize(win, &x, &y);

    bgfx_reset(900, 600, BGFX_RESET_VSYNC,
        bgfx_texture_format_t.BGFX_TEXTURE_FORMAT_RGBA32U);
    bgfx_set_view_clear(0, BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH,
        0x303030ff, 1.0f, 0);
    bgfx_set_view_rect(0,0,0, cast(ushort)x, cast(ushort)y);
    bgfx_touch(0);

}
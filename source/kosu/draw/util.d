module kosu.draw.util;

import bindbc.bgfx;
import bindbc.sdl;
import bindbc.nuklear;
import core.stdc.stdio;

import kosu.core.types : RenderState;


void setRenderState(ref RenderState state) {
    bgfx_set_view_transform(0, null, state.proj.ptr);
    bgfx_set_state(state.state, 0);
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
    import std.string : toStringz;
    import imageformats : IFImage, read_image, ColFmt;
    
    IFImage img = read_image(name, ColFmt.RGB);

    const bgfx_memory_t *mem = bgfx_make_ref(img.pixels.ptr, img.w * img.h * 3);

    bgfx_texture_handle_t handle = 
        bgfx_create_texture_2d(cast(ushort)img.w, cast(ushort)img.h, false, 1, 
        bgfx_texture_format_t.BGFX_TEXTURE_FORMAT_RGB8, BGFX_SAMPLER_NONE | BGFX_TEXTURE_NONE, mem);

    bgfx_set_texture_name(handle, toStringz(name), cast(int)name.length);
    return handle;
    
}
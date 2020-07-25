module util.graphics;

import bindbc.bgfx;
import core.stdc.stdio;

bgfx_shader_handle_t loadShader(string name) {
    import std.string : toStringz;

    string fullPath = "assets/shader/";
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

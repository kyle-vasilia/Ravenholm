module util.core;
import bindbc.sdl;
import bindbc.bgfx;

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

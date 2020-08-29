module kosu.core.context;
import bindbc.sdl;
import bindbc.bgfx;
import bindbc.nuklear;

import kosu.core.types : Vector2u;
import kosu.event.manager;
/*
    loads DLL, formats important stuff. 
*/
bool preload() {
    import std.exception : enforce;
    import kosu.core.types : formatVertices;

    enforce(loadSDL() == sdlSupport, "[ERR::DLL] Couldn't load SDL2");
    enforce(loadBgfx(), "[ERR::DLL] Couldn't load BGFX");
    enforce(loadNuklear() == NuklearSupport.Nuklear4, "[ERR::DLL] Couldn't load Nuklear");

    formatVertices();

    return true;
}

class Context {
public:
    EventManager eventMgr = new EventManager;
    SDL_Window *winHandle = null; 
    
    void delegate()[] drawList;
private:
    bool running_ = false;

public:
    this() {
        SDL_Init(SDL_INIT_VIDEO);
        
    }
    ~this() {
        bgfx_shutdown();
        SDL_DestroyWindow(winHandle);
        SDL_Quit();
    }


    void open() {
        winHandle = SDL_CreateWindow("Title",
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
            900, 600, 
            SDL_WINDOW_SHOWN);

        this.running = true;
    }

    void load() {
        SDL_SysWMinfo wInfo;
        SDL_VERSION(&wInfo.version_);
        SDL_GetWindowWMInfo(winHandle, &wInfo);
        
        bgfx_platform_data_t pd;

        version(Windows) {
            pd.ndt = null;
            pd.nwh = wInfo.info.win.window;
        }
        version(linux) {
            pd.ndt = wInfo.info.x11.display;
            pd.nwh = cast(uint*)wInfo.info.x11.window;
        }

        bgfx_set_platform_data(&pd);
        bgfx_init_t initData;

        auto size = winSize();
        initData.resolution.width = size.x;
        initData.resolution.height = size.y;

        initData.type = bgfx_renderer_type_t.BGFX_RENDERER_TYPE_OPENGL;
        initData.vendorId = BGFX_PCI_ID_NONE;
        initData.resolution.reset = BGFX_RESET_VSYNC;
        initData.limits.transientVbSize = 65_533 * 32;
        initData.limits.transientIbSize = 65_533 * 32 * 4;
        bgfx_init(&initData);
        refresh();
    }

    void refresh() {
        auto size = this.winSize();
        bgfx_reset(size.x, size.y, BGFX_RESET_VSYNC,
            bgfx_texture_format_t.BGFX_TEXTURE_FORMAT_RGBA32U);
        bgfx_set_view_clear(0, BGFX_CLEAR_COLOR | BGFX_CLEAR_DEPTH,
            0x303030ff, 1.0f, 0);
        bgfx_set_view_rect(0, 0, 0, size.x, size.y);
        bgfx_touch(0);
    }

    void doEvent(ref const(SDL_Event) e) {
        if(!(e.type in eventMgr.registry)) return;
        foreach(fn; eventMgr.registry[e.type]) {
            const(bool) res = fn(e);
            if(res) continue;

            running = false;
        }
    }

    void doUpdate(float dt) {

    }

    void doDraw() {
        foreach(fn; drawList) {
            fn();
        }
        bgfx_touch(0);
        bgfx_frame(false);
    }

    void run() {
        do {
            SDL_Event e;
            while(SDL_PollEvent(&e)) {
                doEvent(e);
            }
            doUpdate(1.0f/60.0f);
            doDraw();
        } while(running);
    }

    final @property Vector2u winSize() {
        int x, y;
        SDL_GetWindowSize(winHandle, &x, &y);
        Vector2u size = Vector2u(cast(ushort)x, cast(ushort)y);
        return size;
    }

    final @property void winSize(Vector2u size) {
        SDL_SetWindowSize(winHandle, size.x, size.y);
        refresh();
    }

    final @property void winSize(ushort x, ushort y) {
        winSize(Vector2u(x, y));
    }

    final @property bool running() {
        return running_;
    }
    final @property void running(bool v) {
        running_ = v;
    }



};
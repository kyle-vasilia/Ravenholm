module kosu.core.types;
import gfm.math : Vector;
import bindbc.bgfx;

alias Vector2u = Vector!(ushort, 2);
alias Vector2f = Vector!(float, 2);
alias Vector3f = Vector!(float, 3);
alias Color = Vector!(ubyte, 4);

alias Format = bgfx_vertex_layout_t;

/*
    c - color
    t - texCoord
    n - normal
    ex:
        Vertex_nt = Vertex, Normal, Texcoord
*/
struct Vertex_c {
    Vector3f pos;
    Color color;

    static Format format;
}

struct Vertex_t {
    Vector3f pos;
    Vector2f uv;

    static Format format;
}

struct Vertex_nc {
    Vector3f pos;
    Color color;
    Vector3f normal;

    static Format format;
}

struct Vertex_nt {
    Vector3f pos;
    Vector3f normal;
    Vector2f uv; 

    static Format format;
}

void formatVertices() {
    /*
        Why do this? Well, automates it much better upholds DRY principles.
        Easier to just spam copy paste all of these vertex declarations but 
        let's just follow patterns, eh? ;)
    */
    void begin(Format*[] formats) {
        foreach(Format* ptr; formats) {
            bgfx_vertex_layout_begin(ptr,
                bgfx_renderer_type_t.BGFX_RENDERER_TYPE_NOOP);
        }
    }
    void add(Format*[] formats,
        bgfx_attrib_t loc, 
        byte num, 
        bgfx_attrib_type_t type,
        bool normalized = false) {
            
        foreach(Format* ptr; formats) {
            bgfx_vertex_layout_add(ptr,
                loc, num, type, normalized, normalized
            );
        }
    }
    void end(Format*[] formats) {
        foreach(Format* ptr; formats) {
            bgfx_vertex_layout_end(ptr);
        }
    }

    Format*[] vertexFormats = [
        &Vertex_c.format, 
        &Vertex_t.format,
        &Vertex_nc.format,
        &Vertex_nt.format
    ];

    begin(vertexFormats);
    add(vertexFormats, bgfx_attrib_t.BGFX_ATTRIB_POSITION, 3, 
        bgfx_attrib_type_t.BGFX_ATTRIB_TYPE_FLOAT);
    add([&Vertex_nc.format, &Vertex_nt.format], 
        bgfx_attrib_t.BGFX_ATTRIB_NORMAL, 3, 
        bgfx_attrib_type_t.BGFX_ATTRIB_TYPE_FLOAT);
    add([&Vertex_nc.format, &Vertex_c.format],
        bgfx_attrib_t.BGFX_ATTRIB_COLOR0, 4,
        bgfx_attrib_type_t.BGFX_ATTRIB_TYPE_UINT8, true);
    add([&Vertex_t.format, &Vertex_nt.format], 
        bgfx_attrib_t.BGFX_ATTRIB_TEXCOORD0, 2,
        bgfx_attrib_type_t.BGFX_ATTRIB_TYPE_FLOAT, false);
    end(vertexFormats);
}
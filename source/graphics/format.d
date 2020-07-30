module graphics.format;
import bindbc.bgfx;


struct PosColorVertex {
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    uint rgba = 0x00000000f; 
    static bgfx_vertex_layout_t format;
} 

struct PosTexVertex {
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float texCoord_x = 0.0f;
    float texCoord_y = 0.0f;
    static bgfx_vertex_layout_t format;
} 


void formatVertices() {
    bgfx_vertex_layout_begin(&PosColorVertex.format, 
        bgfx_renderer_type_t.BGFX_RENDERER_TYPE_NOOP);
    bgfx_vertex_layout_add(&PosColorVertex.format,
        bgfx_attrib_t.BGFX_ATTRIB_POSITION,
        3, bgfx_attrib_type_t.BGFX_ATTRIB_TYPE_FLOAT, 
        false, false);
    bgfx_vertex_layout_add(&PosColorVertex.format,
        bgfx_attrib_t.BGFX_ATTRIB_COLOR0,
        4, bgfx_attrib_type_t.BGFX_ATTRIB_TYPE_UINT8, 
        true, true);
    bgfx_vertex_layout_end(&PosColorVertex.format);
    
    bgfx_vertex_layout_begin(&PosTexVertex.format, 
        bgfx_renderer_type_t.BGFX_RENDERER_TYPE_NOOP);
    bgfx_vertex_layout_add(&PosTexVertex.format,
        bgfx_attrib_t.BGFX_ATTRIB_POSITION,
        3, bgfx_attrib_type_t.BGFX_ATTRIB_TYPE_FLOAT, 
        false, false);
    bgfx_vertex_layout_add(&PosTexVertex.format,
        bgfx_attrib_t.BGFX_ATTRIB_TEXCOORD0,
        2, bgfx_attrib_type_t.BGFX_ATTRIB_TYPE_FLOAT, 
        false, false);
    bgfx_vertex_layout_end(&PosTexVertex.format);
}
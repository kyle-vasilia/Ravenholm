module kosu.draw.nuklear_impl;

import bindbc.bgfx;
import bindbc.nuklear;

import kosu.core.types;
import kosu.draw.util;

struct nk_bgfx {
    nk_context ctx;
    nk_font_atlas atlas;
    nk_font *font = null;
    nk_buffer cmds;
    nk_draw_null_texture nullTex;
    bgfx_texture_handle_t texture;
    bgfx_program_handle_t shader;
    bgfx_uniform_handle_t texHandle;
}

void nk_bgfx_init(ref nk_bgfx nkb) {

    
    
    nk_init_default(&nkb.ctx, null);
    nk_buffer_init_default(&nkb.cmds);
   
    
    nkb.texHandle = bgfx_create_uniform("uiTex", 
        bgfx_uniform_type_t.BGFX_UNIFORM_TYPE_SAMPLER, 1);
    nk_font_atlas_init_default(&nkb.atlas);
    nk_font_atlas_begin(&nkb.atlas);

    nk_font_config cfg;
    cfg.oversample_h = 3;
    cfg.oversample_v = 2;
    
    import std.string : toStringz;
    import core.stdc.string : memcpy;
    nkb.font = nk_font_atlas_add_from_file(&nkb.atlas,
        "assets/fonts/basic.ttf".toStringz, 18, &cfg);
    int w;
    int h;
    const void *data = nk_font_atlas_bake(&nkb.atlas, &w, &h, NK_FONT_ATLAS_RGBA32);
    uint dataSize = w * h * 4;

    const bgfx_memory_t *mem = bgfx_alloc(dataSize);
    memcpy(cast(void*)mem.data, cast(void*)data, dataSize);
    ushort w2; ushort h2;
    w2 = cast(ushort)w;
    h2 = cast(ushort)h;
    nkb.texture = bgfx_create_texture_2d(w2, h2, false, 
        1, bgfx_texture_format_t.BGFX_TEXTURE_FORMAT_RGBA8, 0, mem);

    nk_font_atlas_end(&nkb.atlas, nk_handle_id(nkb.texture.idx), &nkb.nullTex);
    nk_style_set_font(&nkb.ctx, &nkb.font.handle);

    nkb.shader = bgfx_create_program(
        loadShader("gui_backend_vert.bin"),
        loadShader("gui_backend_frag.bin"),
        true);
    
}

void nk_bgfx_destroy(ref nk_bgfx nkb) {
    nk_font_atlas_clear(&nkb.atlas);
    nk_free(&nkb.ctx);
    nk_buffer_free(&nkb.cmds);

    bgfx_destroy_texture(nkb.texture);
    bgfx_destroy_program(nkb.shader);
    
}

void nk_bgfx_render(ref nk_bgfx nkb, Vector2u size) {
    const bgfx_caps_t *caps = bgfx_get_caps();

  
    bgfx_set_view_rect(0, 0, 0, 900, 600);
    nk_buffer vbuf, ebuf;

    nk_convert_config config;
    const nk_draw_vertex_layout_element[] layout = [
        {NK_VERTEX_POSITION, NK_FORMAT_FLOAT, Point_ct.pos.offsetof},
        {NK_VERTEX_COLOR, NK_FORMAT_R8G8B8A8, Point_ct.color.offsetof},
        {NK_VERTEX_TEXCOORD, NK_FORMAT_FLOAT, Point_ct.uv.offsetof},
        NK_VERTEX_LAYOUT_END
    ];
    config.vertex_layout = layout.ptr;
    config.vertex_size = Point_ct.sizeof;
    config.vertex_alignment = Point_ct.alignof;
    config.null_ = nkb.nullTex;
    config.circle_segment_count = 22;
	config.curve_segment_count = 22;
	config.arc_segment_count = 22;
	config.global_alpha = 1.0f;
	config.shape_AA = NK_ANTI_ALIASING_OFF;
	config.line_AA = NK_ANTI_ALIASING_OFF;
    
    immutable int MAX_VERTEX_COUNT = 65536;
    immutable int MAX_VERTEX_MEMORY = 
        MAX_VERTEX_COUNT * Point_ct.sizeof;
    immutable int MAX_ELEMENT_COUNT = MAX_VERTEX_COUNT * 2;
    immutable int MAX_ELEMENT_MEMORY = MAX_ELEMENT_COUNT * ushort.sizeof;

    bgfx_transient_vertex_buffer_t tvb;
    bgfx_transient_index_buffer_t tib;

    bgfx_alloc_transient_vertex_buffer(&tvb, MAX_VERTEX_COUNT, &Point_ct.format);
    bgfx_alloc_transient_index_buffer(&tib, MAX_ELEMENT_COUNT);


    void *element = cast(void*)new ubyte[MAX_ELEMENT_COUNT * uint.sizeof];

    nk_buffer_init_fixed(&vbuf, tvb.data, cast(nk_size)MAX_VERTEX_MEMORY);
    nk_buffer_init_fixed(&ebuf, element, cast(nk_size)(MAX_ELEMENT_COUNT * uint.sizeof));
    
    import std.conv : to;
    import core.stdc.string : memset;

    nk_convert(&nkb.ctx, &nkb.cmds, &vbuf, &ebuf, &config);
    uint[] slice = (cast(uint*)ebuf.memory.ptr)[0..MAX_ELEMENT_COUNT];
    
    memset(tib.data, 0, tib.size);
    ushort[] rawData = (cast(ushort*)tib.data)[0..MAX_ELEMENT_COUNT];
    rawData[0..MAX_ELEMENT_COUNT] = to!(ushort[])(slice);

    /*
    32-bit buffer to 16-bit?!
    */

    uint offset = 0;

    bgfx_set_texture(0, nkb.texHandle, nkb.texture, 0);
    nk_draw_foreach(&nkb.ctx, &nkb.cmds, cast(nk_draw_command_delegate)
        (const nk_draw_command *cmd){
            
			//| BGFX_STATE_MSAA
        import std.algorithm:max;
        const ushort xx = cast(ushort)(max(cmd.clip_rect.x, 0.0f));
		const ushort yy = cast(ushort)(max(cmd.clip_rect.y, 0.0f));
		const ushort cw = cast(ushort)(max(cmd.clip_rect.w, 0.0f));
		const ushort ch = cast(ushort)(max(cmd.clip_rect.h, 0.0f));
		bgfx_set_scissor(xx, yy, cw, ch);

   
        bgfx_set_transient_vertex_buffer(cast(byte)0, &tvb, cast(uint)0, cast(uint)MAX_VERTEX_COUNT);
        bgfx_set_transient_index_buffer(&tib, offset, cmd.elem_count);
        
        bgfx_submit(0, nkb.shader, 0, cast(byte)BGFX_DISCARD_ALL);
        offset += cmd.elem_count;
    
    });

    nk_buffer_clear(&nkb.cmds);
	nk_clear(&nkb.ctx);
} 
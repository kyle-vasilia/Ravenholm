module graphics.batch;


import bindbc.bgfx;
import graphics.format;
import graphics.tile : Tile;
import graphics.wall : Wall;
import graphics.billboard : Billboard;

struct Batch(T) {

    T[] cpuVertexData;
    ushort[] cpuIndexData;

    bgfx_vertex_buffer_handle_t gpuVertexData;
    bgfx_index_buffer_handle_t gpuIndexData;

    int numQuads = 0;
    
    void gen() {
        gpuVertexData = bgfx_create_vertex_buffer(
            bgfx_make_ref(cpuVertexData.ptr, cast(uint)((numQuads * 4) * T.sizeof)),
            &T.format, 0
        );

        gpuIndexData = bgfx_create_index_buffer(
            bgfx_make_ref(cpuIndexData.ptr, cast(uint)((numQuads * 6) * ushort.sizeof)),
            0
        );

    }


} 

void add(ref Batch!PosTexVertex batch, const ref Tile tile) {
    const int iV = batch.numQuads * 4;
        batch.cpuVertexData ~= [
            PosTexVertex(tile.pos.x + 0, 0, tile.pos.y + 0,     0, 0),
            PosTexVertex(tile.pos.x + 1, 0, tile.pos.y + 0,     0.5, 0),
            PosTexVertex(tile.pos.x + 1, 0, tile.pos.y + 1,     0.5, 1),
            PosTexVertex(tile.pos.x + 0, 0, tile.pos.y + 1,     0, 1)
        ];

        batch.cpuIndexData ~= cast(ushort[])[
            iV + 0, iV + 1, iV + 2, 
            iV + 0, iV + 2, iV + 3
        ];

        batch.numQuads++;
    
}

void add(ref Batch!PosTexVertex batch, const ref Wall wall) {
    const int iV = batch.numQuads * 4;
    batch.cpuVertexData ~= [
        PosTexVertex(wall.pos.x + 0, 1, wall.pos.y + 0,     0.5, 0),
        PosTexVertex(wall.pos.x + 1, 1, wall.pos.y + 0,     1.0, 0),
        PosTexVertex(wall.pos.x + 1, 1, wall.pos.y + 1,     1.0, 1),
        PosTexVertex(wall.pos.x + 0, 1, wall.pos.y + 1,     0.5, 1),


        PosTexVertex(wall.pos.x + 0, 1, wall.pos.y + 1,     0.5, 0),
        PosTexVertex(wall.pos.x + 1, 1, wall.pos.y + 1,     1.0, 0),
        PosTexVertex(wall.pos.x + 1, 0, wall.pos.y + 1,     1.0, 1),
        PosTexVertex(wall.pos.x + 0, 0, wall.pos.y + 1,     0.5, 1),

        PosTexVertex(wall.pos.x + 0, 0, wall.pos.y + 0,     1.0, 0),
        PosTexVertex(wall.pos.x + 1, 0, wall.pos.y + 0,     0.5, 0),
        PosTexVertex(wall.pos.x + 1, 1, wall.pos.y + 0,     0.5, 1),
        PosTexVertex(wall.pos.x + 0, 1, wall.pos.y + 0,     1.0, 1),

        PosTexVertex(wall.pos.x + 1, 1, wall.pos.y + 1,     1.0, 0),
        PosTexVertex(wall.pos.x + 1, 1, wall.pos.y + 0,     0.5, 0),
        PosTexVertex(wall.pos.x + 1, 0, wall.pos.y + 0,     0.5, 1),
        PosTexVertex(wall.pos.x + 1, 0, wall.pos.y + 1,     1.0, 1),


        PosTexVertex(wall.pos.x + 0, 1, wall.pos.y + 0,     0.5, 0),
        PosTexVertex(wall.pos.x + 0, 1, wall.pos.y + 1,     1.0, 0),
        PosTexVertex(wall.pos.x + 0, 0, wall.pos.y + 1,     1.0, 1),
        PosTexVertex(wall.pos.x + 0, 0, wall.pos.y + 0,     0.5, 1),
    ];

    batch.cpuIndexData ~= cast(ushort[])[
        iV + 0, iV + 1, iV + 2, 
        iV + 0, iV + 2, iV + 3,

        iV + 4, iV + 5, iV + 6, 
        iV + 4, iV + 6, iV + 7,

        iV + 8, iV + 9, iV + 10, 
        iV + 8, iV + 10, iV + 11,

        iV + 12, iV + 13, iV + 14, 
        iV + 12, iV + 14, iV + 15,

        iV + 16, iV + 17, iV + 18, 
        iV + 16, iV + 18, iV + 19,       
    ];

    batch.numQuads += 5;
    //Bottom does not need be covered eh ;)
 }


 void add(ref Batch!PosNormalTexVertex batch, const ref Billboard billboard) {
    const int iV = batch.numQuads * 4;
    import gfm.math : vec3f;

    vec3f center = vec3f(billboard.pos.x + 0.5, 0.5, billboard.pos.y + 0.5);
    batch.cpuVertexData ~= [
        PosNormalTexVertex(billboard.pos.x + 1, 0, billboard.pos.y + 0.5, center.x, center.y, center.z, 0.0,    0.5, 0),
        PosNormalTexVertex(billboard.pos.x + 0, 0, billboard.pos.y + 0.5, center.x, center.y, center.z, 0.0,    1.0, 0),
        
        
        PosNormalTexVertex(billboard.pos.x + 0, 1, billboard.pos.y + 0.5, center.x, center.y, center.z, 0.0,    1.0, 1),
        PosNormalTexVertex(billboard.pos.x + 1, 1, billboard.pos.y + 0.5, center.x, center.y, center.z, 0.0,    0.5, 1),
    ];

    batch.cpuIndexData ~= cast(ushort[])[
        iV + 0, iV + 1, iV + 2, 
        iV + 0, iV + 2, iV + 3
        ];

    batch.numQuads++;
    
    }
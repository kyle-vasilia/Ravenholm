module graphics.chunk;
import bindbc.bgfx;
import gfm.math;

import graphics.format : PosTexVertex;
import graphics.tile;


static const int tileSize = 64;

struct Floor {
    PosTexVertex[] cpuVertexData;
    ushort[] cpuIndexData;

    bgfx_vertex_buffer_handle_t gpuVertexData;
    bgfx_index_buffer_handle_t gpuIndexData;

    int numQuads = 0;


    void addTile(Tile) {

    }

    void gen() {
        gpuVertexData = bgfx_create_vertex_buffer(
            bgfx_make_ref(cpuVertexData.ptr, cast(uint)((numQuads * 4) * PosTexVertex.sizeof)),
            &PosTexVertex.format, 0
        );

        gpuIndexData = bgfx_create_index_buffer(
            bgfx_make_ref(cpuIndexData.ptr, cast(uint)((numQuads * 6) * ushort.sizeof)),
            0
        );
    }

}
struct Wall {

}

class Chunk {
  

    this() {

    }

    void genBuffer() {

        import std.stdio : writeln;
        cpuVertexData.length = 4 * (tileSize * tileSize);
        cpuIndexData.length = 6 * (tileSize * tileSize);
        
        float texInc = 0.5f;
        bool useSecond = false;
        for(int i = 0; i < (tileSize * tileSize); i++) {
            useSecond = !useSecond;
            int iV = i * 4;
            int iI = i * 6;

            int x = i % tileSize;
            int z = i / tileSize;

            if(useSecond) texInc = 0.5f;
            else texInc = 0.0f;

            cpuVertexData[iV..iV+4] = [
                PosTexVertex(x,  0,z,   texInc + 0,  0),
                PosTexVertex(x+1,0,z,   texInc + 0.5,0),
                PosTexVertex(x+1,0,z+1, texInc + 0.5,1),
                PosTexVertex(x,  0,z+1, texInc + 0,  1)
            ];
            cpuIndexData[iI..iI+6] = cast(ushort[])[
                iV + 0, iV + 1, iV + 2,
                iV + 0, iV + 2, iV + 3
            ];
            
        }
   
     

        gpuVertexData = bgfx_create_vertex_buffer(
            bgfx_make_ref(cpuVertexData.ptr, cast(uint)((tileSize * tileSize * 4) * PosTexVertex.sizeof)),
            &PosTexVertex.format, 0
        );

        gpuIndexData = bgfx_create_index_buffer(
            bgfx_make_ref(cpuIndexData.ptr, (tileSize * tileSize * 6) * ushort.sizeof),
            0
        );



    }
    PosTexVertex[] cpuVertexData;
    ushort[] cpuIndexData;

    bgfx_vertex_buffer_handle_t gpuVertexData;
    bgfx_index_buffer_handle_t gpuIndexData;
    Tile[tileSize][tileSize] tileData;
    

}


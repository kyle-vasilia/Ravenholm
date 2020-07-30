module graphics.chunk;
import bindbc.bgfx;
import gfm.math;

import graphics.format : PosTexVertex;
import graphics.tile;


static const int tileSize = 4;



class Chunk {
  

    this() {

    }

    void genBuffer() {

        import std.stdio : writeln;
        cpuVertexData.length = 4 * (tileSize * tileSize);
        cpuIndexData.length = 6 * (tileSize * tileSize);

        for(int i = 0; i < (tileSize * tileSize); i++) {
            int iV = i * 4;
            int iI = i * 6;

            cpuVertexData[iV..iV+4] = [
                PosTexVertex(i,  0,i),
                PosTexVertex(i+1,0,i),
                PosTexVertex(i+1,0,i+1),
                PosTexVertex(i,  0,i+1)
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


module graphics.chunk;
import bindbc.bgfx;
import gfm.math;

import graphics.format;
import graphics.tile;
import graphics.wall;
import graphics.billboard;

import graphics.batch;


static const int tileSize = 64;




class Chunk {
    Batch!PosNormalTexVertex billboards;
    Batch!PosTexVertex floor; 
    Batch!PosTexVertex walls;

    vec4f[] billboardCenterPositions;
    bgfx_uniform_handle_t centerPosHandle;  
    
    this() {
  
    }

    void genBuffer() {

        import std.stdio : writeln;
        billboardCenterPositions.length = 4096;
        
        float texInc = 0.5f;
        bool useSecond = false;

        import std.random : uniform;

        for(int i = 0; i < (tileSize * tileSize); i++) {
            useSecond = !useSecond;
            int iV = i * 4;
            int iI = i * 6;

            int x = i % tileSize;
            int z = i / tileSize;

            if(useSecond) texInc = 0.5f;
            else texInc = 0.0f;

            Tile tile;
            tile.pos = vec2i(x, z);

            Wall w;
            w.pos = vec2i(x, z);

            Billboard b;
            b.pos = vec2i(x, z);

            int r = uniform(0, 50);
            if(r < 4) {
                add(floor, w);
            }
            else {
                
                add(floor, tile);
                if(r < 10) {
                    add(billboards, b);
             
                }
            }

        }
        floor.gen();
        walls.gen();
        billboards.gen();

    }
    void draw(bgfx_program_handle_t program, bgfx_program_handle_t billboardProgram) {
        
    
        
        bgfx_set_vertex_buffer(0, floor.gpuVertexData, 0, floor.numQuads * 4);
        bgfx_set_index_buffer(floor.gpuIndexData, 0, floor.numQuads * 6);
        bgfx_submit(0, program, 0, 32);


        bgfx_set_vertex_buffer(0, walls.gpuVertexData, 0, walls.numQuads * 4);
        bgfx_set_index_buffer(walls.gpuIndexData, 0, walls.numQuads * 6);
        bgfx_submit(0, program, 0, 32);
        
       // bgfx_set_uniform(centerPosHandle, billboardCenterPositions.ptr, 4096);
        

        bgfx_set_vertex_buffer(0, billboards.gpuVertexData, 0, billboards.numQuads * 4);
        bgfx_set_index_buffer(billboards.gpuIndexData, 0, billboards.numQuads * 6);
        bgfx_submit(0, billboardProgram, 0, cast(byte)BGFX_DISCARD_ALL);
    }
}

module graphics.chunk;
import bindbc.bgfx;
import gfm.math;

import graphics.format : PosTexVertex;
import graphics.tile;
import graphics.wall;

import graphics.batch;


static const int tileSize = 64;




class Chunk {
  
    
    this() {

    }

    void genBuffer() {

        import std.stdio : writeln;
      
        
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

            int r = uniform(0, 50);
            if(r < 4) {
                wall.add(w);
            }
            else {
                floor.add(tile);
            }


            
        }
        floor.gen();
        wall.gen();

    }
    void draw(bgfx_program_handle_t program) {
        bgfx_set_vertex_buffer(0, floor.gpuVertexData, 0, floor.numQuads * 4);
        bgfx_set_index_buffer(floor.gpuIndexData, 0, floor.numQuads * 6);
        bgfx_submit(0, program, 0, 32);


        bgfx_set_vertex_buffer(0, wall.gpuVertexData, 0, wall.numQuads * 4);
        bgfx_set_index_buffer(wall.gpuIndexData, 0, wall.numQuads * 6);
        bgfx_submit(0, program, 0, 32);
    }

    Batch floor; 
    Batch wall;
    

}


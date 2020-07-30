module asset.loader;
import std.file;
import std.exception;
import std.json;
import std.stdio : writeln;
void parseTextureBatch(string contents) {
    auto data = parseJSON(contents);
    
    
    foreach(JSONValue v; data.object) {
        foreach (JSONValue entry; v.array) {
            writeln(entry["name"].str);
        }
    }
}

void parseDirInfo(string dir) {
    try {
        foreach (string file; dirEntries(dir, SpanMode.breadth)) {
            parseTextureBatch(readText(file));
        }
    } catch(FileException e) {

    }

    
}
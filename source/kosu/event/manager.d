module kosu.event.manager;

import std.functional;
import bindbc.sdl : SDL_Event, SDL_EventType;

alias EventCallback = bool function(ref const(SDL_Event) e);

class EventManager {
public:
    EventCallback[][SDL_EventType] registry;
private:
public:
    EventCallback* add(SDL_EventType type, EventCallback fn) {
        registry[type] ~= fn;
        return registry[type].ptr;
    }
    
private:
}
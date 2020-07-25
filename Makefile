shaderc = shaderc
output = bin/shader
source := source-shader

vertex_sources := $(wildcard $(source)/*.vert)
fragment_sources := $(wildcard $(source)/*.frag)

vertex_output = $(patsubst $(source)/%.vert, $(output)/%_vert.bin, $(vertex_sources))
fragment_output = $(patsubst $(source)/%.frag, $(output)/%_frag.bin, $(fragment_sources))

vertex_flag := --type vertex -p 120 -O 3 
fragment_flag := --type fragment -p 120 -O 3
define_flag := --varyingdef 
os_flag := Unset



all : 

ifeq ($(OS),Windows_NT)
os_flag := --platform windows
output  := $(output)/Windows
else 
unix_os := $(shell uname)
ifeq ($(unix_os),Linux)
os_flag := --platform linux
output  := $(output)/Linux
endif
endif 
	


all : $(vertex_output) $(fragment_output)
	
.PHONY : all 

$(output)/%_vert.bin : $(source)/%.vert
	[ -d $(output) ] || mkdir $(output)
	$(shaderc) --varyingdef $(patsubst %.vert, %.def, $^) \
	$(vertex_flag) -o $@ -f $^

$(output)/%_frag.bin : $(source)/%.frag
	[ -d $(output) ] || mkdir $(output)
	$(shaderc) --varyingdef $(patsubst %.frag, %.def, $^) \
	$(fragment_flag) -o $@ -f $^
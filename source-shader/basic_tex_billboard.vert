$input a_position, a_texcoord0
$output v_texcoord0

/*
 * Copyright 2011-2020 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

#include "shared/common.sh"

uniform vec4 u_billboardCenter[4096];

void main()
{
	
	vec3 cameraRight = vec3(u_view[0][0], u_view[1][0], u_view[2][0]);
	vec3 cameraUp = vec3(u_view[0][1], u_view[1][1], u_view[2][1]);
	
	gl_Position = vec4(u_billboardCenter[0].xyz, 1.0);
	v_texcoord0 = a_texcoord0;
}
  
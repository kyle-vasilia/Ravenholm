$input a_position, a_normal, a_texcoord0
$output v_texcoord0

/*
 * Copyright 2011-2020 Branimir Karadzic. All rights reserved.
 * License: https://github.com/bkaradzic/bgfx#license-bsd-2-clause
 */

#include "shared/common.sh"


void main()
{

	vec3 camRight = vec3(u_view[0][0], u_view[1][0], u_view[2][0]);
	vec3 camUp = vec3(u_view[0][1], u_view[1][1], u_view[2][1]);

	
	vec3 worldPos = a_position + camRight * (a_position + a_normal.xyz)
		+ camUp * (a_normal.xyz + a_position);

	gl_Position = mul(u_modelViewProj, vec4(worldPos, 1.0));
	

}
  
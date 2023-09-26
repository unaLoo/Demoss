#version 300 es

precision highp float;

uniform vec2 resolution;
layout (location = 0) in vec2 pixelCoord; 
layout (location = 1) in float size;

vec3 getCoord(vec2 pos,vec2 reso){
    vec2 Coord = pos/reso;
    return vec3(Coord,0);
}

//canvas -- > webgl
vec3 getCoord2(vec2 pos,vec2 reso){

    float x = (pos.x - reso.x/2.0)/float(reso.x/2.0);
    float y = (reso.y/2.0 - pos.y)/float(reso.y/2.0);
    return vec3(x,y,0);
}

void main(){
    // gl_Position = vec4(getCoord(pixelCoord,resolution),1);
    gl_Position = vec4(getCoord2(pixelCoord,resolution),1);
    gl_PointSize = size;
}
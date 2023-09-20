#version 300 es
precision highp float;

layout (location=0) in float item;

out float result;

void main(){
    result = item*item;
}

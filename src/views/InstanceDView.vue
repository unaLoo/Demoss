<template>
    <div class="main">
        <canvas id="playground"></canvas>
    </div>
</template>
<script lang="ts" setup>

import axios from 'axios';
import { onMounted } from 'vue';

let gl:WebGL2RenderingContext|null = null;
let program:WebGLProgram|null = null;

onMounted(async()=>{
    let canvas = document.querySelector('#playground') as HTMLCanvasElement;
    let dom = document.querySelector('div.main') as HTMLDivElement;
    gl = canvas!.getContext('webgl2')!; 

    //prepare phase
    //const resolutionData = new Float32Array([canvas.width,canvas.height]);
    //const PixelCoorData = new Float32Array([-200,100,200,-100,200,140,-200,-20]);

    //按像素坐标来，展示的canvas的像素坐标  1800 * 900 的大小
    //从canvas坐标：左上角为原点，x向右 0-1800，y向下 0-900       shader里转换成了webgl坐标系。-1，1  
    const PixelCoorData = new Float32Array([200,100,400,200,600,140,900,50,1200,400,1600,300]);
    const resolutionData = new Float32Array([canvas.clientWidth,canvas.clientHeight]);
    const sizeData = new Float32Array([10,20,30,40,50,60]);

    
    
    let VAO = gl.createVertexArray();
    gl.bindVertexArray(VAO);

    let VBO = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER,VBO);
    gl.bufferData(gl.ARRAY_BUFFER,PixelCoorData,gl.STATIC_DRAW);
    gl.bindBuffer(gl.ARRAY_BUFFER,VBO);

    let VBO2 = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER,VBO2);
    gl.bufferData(gl.ARRAY_BUFFER,sizeData,gl.STATIC_DRAW);
    gl.bindBuffer(gl.ARRAY_BUFFER,VBO2);

    gl.bindVertexArray(null);

    let Vsrc = '';let Fsrc = '';
    await axios.get('/shader/insCase.vert').then((res)=>{
        Vsrc = res.data;
    })
    await axios.get('/shader/insCase.frag').then((res)=>{
        Fsrc = res.data;
    })

    if(Vsrc == '' || Fsrc == ''){
        console.log('getShaderSource error');
        
        return;
    }

    let Vshader = gl.createShader(gl.VERTEX_SHADER)!;
    let Fshader = gl.createShader(gl.FRAGMENT_SHADER)!;
    gl.shaderSource(Vshader,Vsrc);
    gl.shaderSource(Fshader,Fsrc);
    gl.compileShader(Vshader);
    gl.compileShader(Fshader);

    if(!gl.getShaderParameter(Vshader,gl.COMPILE_STATUS)){
        console.log(gl.getShaderInfoLog(Vshader));
        return;
    }
    if(!gl.getShaderParameter(Fshader,gl.COMPILE_STATUS)){
        console.log(gl.getShaderInfoLog(Fshader));
        return;
    }

    program = gl.createProgram()!;
    gl.attachShader(program,Vshader);
    gl.attachShader(program,Fshader);

    gl.linkProgram(program);
    // if(!gl.getParameter(gl.LINK_STATUS)){
    //     console.log(gl.getProgramInfoLog(program));
    // }

    //draw phase
    gl.useProgram(program);

    gl.bindVertexArray(VAO);
    gl.bindBuffer(gl.ARRAY_BUFFER,VBO);
    gl.enableVertexAttribArray(0);
    gl.vertexAttribPointer(0,2,gl.FLOAT,false,4*2,0);
    gl.vertexAttribDivisor(0,1);
    gl.bindBuffer(gl.ARRAY_BUFFER,VBO2);
    gl.enableVertexAttribArray(1);
    gl.vertexAttribPointer(1,1,gl.FLOAT,false,4*1,0);
    gl.vertexAttribDivisor(1,1);

    let uniformLoc = gl.getUniformLocation(program,'resolution');
    gl.uniform2fv(uniformLoc,resolutionData);
    
    // gl.drawArrays(gl.POINTS,0,1);
    gl.drawArraysInstanced(gl.POINTS,0,1,sizeData.length);

    gl.bindVertexArray(null);
    gl.bindBuffer(gl.ARRAY_BUFFER,null);

})





</script>
<style lang="scss" scoped>
    .main{
        width: 100%;
        height: 100%;
        #playground {   
            width: 100%;
            height: 100%;
            background-color: aliceblue;
        }
    }
</style>
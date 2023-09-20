<template>
    <div class="Container">
        <h1>利用transformfeedback计算平方数</h1>
        <canvas class="Playground"></canvas>
    </div>
</template>
<script lang="ts" setup>
import axios from 'axios';
import { onMounted } from 'vue';

var gl:WebGL2RenderingContext;
var Vshader:WebGLShader;
var Fshader:WebGLShader;
var Program:WebGLProgram;

onMounted(async()=>{
    let canvas = document.querySelector('.Playground') as HTMLCanvasElement;
    gl = canvas.getContext('webgl2')!;
    //求数组中各个数的平方

    let vsrc='',fsrc='';
    await axios.get("/shader/XFcase.vert").then(res=>{
        vsrc=res.data;
    })
    await axios.get("/shader/XFcase.frag").then(res=>{
        fsrc=res.data;
    })

    Vshader = gl.createShader(gl.VERTEX_SHADER)!;
    Fshader = gl.createShader(gl.FRAGMENT_SHADER)!;
    gl.shaderSource(Vshader,vsrc);
    gl.shaderSource(Fshader,fsrc);
    gl.compileShader(Vshader);
    gl.compileShader(Fshader);

    Program = gl.createProgram()!;
    gl.attachShader(Program,Vshader);
    gl.attachShader(Program,Fshader);
    gl.transformFeedbackVaryings(Program,['result'],gl.SEPARATE_ATTRIBS);
    gl.linkProgram(Program);
    if(!gl.getProgramParameter(Program,gl.LINK_STATUS)){
        console.log(gl.getProgramInfoLog(Program));
    }

    gl.useProgram(Program);
    
    const count = 1000;
    let arr = new Float32Array(count);
    for(let i=0;i<count;i++){
        arr[i] = i+1;
    }
    
    ///////////////////////////// 
    let VAO = gl.createVertexArray()!;
    gl.bindVertexArray(VAO);
    
    let VBO = gl.createBuffer()!;
    gl.bindBuffer(gl.ARRAY_BUFFER,VBO);
    gl.bufferData(gl.ARRAY_BUFFER,arr,gl.STATIC_DRAW);
    
    gl.enableVertexAttribArray(0);
    gl.vertexAttribPointer(0,1,gl.FLOAT,false,1*4,0);

    gl.bindBuffer(gl.ARRAY_BUFFER,null);
    gl.bindVertexArray(null);

    ///////////////////////////

    let XFBO = gl.createBuffer()!;
    gl.bindBuffer(gl.ARRAY_BUFFER,XFBO);
    gl.bufferData(gl.ARRAY_BUFFER,count*4,gl.STATIC_DRAW);
    gl.bindBuffer(gl.ARRAY_BUFFER,null);


    let XFO = gl.createTransformFeedback();
    gl.bindTransformFeedback(gl.TRANSFORM_FEEDBACK,XFO);
    gl.bindBufferBase(gl.TRANSFORM_FEEDBACK_BUFFER,0,XFBO);
    gl.bindTransformFeedback(gl.TRANSFORM_FEEDBACK,null);

    ////////////////////////////////

    //start xf
    gl.enable(gl.RASTERIZER_DISCARD);

    gl.bindVertexArray(VAO);
    gl.bindTransformFeedback(gl.TRANSFORM_FEEDBACK,XFO);

    gl.beginTransformFeedback(gl.POINTS);
    gl.drawArrays(gl.POINTS,0,10);
    gl.endTransformFeedback();

    // gl.bindBufferBase(gl.TRANSFORM_FEEDBACK_BUFFER,0,null);
    gl.disable(gl.RASTERIZER_DISCARD);


    //check the results
    let results = new Float32Array(count);
    gl.getBufferSubData(gl.TRANSFORM_FEEDBACK_BUFFER,0,results);
    console.log(results);

    //unbind
    gl.bindVertexArray(null);
    gl.bindBuffer(gl.TRANSFORM_FEEDBACK_BUFFER,null);
    gl.bindTransformFeedback(gl.TRANSFORM_FEEDBACK,null);
    gl.bindVertexArray(null);

    ////////////////////////////
})


</script>
<style lang="scss">

.Container{
    width: 100%;
    height: 100%;
    background-color: rgb(231, 229, 226);

    .h1{
        display: flex;
        text-align: center;
        justify-content: center;
    }
    .Playground {
        width: 100%;
        height: 100%;
    }
}

</style>
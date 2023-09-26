# 应用场景

海量object，同属性，但不同states

CPU计算-------not good

GPU计算和更新--parallel--faster & no huge uploads







# 细节

----phase 1 :: create program

+ tfVaryings要在program link之前，在shader init之后
+ Varyings come from vShader outs and fShader outs
+ Separate  VS  Interleaved  





----phase 2 :: init tfbuffer   ( init tfo )

+ tfBuffer 和普通的Array_BUFFER无异

+ TFO可像VAO一样，先初始化，在用时再bind it
+ webgl2 有一个 default tfo ， so dont need to bind tf to null
+ 对于 bindBufferBase :: Separate  可以指定一下绑定点，否则0

---phase 3 :: drawcall  & capture outputs





---phase 4 :: 后续在用tfbuffer时，直接当作一个不用上传数据的arraybuffer来用





> the life of a buffer 
>
> 1. **prepare phase**        
>
>    init buffer              
>
>    ---unbindfrom ARRAYBUFFER
>
> 2. **TF phase**
>
>    bindBufferBase:: 
>
>    bind the buffer to gl.TRANSFORM_FEEDBACK_BUFFER
>
>    webgl   write to  this buffer
>
>    ----unbindfrom ARRAYBUFFER & XFBUFFER
>
> 3. **use the TF result phase** 
>
>    bindBuffer::
>
>    bind the buffer to gl.ARRAY_BUFFFER
>
>    webgl   read from this buffer

 














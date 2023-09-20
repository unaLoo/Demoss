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

---phase 3 :: drawcall  & capture outputs
classdef ClassRSUs %共有m个RSU，每个RSU中都有n个server
   properties
       RSUNum % road side unit数量。1×1
       serverNum % 每个RSU中包含的server数量。1×1
       capability %所有RSU中的servers的处理能力。m×n
       length %路被分成m块，每块的长度。1×m
       m %动态能耗计算时，capability的系数，需要大于2。m×n
       b %动态能耗计算时的常量beta。m×n
       staticPower %静态的功率（乘以时间为功耗）。m×n
       sleepPower %休眠的功率。m×n
       switchOnEnergy %打开server需要的能耗。m×n
       switchOffEnergy %关闭server需要的能耗。m×n
       switchOnTime %打开server需要的时间。m×n
       switchOffTime %关闭server需要的时间。m×n
       transmissionRate %server的传输率，与application的dateSize一起可以求出传输时间。1×m
   end
end
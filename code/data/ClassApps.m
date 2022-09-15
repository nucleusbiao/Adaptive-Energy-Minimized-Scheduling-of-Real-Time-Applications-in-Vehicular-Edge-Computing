classdef ClassApps %会随着时间新增application，每个功能有多个任务。假设有num个application
   properties
       appNum %存在多少个application
       taskNum %每个application中的task数量。1×num
       generateTime %每个app的产生时间。1×num
       status %所有app被执行与否，1为被执行，0为未被执行。1×num
       group %apps的分组情况
       velocity %每个车/功能的速度。1×num
       dateSize %每个功能的数据量，需要除以传输率来计算传输时间。1×num
       deadline %每个功能的截止时间要求。1×num
       makeSpanApp %每个功能的实际完成时间。1×num
       computation %每个application都有各自的tasks，每个任务的计算量(除以server的capability才是真正的执行时间)
       E %任务是否存在先后约束关系，大于0为存在， 小于0为不存在
       segment %应用中每个任务在的路段以及方向，第一行路段号(对应rsuIndex)，第2行方向（1为往RSU编号大的方向走，0反之）。2×num
       rank %优先值。
       priorityOrder %优先级。
   end
end
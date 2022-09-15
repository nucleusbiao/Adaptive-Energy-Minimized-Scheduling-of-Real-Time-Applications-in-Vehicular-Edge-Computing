function [ DAGTypeIndex ] = DAGTypeIndexFunc(APPs, appIndex)
taskNum = APPs.taskNum(appIndex);
if taskNum == 18
    DAGTypeIndex = 1;
elseif taskNum == 15
    DAGTypeIndex = 2;
elseif taskNum == 27
    DAGTypeIndex = 3;
elseif taskNum == 21
    if APPs.E{appIndex}(2,15) ~= -1
        DAGTypeIndex = 4;
    elseif APPs.E{appIndex}(2,11) ~= -1
        DAGTypeIndex = 6;
    else
        DAGTypeIndex = 7;
    end
elseif taskNum == 20
    DAGTypeIndex = 5;
elseif taskNum == 23
    DAGTypeIndex = 8;
elseif taskNum == 30
    if APPs.E{appIndex}(4,7) ~= -1
        DAGTypeIndex = 9;
    else
        DAGTypeIndex = 10;
    end
end
end
function [ schedule ] = SortScheduleFunc(schedule, RSUNum, serverNum)
%将schedule中每个rsu 的每个server，根据开始时间进行排序，以便后续的其他操作
for i = 1:RSUNum
    for j = 1:serverNum
        eval(strcat('schedule{i}.server',num2str(j),'=sortrows(schedule{i}.server',num2str(j),');'));
    end
end
end
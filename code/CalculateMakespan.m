function [ makespan ] = CalculateMakespan(schedule)
%求出schedule中的最大完成时间（makespan）
makespan = 0;
RSUNum = numel(schedule);
for i = 1:RSUNum
    serverNum = length(fieldnames(schedule{i}));
    for j = 1:serverNum
        eval(strcat('scheduleTemp = schedule{i}.server',num2str(j),';'))
        if ~isempty(scheduleTemp)
            makespanTemp = max(scheduleTemp(:,3));
            makespan = max(makespan, makespanTemp);
        end
    end
end
end
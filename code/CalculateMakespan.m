function [ makespan ] = CalculateMakespan(schedule)
%���schedule�е�������ʱ�䣨makespan��
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
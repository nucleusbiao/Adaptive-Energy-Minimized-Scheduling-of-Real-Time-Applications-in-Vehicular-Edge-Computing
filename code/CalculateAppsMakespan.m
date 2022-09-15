function [ makespan ] = CalculateAppsMakespan(schedule, APPs)
% Find the maximum completion time in the schedule (makespan)
appNum = APPs.appNum;
taskNum = APPs.taskNum;
makespan = zeros(1, appNum);
RSUNum = numel(schedule);
for i = 1:appNum
    taskDoneTimeArray{i} = zeros(1, taskNum(i));
end
for i = 1:RSUNum
    serverNum = length(fieldnames(schedule{i}));
    for j = 1:serverNum
        eval(strcat('scheduleTemp = schedule{i}.server',num2str(j),';'))
        if ~isempty(scheduleTemp)
            for k = 1:size(scheduleTemp, 1)
                taskDoneTimeArray{scheduleTemp(k,6)}(scheduleTemp(k,5)) = scheduleTemp(k,3);
            end
        end
    end
end
for i = 1:appNum
    makespan(i) = max(taskDoneTimeArray{i});
end
end
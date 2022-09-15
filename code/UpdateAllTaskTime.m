function [ flag, schedule ] = UpdateAllTaskTime( schedule, APPs, appIndex, taskIndex, RSUs, rsuIndex, serverIndex, pos, ESTForiTask )

flag = 1;
RSUNum = RSUs.RSUNum;
serverNum = RSUs.serverNum;
eval(strcat('scheduleI = schedule{rsuIndex}.server',num2str(serverIndex),';'));
scheduleTemp = schedule; 
taskExcutionTime = ExecutionTimeFunc(APPs.computation{appIndex}(taskIndex), RSUs.capability(rsuIndex,serverIndex));
EFTForiTask = ESTForiTask + taskExcutionTime;

FinishArray = [];
BiginArray = [];
for rowIndex = 1:size(scheduleI,1) % 把该处理器中所有任务的开始时间和结束时间存起来
    FinishArray = [FinishArray, scheduleI(rowIndex,3)];
    BiginArray = [BiginArray, scheduleI(rowIndex,1)];
end
FinishArray = sort(FinishArray);
BiginArray = sort(BiginArray);
priorityOrder = upwardRankFunc(APPs, appIndex, RSUs, rsuIndex);
index = find(priorityOrder==taskIndex);

if EFTForiTask < BiginArray(pos)  %如果插入的间隔可以放下新加入的task，后续任务的开始时间不变
    eval(strcat('schedule{rsuIndex}.server',num2str(serverIndex),'(end+1,:)=[ESTForiTask, taskExcutionTime, EFTForiTask, index, taskIndex, appIndex];'))
    eval(strcat('schedule{rsuIndex}.server',num2str(serverIndex),'(pos+1:end,:)=','schedule{rsuIndex}.server',num2str(serverIndex),'(pos:end-1,:);'))
    eval(strcat('schedule{rsuIndex}.server',num2str(serverIndex),'(pos,:)=[ESTForiTask, taskExcutionTime, EFTForiTask, index, taskIndex, appIndex];'))
%     schedule = SortScheduleFunc(schedule, RSUNum, serverNum);
else  
    TaskIniRSU = [];
    eval(strcat('schedule{rsuIndex}.server',num2str(serverIndex),'(end+1,:)=[ESTForiTask, taskExcutionTime, EFTForiTask, index, taskIndex, appIndex];'))
    eval(strcat('schedule{rsuIndex}.server',num2str(serverIndex),'(pos+1:end,:)=','schedule{rsuIndex}.server',num2str(serverIndex),'(pos:end-1,:);'))
    eval(strcat('schedule{rsuIndex}.server',num2str(serverIndex),'(pos,:)=[ESTForiTask, taskExcutionTime, EFTForiTask, index, taskIndex, appIndex];'))
    for i = 1:serverNum
        eval(strcat('scheduleTemp1 = schedule{rsuIndex}.server',num2str(i),';'));
        if isempty(scheduleTemp1)
            continue
        end
    try
        TaskIniRSU = [TaskIniRSU;scheduleTemp1 i*ones(size(scheduleTemp1,1),1)];%任务的开始时间、执行时间、结束时间、执行顺序、taskIndex、appIndex、serverIndex
    catch
        break
    end
    end
    TaskIniRSU = sortrows(TaskIniRSU,1);
    s = find(TaskIniRSU(:,1)==ESTForiTask);
    if isempty(s)
        s=1;
    end
    for i = s(1):size(TaskIniRSU,1)
        if TaskIniRSU(i,3) < ESTForiTask
            continue
        end
        ESTForiTaskArray = [];
        predArray = pickUpPredFunc(APPs.E{TaskIniRSU(i,6)},TaskIniRSU(i,5));
        %         taskiExcutionTime = ExecutionTimeFunc(APPs.computation{TaskIniRSU(i,6)}(TaskIniRSU(i,5)), RSUs.capability(rsuIndex,TaskIniRSU(i,7)));
        if isempty(predArray)
            for j = s:i-1
                if TaskIniRSU(j,7) == TaskIniRSU(i,7)
                    ESTForiTaskArray = [ESTForiTaskArray, TaskIniRSU(j,3)];
                end
            end
            ESTForiTaskArray = [ESTForiTaskArray, TaskIniRSU(i,1)];
%             TaskIniRSU(i,3) = TaskIniRSU(i,1) + TaskIniRSU(i,2);
%             continue
        else
            for j = s:i-1
                if ~isempty(find(predArray == TaskIniRSU(j,5)))&&TaskIniRSU(j,6) == TaskIniRSU(i,6)
                    if TaskIniRSU(j,7) == TaskIniRSU(i,7)
                        ESTForiTaskArray = [ESTForiTaskArray, TaskIniRSU(j,3)];
                        continue
                    else
                        ESTForiTaskArray = [ESTForiTaskArray, TaskIniRSU(j,3) + APPs.E{TaskIniRSU(j,6)}(TaskIniRSU(j,5),TaskIniRSU(i,5))];
                        continue
                    end
                end
                if TaskIniRSU(j,7) == TaskIniRSU(i,7)
                    ESTForiTaskArray = [ESTForiTaskArray, TaskIniRSU(j,3)];
                end
            end
        end
        if isempty(ESTForiTaskArray)
            continue
        end
        ESTDescendArray = sort(ESTForiTaskArray, 'descend');
        TaskIniRSU(i,1) = ESTDescendArray(1);
        TaskIniRSU(i,3) = TaskIniRSU(i,1) + TaskIniRSU(i,2);
    end
    APPsEFTArray = zeros(APPs.appNum,max(APPs.taskNum));
    for i = 1:size(TaskIniRSU,1)
        APPsEFTArray(TaskIniRSU(i,6),TaskIniRSU(i,5)) = TaskIniRSU(i,3);
    end
    for i = 1:size(APPsEFTArray,1)
        if max(APPsEFTArray(i,:)) > APPs.deadline(i)
            flag = 0;
            break
        end
    end
    for i = 1:serverNum
        eval(strcat('scheduleII = schedule{rsuIndex}.server',num2str(i),';'));
        if ~isempty(scheduleII)
            tp = find(scheduleII(:,1)< ESTForiTask);
            if ~isempty(tp)
                eval(strcat('schedule{rsuIndex}.server',num2str(i),'(tp(end)+1:end,:)=[];'));
            else
                eval(strcat('schedule{rsuIndex}.server',num2str(i),'(1:end,:)=[];'));
            end
        end
    end
    for i = s(1) : size(TaskIniRSU,1)
        for n = 1:serverNum
            if TaskIniRSU(i,7) == n
                eval(strcat('schedule{rsuIndex}.server',num2str(n),'(end+1,:)=TaskIniRSU(i,1:6);'))
            end
        end
    end
end

end

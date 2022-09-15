function [ESTForiTask,pos] = ESTForiTaskFunc( schedule, APPs, appIndex, taskIndex, RSUs, rsuIndex, serverIndex, predArray, arrivalTime )
% Used to calculate the earliest start time of the task on the server
serverNum = RSUs.serverNum;
preTaskNum = 0; % Used to mark that there are several previous tasks associated with this task
taskExcutionTime = ExecutionTimeFunc(APPs.computation{appIndex}(taskIndex), RSUs.capability(rsuIndex,serverIndex)); %任务taskIndex在serverIndex中的执行时间
eval(strcat('scheduleTemp = schedule{rsuIndex}.server',num2str(serverIndex),';'));
for i=1:size(predArray,2) 
    if predArray(i)>0
        preTaskNum = preTaskNum + 1;
    end
end
STwhenServerEmpty = max([arrivalTime, RSUs.switchOnTime(rsuIndex, serverIndex)]); %start time when server is empty

if preTaskNum==0 %没有前任任务时，即为该app的entry任务
    if isempty(scheduleTemp) %处理器没有执行任务
        pos = inf;
        ESTForiTask = STwhenServerEmpty;
    else % 虽然没有前任任务，但此处理器之前分配过任务时，尝试嵌入任务！！
        ESTForiTask = max([max(scheduleTemp(:,3)), STwhenServerEmpty]);
        FinishArray = [];
        BiginArray = [];
        for rowIndex = 1:size(scheduleTemp,1) % 把该处理器中所有任务的开始时间和结束时间存起来
            FinishArray = [FinishArray, scheduleTemp(rowIndex,3)];
            BiginArray = [BiginArray, scheduleTemp(rowIndex,1)];
        end
        FinishArray = sort(FinishArray);
        BiginArray = sort(BiginArray);
        for q = 1:size(scheduleTemp, 1)+1  % 尝试嵌入任务
            if q == size(scheduleTemp, 1)+1
                pos = inf;
                ESTForiTask = max(FinishArray(q-1),STwhenServerEmpty);
                break
            end
            if BiginArray(q) < STwhenServerEmpty
                continue
            end
            if q == 1 % 尝试嵌入这个处理器第一个任务之前时           
                ESTForiTask = STwhenServerEmpty;
                [ flag ] = UpdateAllTaskTime( schedule, APPs, appIndex, taskIndex, RSUs, rsuIndex, serverIndex, q, ESTForiTask );
                if flag == 1
                    pos = q;
                    break
                end
            else
                ESTForiTask = max(FinishArray(q-1),STwhenServerEmpty);
                [ flag ] = UpdateAllTaskTime( schedule, APPs, appIndex, taskIndex, RSUs, rsuIndex, serverIndex, q, ESTForiTask );
                if flag == 1
                    pos = q;
                    break
                end
            end
        end

    end
    
else % 有前任任务时
    predNumCount = 0;
    ESTForiTaskArray = [];
    for i = 1:serverNum %找到所有前置任务
        eval(strcat('scheduleI = schedule{rsuIndex}.server',num2str(i),';'));
        if isempty(scheduleI)
            continue
        end
        ProArray = [];
        for j = 1:size(scheduleI,1) % 把处理器中的任务序号存起来
            if scheduleI(j,6) == appIndex
                ProArray = [ProArray, scheduleI(j,5)];
            end
        end
        intersectionArray = intersect(predArray, ProArray); % 找出该处理器内前任任务
        if isempty(intersectionArray) % 该处理器内无前任任务时
            continue
        end
        for k = 1:size(intersectionArray,2) % 该处理器内有前任任务时
            for g = 1:size(scheduleI,1) % 选中前任任务的行
                if scheduleI(g, 5)==intersectionArray(k) && scheduleI(g, 6)==appIndex
                    break
                end
            end
            if i == serverIndex
                ESTForiTaskArray = [ESTForiTaskArray, scheduleI(g, 3)];
                predNumCount = predNumCount+1;
%                 intersectionArray(k) = []; % 把已找到的前任任务去掉，还没写完
            else
                ESTForiTaskArray = [ESTForiTaskArray, scheduleI(g, 3) + APPs.E{appIndex}(intersectionArray(k),taskIndex)];
                predNumCount = predNumCount+1;
%                 intersectionArray(k) = []; % 把已找到的前任任务去掉，还没写完
            end
        end
        if predNumCount == preTaskNum % 前任任务已经找全的情况
            break;
        end
    end
    if predNumCount ~= preTaskNum
        error('EST函数，找不全前置任务');
    end
    
    ESTDescendArray = sort(ESTForiTaskArray, 'descend');
    ESTByPreTasks = ESTDescendArray(1); %前任任务的最大的完成时间（已考虑传输时间）
    FinishArray = [];
    BiginArray = [];
    for rowIndex=1:size(scheduleTemp,1) % 把该处理器中所有任务的开始时间和结束时间存起来，用来尝试嵌入
        FinishArray = [FinishArray, scheduleTemp(rowIndex,3)];
        BiginArray = [BiginArray, scheduleTemp(rowIndex,1)];
    end
    FinishArray = sort(FinishArray);
    BiginArray = sort(BiginArray);
    if isempty(scheduleTemp)
        ESTForiTask = max([STwhenServerEmpty, ESTByPreTasks]);
        pos = inf;
    else
        ESTForiTask = max([STwhenServerEmpty, FinishArray(end), ESTByPreTasks]);
        pos = inf;
        for q = 1:size(scheduleTemp,1) % 尝试嵌入任务
            if  ESTByPreTasks < BiginArray(q)
                if q == 1
                    ESTForiTask = max([STwhenServerEmpty, ESTByPreTasks]);
                else
                    ESTForiTask = max([STwhenServerEmpty, ESTByPreTasks, FinishArray(q-1)]);
                end
                [ flag ] = UpdateAllTaskTime( schedule, APPs, appIndex, taskIndex, RSUs, rsuIndex, serverIndex, q, ESTForiTask );
                if flag == 1
                    pos = q;
                    break
                else
                    ESTForiTask = max([STwhenServerEmpty, FinishArray(end), ESTByPreTasks]);
                end
            end            
        end
    end
end
end
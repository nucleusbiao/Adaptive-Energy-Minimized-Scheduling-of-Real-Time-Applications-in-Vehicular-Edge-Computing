function [scheduleTemp, energyFor1App] = AppScheduleFunc(schedule, APPs, appIndex, RSUs, rsuIndex, workServerNum)
% Schedule the specified app in the specified rsu
%------------------------------------------------------------------------------------------------------------

priorityOrder = upwardRankFunc(APPs, appIndex, RSUs, rsuIndex); % Sort tasks
falseFlag = 0;
RSUNum = RSUs.RSUNum;
serverNum = RSUs.serverNum;
scheduleTemp = schedule;
for i = 1:APPs.taskNum(appIndex) % Put all tasks in each server in order, and find the minimum EST completion allocation for the task
    taskIndex = priorityOrder(i); % Select tasks to be executed in order of priority
    predArray = pickUpPredFunc(APPs.E{appIndex}, taskIndex); 
    EFTArray = [];
    ESTForiTaskArray = [];

    for serverIndex = 1:workServerNum % Calculate the EST of the task in each open server
        transTime = APPs.dateSize(appIndex)/RSUs.transmissionRate(rsuIndex);
        if APPs.segment(1, appIndex) == rsuIndex
            arrivalTime = APPs.generateTime(appIndex) + transTime;
        elseif APPs.segment(1, appIndex)>rsuIndex && APPs.segment(2, appIndex)==0
            travelLength = sum(RSUs.length(rsuIndex+1:APPs.segment(1, appIndex)));
            arrivalTime = APPs.generateTime(appIndex) + transTime + travelLength/APPs.velocity(appIndex);
        elseif APPs.segment(1, appIndex)<rsuIndex && APPs.segment(2, appIndex)==1
            travelLength = sum(RSUs.length(APPs.segment(1, appIndex):rsuIndex-1));
            arrivalTime = APPs.generateTime(appIndex) + transTime + travelLength/APPs.velocity(appIndex);
        else
            EFTArray = [EFTArray, Inf];
            continue;
        end
        [ESTForiTask,pos] = ESTForiTaskFunc( scheduleTemp, APPs, appIndex, taskIndex, RSUs, rsuIndex, serverIndex, predArray, arrivalTime );
        ESTForiTaskArray = [ESTForiTaskArray, [ESTForiTask;pos;serverIndex]];
        taskExcutionTime = ExecutionTimeFunc(APPs.computation{appIndex}(taskIndex), RSUs.capability(rsuIndex,serverIndex)); %任务taskIndex在serverIndex中的执行时间
        eval(strcat('scheduleI = scheduleTemp{rsuIndex}.server',num2str(serverIndex),';'));
        if ESTForiTask+taskExcutionTime > APPs.deadline(appIndex) 
            EFTArray = [EFTArray, [Inf;pos;serverIndex]];
        else
            EFTArray = [EFTArray, [ESTForiTask+taskExcutionTime;pos;serverIndex]];
        end

    end
    
    %Find the task with the smallest EST and check whether it meets the real-time constraints
    [value, seq] = sort(EFTArray(1,:));
    EFTArray = sortrows(EFTArray',1)';
    %     MinEFTArray = find(EFTArray(1,:) == EFTArray(1,1));
    %     for i = 1:size(MinEFTArray,2)
    %         eval(strcat('scheduleII = scheduleTemp{rsuIndex}.server',num2str(EFTArray(3,i)),';'));
    %         if isempty(scheduleII)
    %             EFTArray(:,1) = EFTArray(:,i)
    %             break
    %         end
    %     end
    if value(1) == Inf
        falseFlag = 1;
        break;
    else
        if EFTArray(2,1)~=inf
            [ flag,scheduleTemp ] = UpdateAllTaskTime( scheduleTemp, APPs, appIndex, taskIndex, RSUs, rsuIndex,  EFTArray(3,1), EFTArray(2,1), ESTForiTaskArray(1,seq(1)) );
            
        else
            eval(strcat('scheduleTemp{rsuIndex}.server',num2str(seq(1)),'(end+1,:)=[ESTForiTaskArray(1,seq(1)), value(1)-ESTForiTaskArray(1,seq(1)), value(1), i, taskIndex, appIndex];'))
            scheduleTemp = SortScheduleFunc(scheduleTemp, RSUNum, serverNum);
        end

    end
end

if falseFlag == 1
    energyFor1App = Inf;
    scheduleTemp = schedule;
else
    energyTotalBefore = EnergyConsumptionFunc(schedule, RSUs);
    energyTotalNow = EnergyConsumptionFunc(scheduleTemp, RSUs);
    energyFor1App = energyTotalNow - energyTotalBefore; 
end
end
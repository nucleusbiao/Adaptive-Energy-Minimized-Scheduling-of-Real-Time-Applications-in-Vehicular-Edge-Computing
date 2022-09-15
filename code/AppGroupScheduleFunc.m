function [scheduleTemp, energyForAppGroup] = AppGroupScheduleFunc(schedule, APPs, exeAppIndexArray, RSUs, rsuIndex, workServerNum)

% Schedule the group of apps in the specified rsu
% 把apps的group在指定的rsu中进行调度
%-------------------------------------------------------------------------------------------------

%Sort tasks: the first line is taskIndex, the second line is appIndex
priorityOrder = upwardRankGroupFunc(APPs, exeAppIndexArray, RSUs, rsuIndex);
taskNum = size(priorityOrder, 2);
falseFlag = 0;
RSUNum = RSUs.RSUNum;
serverNum = RSUs.serverNum;
scheduleTemp = schedule;
for i = 1:taskNum
    taskIndex = priorityOrder(1, i); % Select tasks to be executed in order of priority
    appIndex = priorityOrder(2, i);
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
            EFTArray = [EFTArray, [Inf;Inf;Inf]];
            continue;
        end
        [ESTForiTask, pos] = ESTForiTaskFunc( scheduleTemp, APPs, appIndex, taskIndex, RSUs, rsuIndex, serverIndex, predArray, arrivalTime );
        ESTForiTaskArray = [ESTForiTaskArray, [ESTForiTask;pos;serverIndex]];
        taskExcutionTime = ExecutionTimeFunc(APPs.computation{appIndex}(taskIndex), RSUs.capability(rsuIndex,serverIndex)); % Execution time of task taskIndex in serverIndex
        eval(strcat('scheduleI = scheduleTemp{rsuIndex}.server',num2str(serverIndex),';'));
        if ESTForiTask+taskExcutionTime > APPs.deadline(appIndex) % Set to Inf if the deadline requirement is not met
            EFTArray = [EFTArray, [Inf;pos;serverIndex]];
        else
            EFTArray = [EFTArray, [ESTForiTask+taskExcutionTime;pos;serverIndex]];
        end

    end
    
    %Find the task with the smallest EST and check whether it meets the real-time constraints
    [value, seq] = sort(EFTArray(1,:));
    EFTArray = sortrows(EFTArray',1)';
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
        makeSpanAppTemp = CalculateAppsMakespan(scheduleTemp, APPs);
        x = APPs.deadline - makeSpanAppTemp;
        if ~isempty(find(x<0))
            disp('error');
        end
    end
end

if falseFlag == 1
    energyForAppGroup = Inf;
    scheduleTemp = schedule;
else
    energyTotalBefore = EnergyConsumptionFunc(schedule, RSUs);
    energyTotalNow = EnergyConsumptionFunc(scheduleTemp, RSUs);
    energyForAppGroup = energyTotalNow - energyTotalBefore;   %Calculate the increase in system energy consumption due to the addition of this function
end
end
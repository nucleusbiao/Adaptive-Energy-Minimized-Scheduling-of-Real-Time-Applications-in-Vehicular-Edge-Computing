function [ schedule, energyTotal, APPs, schTimeArray, saveNum, rsuBidTimeArray, rsuDAGBidTimeArray ] = EnergyMinimizedScheduleFunc(APPs, RSUs, collectAppNum, collectTimeSlot, saveExeTimeNum)
% Realize the minimum energy consumption scheduling function
time = 0;
RSUNum = RSUs.RSUNum;
serverNum = RSUs.serverNum;
appNum = APPs.appNum;
generateTimeTemp = APPs.generateTime;
for i = 1:RSUNum
    for j = 1:serverNum
        eval(strcat('schedule{i}.server',num2str(j),'=[];'))
    end
end
schTimeArray = []; %Save algorithmic decision time for a certain number of apps
saveNum = 0;
failedFlag = 0;
rsuBidTimeArray = [];
rsuDAGBidTimeArray{10} = [];
while ~isempty(find(~APPs.status)) %当app的状态有为0（即未被执行）的情况时
    t11 = clock;
    energyMatrix = [];
    % Find the app to be executed, where exeAppIndex is the number of the apps to be executed
    exeAppIndexArray = find(generateTimeTemp<(time+collectTimeSlot), collectAppNum);
    exeAppNum = size(exeAppIndexArray,2);
    if exeAppNum == collectAppNum
        time = generateTimeTemp(exeAppIndexArray(end));
    else
        time = time + collectTimeSlot;
    end
    APPs.status(exeAppIndexArray) = 1;
    APPs.group{end+1} = exeAppIndexArray;
    generateTimeTemp(exeAppIndexArray) = 1e10;
    
    if saveNum < saveExeTimeNum
        tic
    end
    %First put each app to be executed into each rsu for execution, find the increase in energy consumption, and put it into the matrix
    for i = 1:exeAppNum
        appIndex = exeAppIndexArray(i);
        for rsuIndex = 1:RSUNum
            tic
            [~, energyFor1App] = PartFuncScheduleFunc(schedule, APPs, appIndex, RSUs, rsuIndex);
            timeTemp = toc;
            if appIndex <= 100
                rsuBidTimeArray(end+1) = timeTemp;
            end
            DAGTypeIndex = DAGTypeIndexFunc(APPs, appIndex);
            rsuDAGBidTimeArray{DAGTypeIndex}(end+1) = timeTemp;
            if energyFor1App ~= Inf
                energyMatrix(rsuIndex, appIndex) = energyFor1App;
            else
                energyMatrix(rsuIndex, appIndex) = Inf;
            end
        end
        if min(energyMatrix(:, appIndex)) == Inf
            fprintf('deadline太紧，没有任何RSU可以执行该app，因此调度不了');
            failedFlag = 1;
            break;
        end
    end
    if failedFlag == 1
        if saveNum < saveExeTimeNum
            schTimeArray(end+1) = toc;
        end
        break;
    end
    energyMatrix(:,setdiff([1:size(energyMatrix,2)],exeAppIndexArray)) = Inf; % Set the columns that are not the app to be processed this time to Inf
    
    %Then select the appropriate matching method from the matrix, update the matrix, and finally generate the schedule
    choiceRSUIndexArray = [];
    doneAppIndexArray = []; %Store the assigned appIndex to avoid repeating the last decision when selecting the minimum energy consumption.
    for i = 1:exeAppNum 
        [choiceRSUIndex, choiceAppIndex] = MinAppEnergyIndexFunc(energyMatrix, doneAppIndexArray);
        if isempty(find(exeAppIndexArray==choiceAppIndex)) || ~isempty(intersect(doneAppIndexArray,choiceAppIndex))
            fprintf('不分组可调度，但分组后不可调度'); 
            failedFlag = 1;
            break;
        end
        doneAppIndexArray(end+1) = choiceAppIndex;
        if isempty(choiceRSUIndexArray)  %Select the scheduling method and save the result to the selection array and scheduling method structure
            choiceRSUIndexArray(end+1) = choiceRSUIndex;
            eval(strcat('scheduleManner.RSU',num2str(choiceRSUIndex),'=choiceAppIndex;'));
        else
            %case1: The energy consumption of multiple allocations together is the least
            if ~isempty(find(choiceRSUIndexArray==choiceRSUIndex)) 
                eval(strcat('scheduleManner.RSU',num2str(choiceRSUIndex),'(end+1)=choiceAppIndex;'));
            else
                choiceRSUIndex = MinGroupEnergyRSUIndexFunc(energyMatrix, choiceRSUIndex, choiceAppIndex, choiceRSUIndexArray, scheduleManner); %找出所有组合中最小能耗的方式
               
                %case2: The energy consumption of multiple allocations together is less than the energy consumption allocated separately
                if ~isempty(find(choiceRSUIndexArray==choiceRSUIndex)) 
                    eval(strcat('scheduleManner.RSU',num2str(choiceRSUIndex),'(end+1)=choiceAppIndex;'));
                else %case3: The energy consumption of multiple allocations together is greater than the energy consumption allocated separately
                    choiceRSUIndexArray(end+1) = choiceRSUIndex;
                    eval(strcat('scheduleManner.RSU',num2str(choiceRSUIndex),'=choiceAppIndex;'));
                end
            end
        end
        energyMatrix(find([1:RSUNum]~=choiceRSUIndex), choiceAppIndex) = Inf;
        for j = 1:exeAppNum-1 
            updateAppIndex = setdiff(exeAppIndexArray, choiceAppIndex);
            if energyMatrix(choiceRSUIndex, updateAppIndex(j)) == Inf
                continue;
            end
            appIndexArray = updateAppIndex(j);
            eval(strcat('appIndexArray = [appIndexArray, setdiff(scheduleManner.RSU',num2str(choiceRSUIndex),', appIndexArray)];'));
            [~, energyForAppGroup] = PartFuncScheduleFunc(schedule, APPs, appIndexArray, RSUs, choiceRSUIndex);
            energyMatrix(choiceRSUIndex, updateAppIndex(j)) = energyForAppGroup;
        end
    end
    if failedFlag == 1
        if saveNum < saveExeTimeNum
            schTimeArray(end+1) = toc;
        end
        break;
    end
    for i = 1:length(choiceRSUIndexArray) % schedule
        eval(strcat('appIndexArray=scheduleManner.RSU',num2str(choiceRSUIndexArray(i)),';'));
        [schedule, ~] = PartFuncScheduleFunc(schedule, APPs, appIndexArray, RSUs, choiceRSUIndexArray(i));
        schedule = SortScheduleFunc(schedule, RSUNum, serverNum);
    end
    t22 = clock;
    tt=etime(t22,t11);
    if saveNum < saveExeTimeNum
        schTimeArray(end+1) = toc;
        saveNum = saveNum + exeAppNum;
    end
end
if failedFlag == 0
    energyTotal = EnergyConsumptionFunc(schedule, RSUs);
    APPs.makeSpanApp = CalculateAppsMakespan(schedule, APPs);
else
    energyTotal = Inf;
end
end
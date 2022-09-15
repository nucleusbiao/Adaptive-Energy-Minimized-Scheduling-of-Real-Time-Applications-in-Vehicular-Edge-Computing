%% You can run our algorithm here
% We provide some data for you to test

clear
clc
close all

for i = 1:10
    clearvars -except i
    scheduleTimeArray = [];
    energyTotalArray = [];

    clearvars -except i kn scheduleTimeArray energyTotalArray

    eval(strcat('load .\data\DAG10Type2s5Server1HzData',num2str(i),'.mat'));

    collectAppNum = 3;
    collectTimeSlot = 5;
    t1 = clock;
    [ schedule, energyTotal, APPs, schTimeArray, saveNum, rsuBidTimeArray, rsuDAGBidTimeArray ] = EnergyMinimizedScheduleFunc(APPs, RSUs, collectAppNum, collectTimeSlot, saveExeTimeNum);
    t2 = clock;
    scheduleTimeTotal = etime(t2,t1);
    eachAppSchTime = sum(schTimeArray) / saveNum; %Average algorithmic decision time for an app
    eachRsuBidTime = sum(rsuBidTimeArray) / length(rsuBidTimeArray); %rsu给能量bid的时间（只记录了100个app的）
    eachDAGRsuBidTime = [];
    for j = 1:10
        eachDAGRsuBidTime(j) = sum(rsuDAGBidTimeArray{j})/length(rsuDAGBidTimeArray{j}); %针对不同DAG，rsu给能量bid的时间
    end

    % Gante(schedule);
    fprintf('%d energy consumption is %f\n', i, energyTotal);
    eval(strcat('save DAG10Type10s5Server',num2str(i),'HzDataResult.mat schedule energyTotal APPs schTimeArray saveNum eachAppSchTime rsuBidTimeArray eachRsuBidTime rsuDAGBidTimeArray eachDAGRsuBidTime scheduleTimeTotal'));
    pause(1)
end
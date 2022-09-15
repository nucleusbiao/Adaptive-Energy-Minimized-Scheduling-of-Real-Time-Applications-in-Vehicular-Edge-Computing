clear
clc
close all

RSUNum = 5; % road side unit数量
serverNum = 5; % 每个RSU中包含的server数量
capMin = 1; %server处理能力下限
capMax = 5; %server处理能力上限
lenMin = 25; %道路分段长度下限
lenMax = 25; %道路分段长度上限
appNum = 20; %app的数量
taskNumMin = 5; %每个app的最少任务量
taskNumMax = 20; %每个app的最多任务量
taskExeMin = 1; %任务执行的最短时间
taskExeMax = 4; %任务执行的最长时间
collectAppNum = 2; %收集功能的最大数量
collectTimeSlot = 8; %收集功能的最大时间间隔
deadlineGap = 1;

RSUs = ClassRSUs;
RSUs.RSUNum = RSUNum;
RSUs.serverNum = serverNum;
RSUs.capability = sort(randi([capMin, capMax], RSUNum, serverNum), 2);
RSUs.length = randi([lenMin, lenMax], 1, RSUNum);
RSUs.m = randi([22, 22], RSUNum, serverNum)/10;
RSUs.b = randi([80, 80], RSUNum, serverNum);
RSUs.staticPower = randi([100, 100], RSUNum, serverNum);
RSUs.sleepPower = randi([40, 40], RSUNum, serverNum);
RSUs.switchOnEnergy = randi([25, 25], RSUNum, serverNum);
RSUs.switchOffEnergy = randi([15, 15], RSUNum, serverNum);
RSUs.switchOnTime = randi([2, 2], RSUNum, serverNum)/10;
RSUs.switchOffTime = randi([1, 1], RSUNum, serverNum)/10;
RSUs.transmissionRate = ones(1, RSUNum)*5*1024;

APPs = ClassApps;
APPs.appNum = appNum;
APPs.taskNum = randi([taskNumMin, taskNumMax], 1, appNum);
APPs.generateTime = zeros(1, appNum);
APPs.deadline = zeros(1, appNum);
APPs.generateTime(1) = randi([2, 20])/10;
APPs.deadline(1) = APPs.generateTime(1) + deadlineGap;
for i = 2:appNum
    APPs.generateTime(i) = APPs.generateTime(i-1) + randi([2, 20])/10;
    APPs.deadline(i) = APPs.generateTime(i) + deadlineGap;
end
APPs.status = zeros(1, appNum);
APPs.group = [];
APPs.velocity = 100/3.6*ones(1, appNum);
APPs.dateSize = randi([100, 500], 1, appNum);
for i = 1:APPs.appNum
    APPs.computation{i} = randi([taskExeMin, taskExeMax], 1, APPs.taskNum(i))/10;
end
for i = 1:appNum
    APPs.E{i} = [-1 3 5 -1; -1 -1 -1 6;  -1 -1 -1 6;  -1 -1 -1 -1]; %%%%%%
end

APPs.segment = [randi([1, RSUNum], 1, appNum); randi([0, 1], 1, appNum)];

save test.mat APPs RSUs collectAppNum collectTimeSlot
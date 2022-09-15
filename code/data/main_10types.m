clear
clc
close all


for n= 1:10
for kn = 1:100
generateFreq = n/10; %产生频率
runTime = 10; %运行时间
saveExeTimeNum = 30; %保存exeTimeNum数量app的算法决策时间
typeNum = 10; %DAG种类
collectAppNum = 1; %收集功能的最大数量
collectTimeSlot = 5; %收集功能的最大时间间隔
deadlineGapTime = 2; %截止时间间隔与最短执行时间的比例
scaleAppTypeNum = 5; %选取多少种DAG，将其deadline进行放大
deadlineGapTimeScale = 1; %部分种类的app的截止时间间隔进行放大

RSUNum = 5; % road side unit数量
serverNum = 5; % 每个RSU中包含的server数量
capMin = 1; %server处理能力下限
capMax = 5; %server处理能力上限
lenMin = 200; %道路分段长度下限
lenMax = 200; %道路分段长度上限
appNum = runTime*generateFreq * typeNum; %app的数量
taskExeMin = 1; %任务执行的最短时间
taskExeMax = 4; %任务执行的最长时间
communicationTimeRange = [0.01, 0.1]; %传输时间的范围

scaleAppTypeArray = sort(randperm(typeNum, scaleAppTypeNum)); %选出deadline放大的type
RSUs = ClassRSUs;
RSUs.RSUNum = RSUNum;
RSUs.serverNum = serverNum;
RSUs.capability = repmat([1:serverNum], RSUNum, 1);
% RSUs.capability = sort(randi([capMin, capMax], RSUNum, serverNum), 2);
RSUs.length = randi([lenMin, lenMax], 1, RSUNum);
RSUs.m = randi([22, 22], RSUNum, serverNum) / 10;
RSUs.b = randi([80, 80], RSUNum, serverNum);
RSUs.staticPower = randi([100, 100], RSUNum, serverNum);
RSUs.sleepPower = randi([40, 40], RSUNum, serverNum);
RSUs.switchOnEnergy = randi([25, 25], RSUNum, serverNum);
RSUs.switchOffEnergy = randi([15, 15], RSUNum, serverNum);
RSUs.switchOnTime = randi([2, 2], RSUNum, serverNum) / 10;
RSUs.switchOffTime = randi([1, 1], RSUNum, serverNum) / 10;
RSUs.transmissionRate = ones(1, RSUNum) * 5 * 1024; %wireless communication bandwidth

APPs = ClassApps;
APPs.appNum = appNum;
APPs.status = zeros(1, appNum);
APPs.group = [];
APPs.velocity = 100/3.6*ones(1, appNum);
APPs.dateSize = randi([100, 500], 1, appNum);
APPs.taskNum = zeros(1, appNum);
APPs.generateTime = zeros(1, appNum);
APPs.deadline = zeros(1, appNum);
APPs.segment = [randi([1, RSUNum], 1, appNum); randi([0, 1], 1, appNum)];
% APPs.computation = computationTime;
for k = 1 : runTime*generateFreq
    for i = 1:typeNum
        AppType = i;
        APPs.generateTime(i+(k-1)*typeNum) = (k-1)/generateFreq+i/(generateFreq*10);
        APPs = GenerateTypesDAGFunc(APPs, AppType, i+(k-1)*typeNum, communicationTimeRange);
        if k==1
        APPs.computation{i} = randi([taskExeMin, taskExeMax], 1, APPs.taskNum(i))/10;
        end
        if mod(i+(k-1)*typeNum,10)~=0
            APPs.computation{i+(k-1)*typeNum}=APPs.computation{mod(i+(k-1)*typeNum,10)};
        else
            APPs.computation{i+(k-1)*typeNum} = APPs.computation{10};
        end
        exeMinTime = sum(APPs.computation{i+(k-1)*typeNum}) / max(RSUs.capability(:,end));

        if isempty(find(scaleAppTypeArray == AppType))
            APPs.deadline(i+(k-1)*typeNum) = APPs.generateTime(i+(k-1)*typeNum) + exeMinTime * deadlineGapTime;
        else
            APPs.deadline(i+(k-1)*typeNum) = (APPs.generateTime(i+(k-1)*typeNum) + exeMinTime * deadlineGapTime) * deadlineGapTimeScale;
        end
    end
end

end
end
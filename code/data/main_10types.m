clear
clc
close all


for n= 1:10
for kn = 1:100
generateFreq = n/10; %����Ƶ��
runTime = 10; %����ʱ��
saveExeTimeNum = 30; %����exeTimeNum����app���㷨����ʱ��
typeNum = 10; %DAG����
collectAppNum = 1; %�ռ����ܵ��������
collectTimeSlot = 5; %�ռ����ܵ����ʱ����
deadlineGapTime = 2; %��ֹʱ���������ִ��ʱ��ı���
scaleAppTypeNum = 5; %ѡȡ������DAG������deadline���зŴ�
deadlineGapTimeScale = 1; %���������app�Ľ�ֹʱ�������зŴ�

RSUNum = 5; % road side unit����
serverNum = 5; % ÿ��RSU�а�����server����
capMin = 1; %server������������
capMax = 5; %server������������
lenMin = 200; %��·�ֶγ�������
lenMax = 200; %��·�ֶγ�������
appNum = runTime*generateFreq * typeNum; %app������
taskExeMin = 1; %����ִ�е����ʱ��
taskExeMax = 4; %����ִ�е��ʱ��
communicationTimeRange = [0.01, 0.1]; %����ʱ��ķ�Χ

scaleAppTypeArray = sort(randperm(typeNum, scaleAppTypeNum)); %ѡ��deadline�Ŵ��type
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
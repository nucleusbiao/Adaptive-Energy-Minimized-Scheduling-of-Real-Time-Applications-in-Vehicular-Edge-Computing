clear
clc
close all

RSUNum = 5; % road side unit����
serverNum = 5; % ÿ��RSU�а�����server����
capMin = 1; %server������������
capMax = 5; %server������������
lenMin = 25; %��·�ֶγ�������
lenMax = 25; %��·�ֶγ�������
appNum = 20; %app������
taskNumMin = 5; %ÿ��app������������
taskNumMax = 20; %ÿ��app�����������
taskExeMin = 1; %����ִ�е����ʱ��
taskExeMax = 4; %����ִ�е��ʱ��
collectAppNum = 2; %�ռ����ܵ��������
collectTimeSlot = 8; %�ռ����ܵ����ʱ����
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
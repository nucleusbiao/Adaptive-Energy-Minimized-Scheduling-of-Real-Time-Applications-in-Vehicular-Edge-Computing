function [ESTForiTask,pos] = ESTForiTaskFunc( schedule, APPs, appIndex, taskIndex, RSUs, rsuIndex, serverIndex, predArray, arrivalTime )
% Used to calculate the earliest start time of the task on the server
serverNum = RSUs.serverNum;
preTaskNum = 0; % Used to mark that there are several previous tasks associated with this task
taskExcutionTime = ExecutionTimeFunc(APPs.computation{appIndex}(taskIndex), RSUs.capability(rsuIndex,serverIndex)); %����taskIndex��serverIndex�е�ִ��ʱ��
eval(strcat('scheduleTemp = schedule{rsuIndex}.server',num2str(serverIndex),';'));
for i=1:size(predArray,2) 
    if predArray(i)>0
        preTaskNum = preTaskNum + 1;
    end
end
STwhenServerEmpty = max([arrivalTime, RSUs.switchOnTime(rsuIndex, serverIndex)]); %start time when server is empty

if preTaskNum==0 %û��ǰ������ʱ����Ϊ��app��entry����
    if isempty(scheduleTemp) %������û��ִ������
        pos = inf;
        ESTForiTask = STwhenServerEmpty;
    else % ��Ȼû��ǰ�����񣬵��˴�����֮ǰ���������ʱ������Ƕ�����񣡣�
        ESTForiTask = max([max(scheduleTemp(:,3)), STwhenServerEmpty]);
        FinishArray = [];
        BiginArray = [];
        for rowIndex = 1:size(scheduleTemp,1) % �Ѹô���������������Ŀ�ʼʱ��ͽ���ʱ�������
            FinishArray = [FinishArray, scheduleTemp(rowIndex,3)];
            BiginArray = [BiginArray, scheduleTemp(rowIndex,1)];
        end
        FinishArray = sort(FinishArray);
        BiginArray = sort(BiginArray);
        for q = 1:size(scheduleTemp, 1)+1  % ����Ƕ������
            if q == size(scheduleTemp, 1)+1
                pos = inf;
                ESTForiTask = max(FinishArray(q-1),STwhenServerEmpty);
                break
            end
            if BiginArray(q) < STwhenServerEmpty
                continue
            end
            if q == 1 % ����Ƕ�������������һ������֮ǰʱ           
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
    
else % ��ǰ������ʱ
    predNumCount = 0;
    ESTForiTaskArray = [];
    for i = 1:serverNum %�ҵ�����ǰ������
        eval(strcat('scheduleI = schedule{rsuIndex}.server',num2str(i),';'));
        if isempty(scheduleI)
            continue
        end
        ProArray = [];
        for j = 1:size(scheduleI,1) % �Ѵ������е�������Ŵ�����
            if scheduleI(j,6) == appIndex
                ProArray = [ProArray, scheduleI(j,5)];
            end
        end
        intersectionArray = intersect(predArray, ProArray); % �ҳ��ô�������ǰ������
        if isempty(intersectionArray) % �ô���������ǰ������ʱ
            continue
        end
        for k = 1:size(intersectionArray,2) % �ô���������ǰ������ʱ
            for g = 1:size(scheduleI,1) % ѡ��ǰ���������
                if scheduleI(g, 5)==intersectionArray(k) && scheduleI(g, 6)==appIndex
                    break
                end
            end
            if i == serverIndex
                ESTForiTaskArray = [ESTForiTaskArray, scheduleI(g, 3)];
                predNumCount = predNumCount+1;
%                 intersectionArray(k) = []; % �����ҵ���ǰ������ȥ������ûд��
            else
                ESTForiTaskArray = [ESTForiTaskArray, scheduleI(g, 3) + APPs.E{appIndex}(intersectionArray(k),taskIndex)];
                predNumCount = predNumCount+1;
%                 intersectionArray(k) = []; % �����ҵ���ǰ������ȥ������ûд��
            end
        end
        if predNumCount == preTaskNum % ǰ�������Ѿ���ȫ�����
            break;
        end
    end
    if predNumCount ~= preTaskNum
        error('EST�������Ҳ�ȫǰ������');
    end
    
    ESTDescendArray = sort(ESTForiTaskArray, 'descend');
    ESTByPreTasks = ESTDescendArray(1); %ǰ��������������ʱ�䣨�ѿ��Ǵ���ʱ�䣩
    FinishArray = [];
    BiginArray = [];
    for rowIndex=1:size(scheduleTemp,1) % �Ѹô���������������Ŀ�ʼʱ��ͽ���ʱ�����������������Ƕ��
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
        for q = 1:size(scheduleTemp,1) % ����Ƕ������
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
function [ schedule ] = SortScheduleFunc(schedule, RSUNum, serverNum)
%��schedule��ÿ��rsu ��ÿ��server�����ݿ�ʼʱ����������Ա��������������
for i = 1:RSUNum
    for j = 1:serverNum
        eval(strcat('schedule{i}.server',num2str(j),'=sortrows(schedule{i}.server',num2str(j),');'));
    end
end
end
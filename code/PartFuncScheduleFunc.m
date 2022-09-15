function [schedule, energy] = PartFuncScheduleFunc(schedule, APPs, appIndex, RSUs, rsuIndex)
%  ������ⲿ�ֹ��ܣ�һ��app�򼸸�apps���ĵ��Ƚ��
serverNum = RSUs.serverNum;
workServerNum = 1;
energy = Inf;
if length(appIndex) == 1 %һ��app�ĵ��Ƚ�����ܺ�
    while energy == Inf
        if workServerNum > serverNum
            break;
        end
        [schedule, energy] = AppScheduleFunc(schedule, APPs, appIndex, RSUs, rsuIndex, workServerNum);
        workServerNum = workServerNum + 1;
    end
else %����app�ĵ��Ƚ�����ܺ�
    while energy == Inf
        if workServerNum > serverNum
            break;
        end
        [schedule, energy] = AppGroupScheduleFunc(schedule, APPs, appIndex, RSUs, rsuIndex, workServerNum);
        workServerNum = workServerNum + 1;
    end
end
end
function [schedule, energy] = PartFuncScheduleFunc(schedule, APPs, appIndex, RSUs, rsuIndex)
%  用于求解部分功能（一个app或几个apps）的调度结果
serverNum = RSUs.serverNum;
workServerNum = 1;
energy = Inf;
if length(appIndex) == 1 %一个app的调度结果和能耗
    while energy == Inf
        if workServerNum > serverNum
            break;
        end
        [schedule, energy] = AppScheduleFunc(schedule, APPs, appIndex, RSUs, rsuIndex, workServerNum);
        workServerNum = workServerNum + 1;
    end
else %几个app的调度结果和能耗
    while energy == Inf
        if workServerNum > serverNum
            break;
        end
        [schedule, energy] = AppGroupScheduleFunc(schedule, APPs, appIndex, RSUs, rsuIndex, workServerNum);
        workServerNum = workServerNum + 1;
    end
end
end
function priorityOrder = upwardRankGroupFunc(APPs, exeAppIndexArray, RSUs, rsuIndex)
%计算exeAppIndexArray中多个app的优先值和优先级
%计算时已经为具体的apps选择了具体的RSU
rankUvalueArray = [];
for n = 1:size(exeAppIndexArray, 2)
    appIndex = exeAppIndexArray(n);
    taskNum = APPs.taskNum(appIndex);
    rankUvalueInitial = zeros(1, taskNum);
    for i = 1:size(APPs.E{appIndex}, 1)
        [rankUvalueI, rankUvalueInitial] = rankUvalueFunc(APPs, appIndex, i, rankUvalueInitial, RSUs, rsuIndex);
        if ~eq(min(rankUvalueInitial),0)
            break
        end
    end
    rankUvalueArray = [rankUvalueArray, [APPs.deadline(appIndex)-rankUvalueInitial; 1:taskNum; appIndex*ones(1,taskNum)]];
end
[value, order] = sortrows(rankUvalueArray');
priorityOrder = value(:,2:3)'; %第一行为taskIndex，第二行为appIndex
end
function priorityOrder = upwardRankFunc(APPs, appIndex, RSUs, rsuIndex)
%计算Applications中第appIndex功能的优先值和优先级
%计算时已经为具体的application选择了具体的RSU
rankUvalueInitial = zeros(1, APPs.taskNum(appIndex));
for i = 1:size(APPs.E{appIndex}, 1)
    [rankUvalueI, rankUvalueInitial] = rankUvalueFunc(APPs, appIndex, i, rankUvalueInitial, RSUs, rsuIndex);
    if ~eq(min(rankUvalueInitial),0)
        break
    end
end
% APPs.rank{appIndex} = rankUvalueInitial;
[B, priorityOrder] = sort(rankUvalueInitial, 'descend');
% APPs.priorityOrder{appIndex} = priorityOrder;
end
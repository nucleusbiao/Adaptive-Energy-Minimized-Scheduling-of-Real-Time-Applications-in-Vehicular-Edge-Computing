function priorityOrder = upwardRankFunc(APPs, appIndex, RSUs, rsuIndex)
%����Applications�е�appIndex���ܵ�����ֵ�����ȼ�
%����ʱ�Ѿ�Ϊ�����applicationѡ���˾����RSU
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
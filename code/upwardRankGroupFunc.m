function priorityOrder = upwardRankGroupFunc(APPs, exeAppIndexArray, RSUs, rsuIndex)
%����exeAppIndexArray�ж��app������ֵ�����ȼ�
%����ʱ�Ѿ�Ϊ�����appsѡ���˾����RSU
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
priorityOrder = value(:,2:3)'; %��һ��ΪtaskIndex���ڶ���ΪappIndex
end
function [choiceRSUIndex] = MinGroupEnergyRSUIndexFunc(energyMatrix, choiceRSUIndex, choiceAppIndex, choiceRSUIndexArray, scheduleManner)
%Ӧ��choiceAppIndexҪ�����䵽choiceRSUIndex��������app���䵽�����ѷ���app��RSU��ʱ�᲻���ܺĸ�С
%�ҳ������������С�ܺĵķ�ʽ
energyRSU = [energyMatrix(choiceRSUIndex, choiceAppIndex), choiceRSUIndex]; %��choiceAppIndex����ԭ�ص��ܺ�
for i = 1:length(choiceRSUIndexArray)
    RSUIndexTemp = choiceRSUIndexArray(i);
    eval(strcat('energyRSU(1,1) = energyRSU(1,1)+energyMatrix(RSUIndexTemp,scheduleManner.RSU',num2str(RSUIndexTemp),'(1));'))
end
for i = 1:length(choiceRSUIndexArray) %��choiceAppIndex�������Ѵ���app��rus���н�ϵ��ܺ�
    RSUIndexTemp = choiceRSUIndexArray(i);
    energyRSU(end+1, :) = [0, RSUIndexTemp];
    for j = 1:length(choiceRSUIndexArray)
        if RSUIndexTemp == choiceRSUIndexArray(j)
            energyTemp = energyMatrix(RSUIndexTemp, choiceAppIndex);
        else
            eval(strcat('energyTemp = energyMatrix(choiceRSUIndexArray(j), scheduleManner.RSU',num2str(choiceRSUIndexArray(j)),'(1));'));
        end
        energyRSU(end, 1) = energyRSU(end,1) + energyTemp;
    end
end
%�ҳ������������С�ܺĵķ�ʽ
energyRSU = sortrows(energyRSU);
choiceRSUIndex = energyRSU(1, 2);
end
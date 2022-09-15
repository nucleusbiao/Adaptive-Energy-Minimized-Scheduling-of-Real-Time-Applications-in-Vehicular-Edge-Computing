function [choiceRSUIndex] = MinGroupEnergyRSUIndexFunc(energyMatrix, choiceRSUIndex, choiceAppIndex, choiceRSUIndexArray, scheduleManner)
%应用choiceAppIndex要被分配到choiceRSUIndex，看看该app分配到其他已分配app的RSU中时会不会能耗更小
%找出所有组合中最小能耗的方式
energyRSU = [energyMatrix(choiceRSUIndex, choiceAppIndex), choiceRSUIndex]; %把choiceAppIndex留在原地的能耗
for i = 1:length(choiceRSUIndexArray)
    RSUIndexTemp = choiceRSUIndexArray(i);
    eval(strcat('energyRSU(1,1) = energyRSU(1,1)+energyMatrix(RSUIndexTemp,scheduleManner.RSU',num2str(RSUIndexTemp),'(1));'))
end
for i = 1:length(choiceRSUIndexArray) %把choiceAppIndex与其他已存在app的rus进行结合的能耗
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
%找出所有组合中最小能耗的方式
energyRSU = sortrows(energyRSU);
choiceRSUIndex = energyRSU(1, 2);
end
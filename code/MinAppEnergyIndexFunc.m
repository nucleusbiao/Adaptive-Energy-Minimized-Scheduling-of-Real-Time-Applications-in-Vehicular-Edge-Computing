function [x, y] = MinAppEnergyIndexFunc(energyMatrix, doneAppIndexArray)
%找出矩阵中的最小值的索引。x为RSU编号，y为App编号
energyMatrix(:,doneAppIndexArray) = Inf; %避免选择能耗最小值时，重复选择上次的决定。
RSUNum = size(energyMatrix, 1);
minAppEnergy = min(min(energyMatrix));
subscript = find(energyMatrix==minAppEnergy);
yArray = ceil(subscript/RSUNum);
xArray = subscript - (yArray-1)*RSUNum;
x = xArray(1);
y = yArray(1);
end
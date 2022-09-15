function [x, y] = MinAppEnergyIndexFunc(energyMatrix, doneAppIndexArray)
%�ҳ������е���Сֵ��������xΪRSU��ţ�yΪApp���
energyMatrix(:,doneAppIndexArray) = Inf; %����ѡ���ܺ���Сֵʱ���ظ�ѡ���ϴεľ�����
RSUNum = size(energyMatrix, 1);
minAppEnergy = min(min(energyMatrix));
subscript = find(energyMatrix==minAppEnergy);
yArray = ceil(subscript/RSUNum);
xArray = subscript - (yArray-1)*RSUNum;
x = xArray(1);
y = yArray(1);
end
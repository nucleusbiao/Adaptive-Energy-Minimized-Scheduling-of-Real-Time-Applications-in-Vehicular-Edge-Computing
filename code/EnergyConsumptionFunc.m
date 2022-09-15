function energyTotal = EnergyConsumptionFunc(schedule, RSUs)
makeSpanSys = CalculateMakespan(schedule);
RSUNum = RSUs.RSUNum;
serverNum = RSUs.serverNum;

energyMatrix = zeros(4, RSUNum*serverNum); %ÿ��Ϊ��ÿ��server�������ܺġ���̬�ܺġ���̬�ܺġ�ת���ܺ�
for i = 1:RSUNum
    for j = 1:serverNum
        energySleep = 0;
        energyStatic = 0;
        energyDynamic = 0;
        energySwitch = 0;
        eval(strcat('serverTemp = schedule{i}.server',num2str(j),';'));
        if isempty(serverTemp) %û�õ���server
            energySleep = energySleep + RSUs.sleepPower(i,j)*makeSpanSys; %ֻ�������ܺ�
        else %��������server
            
            energySleep = energySleep + (serverTemp(1,1)-RSUs.switchOnTime(i,j))*RSUs.sleepPower(i,j); %server����ǰ�����߹��ġ�ת������
            energySwitch = energySwitch + RSUs.switchOnEnergy(i,j);
            
            for k = 1:size(serverTemp, 1) %server�����в������ܺ�
                energyDynamic = energyDynamic + (RSUs.staticPower(i,j)+RSUs.b(i,j)*RSUs.capability(i,j)^RSUs.m(i,j))*serverTemp(k,2); %server�����еĶ�̬�ܺ�
                if k < size(serverTemp, 1)
                    timeInterval = serverTemp(k+1,1)-serverTemp(k,3);
                    if timeInterval >= RSUs.switchOnTime(i,j)+RSUs.switchOffTime(i,j) %server�����е����߹��ġ�ת������
                        if RSUs.switchOnEnergy+ RSUs.switchOffEnergy+ (timeInterval-RSUs.switchOnTime(i,j)-RSUs.switchOffTime(i,j))* RSUs.sleepPower(i,j) < RSUs.staticPower(i,j)* timeInterval
                            energySleep = energySleep + (timeInterval-RSUs.switchOnTime(i,j)-RSUs.switchOffTime(i,j))* RSUs.sleepPower(i,j);
                            energySwitch = energySwitch + RSUs.switchOnEnergy(i,j) + RSUs.switchOffEnergy(i,j);
                        else
                            energyStatic = energyStatic + RSUs.staticPower(i,j)*timeInterval;
                        end
                    end
                end
            end
            
            if makeSpanSys - serverTemp(end,3) >= RSUs.switchOffTime(i,j) %server����������߹��ġ�ת������
                if RSUs.switchOffEnergy + RSUs.sleepPower(i,j)*(makeSpanSys-serverTemp(end,3)-RSUs.switchOffTime(i,j)) < RSUs.staticPower(i,j)*(makeSpanSys - serverTemp(end,3))
                    energySleep = energySleep + RSUs.sleepPower(i,j)*(makeSpanSys-serverTemp(end,3)-RSUs.switchOffTime(i,j));
                    energySwitch = energySwitch + RSUs.switchOffEnergy(i,j);
                else
                    energyStatic = energyStatic + RSUs.staticPower(i,j)*(makeSpanSys - serverTemp(end,3));
                end
            end
            
        end
        energyMatrix(:, (i-1)*serverNum+j) = [energySleep, energyStatic, energyDynamic, energySwitch]';
    end
end
energyTotal = sum(sum(energyMatrix)');
end
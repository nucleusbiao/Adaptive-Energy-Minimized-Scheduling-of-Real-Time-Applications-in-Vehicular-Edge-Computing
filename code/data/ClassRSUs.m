classdef ClassRSUs %����m��RSU��ÿ��RSU�ж���n��server
   properties
       RSUNum % road side unit������1��1
       serverNum % ÿ��RSU�а�����server������1��1
       capability %����RSU�е�servers�Ĵ���������m��n
       length %·���ֳ�m�飬ÿ��ĳ��ȡ�1��m
       m %��̬�ܺļ���ʱ��capability��ϵ������Ҫ����2��m��n
       b %��̬�ܺļ���ʱ�ĳ���beta��m��n
       staticPower %��̬�Ĺ��ʣ�����ʱ��Ϊ���ģ���m��n
       sleepPower %���ߵĹ��ʡ�m��n
       switchOnEnergy %��server��Ҫ���ܺġ�m��n
       switchOffEnergy %�ر�server��Ҫ���ܺġ�m��n
       switchOnTime %��server��Ҫ��ʱ�䡣m��n
       switchOffTime %�ر�server��Ҫ��ʱ�䡣m��n
       transmissionRate %server�Ĵ����ʣ���application��dateSizeһ������������ʱ�䡣1��m
   end
end
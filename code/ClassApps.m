classdef ClassApps %������ʱ������application��ÿ�������ж�����񡣼�����num��application
   properties
       appNum %���ڶ��ٸ�application
       taskNum %ÿ��application�е�task������1��num
       generateTime %ÿ��app�Ĳ���ʱ�䡣1��num
       status %����app��ִ�����1Ϊ��ִ�У�0Ϊδ��ִ�С�1��num
       group %apps�ķ������
       velocity %ÿ����/���ܵ��ٶȡ�1��num
       dateSize %ÿ�����ܵ�����������Ҫ���Դ����������㴫��ʱ�䡣1��num
       deadline %ÿ�����ܵĽ�ֹʱ��Ҫ��1��num
       makeSpanApp %ÿ�����ܵ�ʵ�����ʱ�䡣1��num
       computation %ÿ��application���и��Ե�tasks��ÿ������ļ�����(����server��capability����������ִ��ʱ��)
       E %�����Ƿ�����Ⱥ�Լ����ϵ������0Ϊ���ڣ� С��0Ϊ������
       segment %Ӧ����ÿ�������ڵ�·���Լ����򣬵�һ��·�κ�(��ӦrsuIndex)����2�з���1Ϊ��RSU��Ŵ�ķ����ߣ�0��֮����2��num
       rank %����ֵ��
       priorityOrder %���ȼ���
   end
end
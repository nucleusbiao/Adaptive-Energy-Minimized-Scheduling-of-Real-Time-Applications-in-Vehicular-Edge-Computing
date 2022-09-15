function Gante(schedule)
makespan = CalculateMakespan(schedule);
RSUNum = length(schedule);
serverNum = length(fieldnames(schedule{1}));
allServerNum = RSUNum * serverNum;
color = [146/255 208/255 80/255;1 192/255 0;0 176/255 240/255;1 0 0]; % �̣��ƣ�������

figure
axis([0,makespan*1.2,0,allServerNum+0.5]);%x�� y��ķ�Χ
%set(gca,'xtick',0:cell((max(dt)+1)/10):max(dt)+1);%x�����������
set(gca,'ytick',0:1:allServerNum+0.5) ;%y�����������
xlabel('Time'),ylabel('Server');%x�� y�������
temp=['SL=',num2str(makespan)];
title(temp);%ͼ�εı���

rec=[0,0,0,0];%temp data space for every rectangle
for i = 1:allServerNum
    rec1(1) = 0;
    rec1(2) = i - 1 + 0.7;
    rec1(3) = makespan;
    rec1(4) = 0.6;
    rectangle('Position',rec1,'LineWidth',0.5,'LineStyle','-');
end
yticklabel{1} = ''; %����y�̶ȵ�����
for i = 1:RSUNum
    for j = 1:serverNum
        yticklabel{end+1} = strcat('RSU',num2str(i),'.s',num2str(j));
    end
end
set(gca, 'YTickLabel', yticklabel)
for i = 1:RSUNum
    for j = 1:serverNum
        eval(strcat('scheduleTemp = schedule{i}.server',num2str(j),';'));
        if isempty(scheduleTemp)
            continue;
        end
        rec(2) = (i-1)*serverNum + j - 0.3;  %���ε�������
        rec(4) = 0.6;
        for k = 1:size(scheduleTemp, 1)
            rec(1) = scheduleTemp(k, 1);%���εĺ�����
            rec(3) = scheduleTemp(k, 2);  %���ε�x�᷽��ĳ���
            txt=sprintf('a%d.t%d', scheduleTemp(k,6), scheduleTemp(k,5));
            rectangle('Position',rec, 'LineWidth',0.5, 'LineStyle','-', 'FaceColor',color(1,:));%draw every rectangle
%             text(rec(1)+rec(3)/2-1.2,((i-1)*serverNum+j),txt,'FontName','Times New Roman','FontSize',14);%label the id of every task  ��������������������
            text(rec(1)+rec(3)/2-0.1,((i-1)*serverNum+j),txt,'FontName','Times New Roman','FontSize',10);%label the id of every task  ��������������������
        end
    end
end
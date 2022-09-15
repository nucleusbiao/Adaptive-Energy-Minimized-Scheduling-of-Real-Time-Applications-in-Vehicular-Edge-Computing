function Gante(schedule)
makespan = CalculateMakespan(schedule);
RSUNum = length(schedule);
serverNum = length(fieldnames(schedule{1}));
allServerNum = RSUNum * serverNum;
color = [146/255 208/255 80/255;1 192/255 0;0 176/255 240/255;1 0 0]; % 绿，黄，蓝，红

figure
axis([0,makespan*1.2,0,allServerNum+0.5]);%x轴 y轴的范围
%set(gca,'xtick',0:cell((max(dt)+1)/10):max(dt)+1);%x轴的增长幅度
set(gca,'ytick',0:1:allServerNum+0.5) ;%y轴的增长幅度
xlabel('Time'),ylabel('Server');%x轴 y轴的名称
temp=['SL=',num2str(makespan)];
title(temp);%图形的标题

rec=[0,0,0,0];%temp data space for every rectangle
for i = 1:allServerNum
    rec1(1) = 0;
    rec1(2) = i - 1 + 0.7;
    rec1(3) = makespan;
    rec1(4) = 0.6;
    rectangle('Position',rec1,'LineWidth',0.5,'LineStyle','-');
end
yticklabel{1} = ''; %设置y刻度的名字
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
        rec(2) = (i-1)*serverNum + j - 0.3;  %矩形的纵坐标
        rec(4) = 0.6;
        for k = 1:size(scheduleTemp, 1)
            rec(1) = scheduleTemp(k, 1);%矩形的横坐标
            rec(3) = scheduleTemp(k, 2);  %矩形的x轴方向的长度
            txt=sprintf('a%d.t%d', scheduleTemp(k,6), scheduleTemp(k,5));
            rectangle('Position',rec, 'LineWidth',0.5, 'LineStyle','-', 'FaceColor',color(1,:));%draw every rectangle
%             text(rec(1)+rec(3)/2-1.2,((i-1)*serverNum+j),txt,'FontName','Times New Roman','FontSize',14);%label the id of every task  ，字体的坐标和其他特性
            text(rec(1)+rec(3)/2-0.1,((i-1)*serverNum+j),txt,'FontName','Times New Roman','FontSize',10);%label the id of every task  ，字体的坐标和其他特性
        end
    end
end
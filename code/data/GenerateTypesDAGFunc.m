function [ APPs ] = GenerateTypesDAGFunc(APPs, AppType, i, communicationTimeRange)
times = 100;
if AppType == 1 %对应“第1种.jpg”中的DAG图
    taskNumI = 18;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,[2,3,18]) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(2,(4:6)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(3,(7:9)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(4,12) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(6,(10:11)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(11,(13:14)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(12,(15:17)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(13,18) = randi(communicationTimeRange*times) / times;
elseif AppType == 2 %对应“第2种.jpg”中的DAG图
    taskNumI = 15;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,[4,5,7,8]) = randi(communicationTimeRange*times, 1,4) / times;
    APPs.E{i}(3,[6,9,11,14]) = randi(communicationTimeRange*times, 1,4) / times;
    APPs.E{i}(4,[7,10,12,13]) = randi(communicationTimeRange*times, 1,4) / times;
    APPs.E{i}(5,[8,10,12,13]) = randi(communicationTimeRange*times, 1,4) / times;
    APPs.E{i}(6,[9,11,14,15]) = randi(communicationTimeRange*times, 1,4) / times;
    APPs.E{i}(8,[10,12,13]) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(9,[11,14,15]) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(10,(12:13)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(11,(14:15)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(14,15) = randi(communicationTimeRange*times) / times;
elseif AppType == 3
    taskNumI = 27;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,[2,3,4,20]) = randi(communicationTimeRange*times, 1,4) / times;
    APPs.E{i}(2,5) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(3,6) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(4,7) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(5,8) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(6,[9,20]) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(7,10) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(8,11) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(9,12) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(10,13) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(11,19) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(12,14) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(13,15) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(14,16) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(15,17) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(16,18) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(17,(19:21)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(19,24) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(20,22) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(21,23) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(22,(24:25)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(25,26) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(26,27) = randi(communicationTimeRange*times) / times;
elseif AppType == 4
    taskNumI = 21;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,(2:4)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(2,[4,15]) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(3,(5:6)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(4,(7:8)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(5,9) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(6,(10:12)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(7,13) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(9,14) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(10,[15,18]) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(11,(16:17)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(13,18) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(14,19) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(15,20) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(18,21) = randi(communicationTimeRange*times) / times;
elseif AppType == 5
    taskNumI = 20;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,(2:5)) = randi(communicationTimeRange*times, 1,4) / times;
    APPs.E{i}(2,6) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(3,7) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(4,8) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(5,9) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(6,10) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(7,11) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(8,12) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(9,13) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(10,14) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(12,15) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(13,16) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(14,17) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(15,18) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(16,19) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(19,20) = randi(communicationTimeRange*times) / times;
elseif AppType == 6
    taskNumI = 21;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,(2:6)) = randi(communicationTimeRange*times, 1,5) / times;
    APPs.E{i}(1,18) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(2,11) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(3,7) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(4,8) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(5,9) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(6,10) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(7,16) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(8,(11:12)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(9,13) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(10,14) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(11,(15:16)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(13,18) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(15,17) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(16,18) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(17,19) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(18,20) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(19,21) = randi(communicationTimeRange*times) / times;
elseif AppType == 7
    taskNumI = 21;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,(2:4)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(2,[4,18]) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(3,5) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(4,(6:8)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(5,9) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(6,(10:11)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(7,(12:14)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(11,(15:16)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(12,(17:18)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(16,(19:20)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(18,21) = randi(communicationTimeRange*times) / times;
elseif AppType == 8
    taskNumI = 23;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,[2,9]) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(2,(3:5)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(3,6) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(4,6) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(5,(7:9)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(6,[10,15,18]) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(7,(11:13)) = randi(communicationTimeRange*times, 1,3) / times;
    APPs.E{i}(9,[15,23]) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(11,16) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(12,(17:18)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(13,(19:20)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(19,(21:22)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(21,23) = randi(communicationTimeRange*times) / times;
elseif AppType == 9
    taskNumI = 30;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,(2:5)) = randi(communicationTimeRange*times, 1,4) / times;
    APPs.E{i}(2,6) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(3,7) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(4,7) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(5,8) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(6,9) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(7,(10:14)) = randi(communicationTimeRange*times, 1,5) / times;
    APPs.E{i}(10,15) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(11,16) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(12,17) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(13,18) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(14,29) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(15,19) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(16,27) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(17,20) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(18,21) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(19,22) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(20,23) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(21,24) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(22,30) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(23,25) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(24,[28,30]) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(25,26) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(26,[27,30]) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(27,(28:29)) = randi(communicationTimeRange*times, 1,2) / times;
    APPs.E{i}(28,30) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(29,30) = randi(communicationTimeRange*times) / times;
elseif AppType == 10
    taskNumI = 30;
    APPs.taskNum(i) = taskNumI;
    APPs.E{i} = ones(taskNumI, taskNumI) * -1;
    APPs.E{i}(1,(2:5)) = randi(communicationTimeRange*times, 1,4) / times;
    APPs.E{i}(2,6) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(3,7) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(5,8) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(6,9) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(7,(10:14)) = randi(communicationTimeRange*times, 1,5) / times;
    APPs.E{i}(10,15) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(11,16) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(12,17) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(13,18) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(14,19) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(15,20) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(16,21) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(17,22) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(18,23) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(19,30) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(20,24) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(21,25) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(22,26) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(23,27) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(24,30) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(25,30) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(26,28) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(27,30) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(28,29) = randi(communicationTimeRange*times) / times;
    APPs.E{i}(29,30) = randi(communicationTimeRange*times) / times;
else
    error('没有定义这种DAG');
end
end